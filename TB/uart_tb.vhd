library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE WORK.AUX_PACKAGE.ALL;

entity UART_TB is
end UART_TB;

architecture FULL of UART_TB is

    constant CLK_PERIOD         : time := 20 ns;
    constant UART_PERIOD        : time := 8680.56 ns; -- 115200 baud

    constant UCTL_ADDR_C        : std_logic_vector(6 downto 0) := "1011000";
    constant RXBUF_ADDR_C       : std_logic_vector(6 downto 0) := "1011001";
    constant TXBUF_ADDR_C       : std_logic_vector(6 downto 0) := "1011010";

    constant DATA_VALUE_C       : std_logic_vector(7 downto 0) := "10100111";
    constant DATA_VALUE2_C      : std_logic_vector(7 downto 0) := "00110110";

    signal CLK                  : std_logic := '0';
    signal RST                  : std_logic := '1';

    signal MemRead_i            : std_logic := '0';
    signal MemWrite_i           : std_logic := '0';
    signal Address_i            : std_logic_vector(6 downto 0) := (others => '0');
    signal DataBus_io           : std_logic_vector(31 downto 0);
    signal TB_DataBus_w         : std_logic_vector(31 downto 0) := (others => '0');
    signal TB_BusEnable_w       : std_logic := '0';

    signal UART_TXD             : std_logic;
    signal UART_RXD             : std_logic := '1';

    signal Status_IFG_o         : std_logic;
    signal RX_IFG_o             : std_logic;
    signal TX_IFG_o             : std_logic;

    signal StartTest_s          : std_logic := '0';
    signal TXChecksDone_s       : std_logic := '0';

