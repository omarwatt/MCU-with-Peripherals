--------------------------------------------------------------------------------
-- PROJECT: SIMPLE UART FOR FPGA
--------------------------------------------------------------------------------
-- MODULE:  UART TOP MODULE
-- AUTHORS: Jakub Cabal <jakubcabal@gmail.com>
-- LICENSE: The MIT License (MIT), please read LICENSE file
-- WEBSITE: https://github.com/jakubcabal/uart-for-fpga
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.aux_package.all;

-- SIMPLE UART FOR FPGA
-- ====================
-- UART FOR FPGA REQUIRES: 1 START BIT, 8 DATA BITS, 1 STOP BIT!!!
-- OTHER PARAMETERS CAN BE SET USING GENERICS.

-- DESCRIPTION OF RELEASED VERSIONS:
-- =================================
-- Version 1.0 - released on 27 May 2016
    -- Initial release.
-- Version 1.1 - released on 20 December 2018
    -- Added better debouncer.
    -- Added simulation script and Quartus project file.
    -- Removed unnecessary resets.
    -- Signal BUSY replaced by DIN_RDY.
    -- Many other optimizations and changes.

entity UART is
    Generic (
        BUS_WIDTH     : positive := 32; 
        CLK_FREQ      : integer := 50e6;   -- system clock frequency in Hz
        BAUD_RATE     : integer := 9600; -- baud rate value
        USE_DEBOUNCER : boolean := True    -- enable/disable debouncer
    );
    Port (
        -- CLOCK AND RESET
        CLK         : in  std_logic; -- system clock
        RST         : in  std_logic; -- high active synchronous reset
        -- BUS
        MemRead_i  : in    std_logic; 
        MemWrite_i : in    std_logic; 
        Address_i  : in    std_logic_vector(6 downto 0); -- A13,A5..A0
        DataBus_io : inout std_logic_vector(BUS_WIDTH-1 downto 0);
        -- UART INTERFACE
        UART_RXD    : in  std_logic; -- serial receive data
        UART_TXD    : out std_logic; -- serial transmit data
        -- USER DATA INPUT INTERFACE
        Status_IFG_o     : out std_logic;
        RX_IFG_o         : out std_logic;
        TX_IFG_o         : out std_logic
    );
end UART;

architecture FULL of UART is

    constant DIVIDER_VALUE    : integer  := CLK_FREQ/(16*BAUD_RATE);
    constant CLK_CNT_WIDTH    : integer  := integer(ceil(log2(real(DIVIDER_VALUE))));
    constant CLK_CNT_MAX      : unsigned := to_unsigned(DIVIDER_VALUE-1, CLK_CNT_WIDTH);

    signal CS_w            : std_logic_vector(2 downto 0);
    signal Dout_w          : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal Din_w           : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal BusEnable_w     : std_logic;

    signal UCTL_q          : std_logic_vector(3 downto 0); -- BAUDRATE, PEV, PENA, SWRST
    signal UCTL_w          : std_logic_vector(7 downto 0);
    signal UARTReset_w     : std_logic;

    signal uart_clk_cnt    : unsigned(CLK_CNT_WIDTH-1 downto 0);
    signal uart_clk_en     : std_logic;
    signal uart_rxd_w      : std_logic;

    signal RXBUF_q         : std_logic_vector(7 downto 0);
    signal RXBUF_full_q    : std_logic;
    signal RXData_w        : std_logic_vector(7 downto 0);
    signal RXDataValid_w   : std_logic;
    signal RXFrameError_w  : std_logic;
    signal RXParityError_w : std_logic;
    signal RXBusy_w        : std_logic;

    signal TXBUF_q         : std_logic_vector(7 downto 0);
    signal TXBUF_full_q    : std_logic;
    signal TXReady_w       : std_logic;
    signal TXBusy_w        : std_logic;
    signal TXLaunch_w      : std_logic;

    signal FE_q            : std_logic;
    signal PE_q            : std_logic;
    signal OE_q            : std_logic;
    signal RXIFG_q         : std_logic;
    signal TXIFG_q         : std_logic;
    signal Busy_w          : std_logic;
    signal ReadRXBUF_w     : std_logic;
    signal WriteTXBUF_w    : std_logic;