begin

    -- The testbench drives the shared bus only during a write.
    DataBus_io <= TB_DataBus_w when TB_BusEnable_w = '1' else (others => 'Z');

    DUT : UART
        generic map (
            BUS_WIDTH     => 32,
            CLK_FREQ      => 50e6,
            BAUD_RATE     => 9600,
            USE_DEBOUNCER => True
        )
        port map (
            CLK          => CLK,
            RST          => RST,
            MemRead_i    => MemRead_i,
            MemWrite_i   => MemWrite_i,
            Address_i    => Address_i,
            DataBus_io   => DataBus_io,
            UART_TXD     => UART_TXD,
            UART_RXD     => UART_RXD,
            Status_IFG_o => Status_IFG_o,
            RX_IFG_o     => RX_IFG_o,
            TX_IFG_o     => TX_IFG_o
        );

    CLK_PROCESS : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    RESET_PROCESS : process
    begin
        RST <= '1';
        wait for CLK_PERIOD*3;
        RST <= '0';
        wait;
    end process;

    -- Memory-mapped CPU-side stimulus.
    BUS_STIMULUS : process
        variable ReadData_v : std_logic_vector(7 downto 0);

        procedure WriteRegister (
            constant RegisterAddress : in std_logic_vector(6 downto 0);
            constant RegisterData    : in std_logic_vector(7 downto 0)
        ) is
        begin
            wait until falling_edge(CLK);
            Address_i      <= RegisterAddress;
            TB_DataBus_w   <= X"000000" & RegisterData;
            TB_BusEnable_w <= '1';
            MemRead_i      <= '0';
            MemWrite_i     <= '1';

            wait until rising_edge(CLK);
            wait for 1 ns;
            MemWrite_i     <= '0';
            TB_BusEnable_w <= '0';
            Address_i      <= (others => '0');
        end procedure;

        procedure ReadRegister (
            constant RegisterAddress : in  std_logic_vector(6 downto 0);
            variable RegisterData    : out std_logic_vector(7 downto 0)
        ) is
        begin
            wait until falling_edge(CLK);
            Address_i      <= RegisterAddress;
            TB_BusEnable_w <= '0';
            MemWrite_i     <= '0';
            MemRead_i      <= '1';

            wait for 1 ns;
            RegisterData := DataBus_io(7 downto 0);

            wait until rising_edge(CLK);
            wait for 1 ns;
            MemRead_i <= '0';
            Address_i <= (others => '0');
        end procedure;

    begin
        MemRead_i      <= '0';
        MemWrite_i     <= '0';
        Address_i      <= (others => '0');
        TB_DataBus_w   <= (others => '0');
        TB_BusEnable_w <= '0';
        StartTest_s    <= '0';

        wait until RST = '0';
        wait until rising_edge(CLK);

        -- UCTL = 0x08: SWRST=0, PENA=0, PEV=0, BAUDRATE=115200.
        WriteRegister(UCTL_ADDR_C, X"08");
        wait until rising_edge(CLK);
        StartTest_s <= '1';

        -- First transmitted byte.
        WriteRegister(TXBUF_ADDR_C, DATA_VALUE_C);

        if TX_IFG_o /= '1' then
            wait until TX_IFG_o = '1';
        end if;
        assert TX_IFG_o = '1'
            report "TXIFG was not set when TXBUF moved to the TX shift register"
            severity error;

        -- Queue the second byte while the first frame is still transmitting.
        wait for 80 us;
        WriteRegister(TXBUF_ADDR_C, DATA_VALUE2_C);

        assert TX_IFG_o = '0'
            report "Writing TXBUF did not clear TXIFG"
            severity error;

        -- Read and verify the first received byte.
        if RX_IFG_o /= '1' then
            wait until RX_IFG_o = '1';
        end if;
        ReadRegister(RXBUF_ADDR_C, ReadData_v);

        assert ReadData_v = DATA_VALUE_C
            report "First RXBUF value is incorrect"
            severity error;

        assert RX_IFG_o = '0'
            report "Reading RXBUF did not clear RXIFG"
            severity error;

        -- Read and verify the second received byte.
        if RX_IFG_o /= '1' then
            wait until RX_IFG_o = '1';
        end if;
        ReadRegister(RXBUF_ADDR_C, ReadData_v);

        assert ReadData_v = DATA_VALUE2_C
            report "Second RXBUF value is incorrect"
            severity error;

        assert RX_IFG_o = '0'
            report "Reading the second byte did not clear RXIFG"
            severity error;

        if TXChecksDone_s /= '1' then
            wait until TXChecksDone_s = '1';
        end if;

        wait for UART_PERIOD;
        ReadRegister(UCTL_ADDR_C, ReadData_v);

        assert ReadData_v(6 downto 4) = "000"
            report "Unexpected UART OE, PE, or FE status"
            severity error;

        assert ReadData_v(3 downto 0) = "1000"
            report "UCTL configuration readback is incorrect"
            severity error;

        assert Status_IFG_o = '0'
            report "Status interrupt was asserted during valid frames"
            severity error;

        assert false
            report "UART memory-mapped test completed successfully"
            severity note;

        wait;
    end process;

    -- Drive two valid, parity-disabled characters into UART_RXD, LSB first.
    RX_STIMULUS : process
        procedure SendRXByte (
            constant ByteData : in std_logic_vector(7 downto 0)
        ) is
        begin
            UART_RXD <= '0'; -- start bit
            wait for UART_PERIOD;

            for i in 0 to 7 loop
                UART_RXD <= ByteData(i);
                wait for UART_PERIOD;
            end loop;

            UART_RXD <= '1'; -- stop bit
            wait for UART_PERIOD;
        end procedure;
    begin
        UART_RXD <= '1';
        wait until StartTest_s = '1';
        wait for UART_PERIOD;

        SendRXByte(DATA_VALUE_C);
        SendRXByte(DATA_VALUE2_C);

        UART_RXD <= '1';
        wait;
    end process;

    -- Verify both bytes transmitted on UART_TXD, LSB first.
    TX_MONITOR : process
        procedure CheckTXByte (
            constant ExpectedData : in std_logic_vector(7 downto 0)
        ) is
        begin
            wait until falling_edge(UART_TXD); -- start bit
            wait for UART_PERIOD + UART_PERIOD/2;

            for i in 0 to 7 loop
                assert UART_TXD = ExpectedData(i)
                    report "Incorrect transmitted data bit"
                    severity error;
                wait for UART_PERIOD;
            end loop;

            assert UART_TXD = '1'
                report "UART transmitted an invalid stop bit"
                severity error;
        end procedure;
    begin
        TXChecksDone_s <= '0';
        wait until StartTest_s = '1';

        CheckTXByte(DATA_VALUE_C);
        CheckTXByte(DATA_VALUE2_C);

        TXChecksDone_s <= '1';
        wait;
    end process;

end FULL;