begin
    DataBus: BidirPin generic map(width => BUS_WIDTH) port map(Dout => Dout_w, en => BusEnable_w, Din => Din_w, IOpin => DataBus_io);
    with Address_i select
        CS_w <= "001" when "1011000", 
                "010" when "1011001",
                "100" when "1011010",
                "000" when others;
    BusEnable_w <= '1' when MemRead_i = '1' and CS_w /= "000" else '0';
    Dout_w(BUS_WIDTH-1 downto 8) <= (others => '0'); 
    Dout_w(7 downto 0)  <=  UCTL_w      when MemRead_i = '1' and CS_w(0) = '1' else
                            RXBUF_q     when MemRead_i = '1' and CS_w(1) = '1' else
                            TXBUF_q     when MemRead_i = '1' and CS_w(2) = '1' else
                            (others => '0');

    Busy_w  <= RXBusy_w or TXBusy_w;
    UCTL_w(7) <= Busy_w;
    UCTL_w(6) <= OE_q;
    UCTL_w(5) <= PE_q when UCTL_q(1) = '1' else '0';
    UCTL_w(4) <= FE_q;
    UCTL_w(3 downto 0) <= UCTL_q;
    UARTReset_w <= RST or UCTL_q(0);

    ReadRXBUF_w     <= '1' when MemRead_i  = '1' and CS_w(1) = '1' else '0';
    WriteTXBUF_w    <= '1' when MemWrite_i = '1' and CS_w(2) = '1' else '0';

    TXLaunch_w      <= TXBUF_full_q and TXReady_w and not UARTReset_w; 

    UCTL_REG : process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                UCTL_q <= "1001"; 
            elsif MemWrite_i = '1' and CS_w(0) = '1' then
                UCTL_q <= Din_w(3 downto 0);
            end if;
        end if;
    end process;

    -- -------------------------------------------------------------------------
    --  UART CLOCK COUNTER AND CLOCK ENABLE FLAG
    -- -------------------------------------------------------------------------
    uart_clk_cnt_p : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (UARTReset_w  = '1') then
                uart_clk_cnt <= (others => '0');
            else
                if (uart_clk_en = '1') then
                    uart_clk_cnt <= (others => '0');
                else
                    uart_clk_cnt <= uart_clk_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    uart_clk_en <= '1' when (UCTL_q(3) = '0' and uart_clk_cnt >= CLK_CNT_MAX) or
                    (UCTL_q(3) = '1' and   uart_clk_cnt >= to_unsigned(CLK_FREQ/(16*115200)-1,CLK_CNT_WIDTH))
                    else '0';
    -- -------------------------------------------------------------------------
    --  UART RXD DEBAUNCER
    -- -------------------------------------------------------------------------

    use_debouncer_g : if (USE_DEBOUNCER = True) generate
        debouncer_i : entity work.UART_DEBOUNCER
        generic map(
            LATENCY => 4
        )
        port map (
            CLK     => CLK,
            DEB_IN  => UART_RXD,
            DEB_OUT => uart_rxd_w
        );
    end generate;

    not_use_debouncer_g : if (USE_DEBOUNCER = False) generate
        uart_rxd_w <= UART_RXD;
    end generate;

    -- -------------------------------------------------------------------------
    --  UART TRANSMITTER
    -- -------------------------------------------------------------------------
    uart_tx_i: entity work.UART_TX
        port map (
            CLK         => CLK,
            RST         => UARTReset_w,
            UART_CLK_EN => uart_clk_en,
            UART_TXD    => UART_TXD,
            DIN         => TXBUF_q,
            DIN_VLD     => TXLaunch_w,
            DIN_RDY     => TXReady_w,
            PENA_i      => UCTL_q(1),
            PEV_i       => UCTL_q(2),
            TX_BUSY_o   => TXBusy_w
        );

        TX_REG : process (CLK)
        begin
            if rising_edge(CLK) then
                if UARTReset_w = '1' then
                    TXBUF_q      <= (others => '0');
                    TXBUF_full_q <= '0';
                    TXIFG_q      <= '0';
                elsif WriteTXBUF_w = '1' then
                    TXBUF_q      <= Din_w(7 downto 0);
                    TXBUF_full_q <= '1';
                    TXIFG_q      <= '0'; 
                elsif TXLaunch_w = '1' then
                    TXBUF_full_q <= '0';
                    TXIFG_q      <= '1'; 
                end if;
            end if;
        end process;
    -- -------------------------------------------------------------------------
    --  UART RECEIVER
    -- -------------------------------------------------------------------------

    uart_rx_i: entity work.UART_RX
        port map (
            CLK          => CLK,
            RST          => UARTReset_w,
            UART_CLK_EN  => uart_clk_en,
            UART_RXD     => uart_rxd_w,
            PENA_i       => UCTL_q(1),
            PEV_i        => UCTL_q(2),
            DOUT         => RXData_w,
            DOUT_VLD     => RXDataValid_w,
            FRAME_ERROR  => RXFrameError_w,
            PARITY_ERROR => RXParityError_w,
            RX_BUSY_o    => RXBusy_w
        );
    RX_REG : process (CLK)
        begin
            if rising_edge(CLK) then
                if UARTReset_w = '1' then
                    RXBUF_q      <= (others => '0');
                    RXBUF_full_q <= '0';
                    RXIFG_q      <= '0';
                    FE_q         <= '0';
                    PE_q         <= '0';
                    OE_q         <= '0';
                else
                    if ReadRXBUF_w = '1' then
                        RXBUF_full_q <= '0';
                        RXIFG_q      <= '0'; 
                        FE_q         <= '0'; 
                        PE_q         <= '0';
                        OE_q         <= '0';
                    end if;

                    if RXDataValid_w = '1' then
                        RXBUF_q      <= RXData_w;
                        RXBUF_full_q <= '1';
                        RXIFG_q      <= '1'; 

                        if RXFrameError_w = '1' then
                            FE_q <= '1';
                        end if;
                        if RXParityError_w = '1' and UCTL_q(1) = '1' then
                            PE_q <= '1';
                        end if;
                        if RXBUF_full_q = '1' and ReadRXBUF_w = '0' then
                            OE_q <= '1'; 
                        end if;
                    end if;
                end if;
            end if;
        end process;

    RX_IFG_o     <= RXIFG_q;
    TX_IFG_o     <= TXIFG_q;
    Status_IFG_o <= FE_q or PE_q or OE_q;

end FULL;
