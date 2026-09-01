library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cond_compilation_package.all;
use work.aux_package.all;

entity MCU is
    generic (
        WORD_GRANULARITY : boolean := G_WORD_GRANULARITY;
        DATA_BUS_WIDTH   : integer := 32;
        ITCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
        DTCM_ADDR_WIDTH  : integer := G_ADDRWIDTH;
        PC_WIDTH         : integer := G_PC_WIDTH;
        MA_WIDTH         : integer := G_MA_WIDTH;
        DATA_WORDS_NUM   : integer := G_DATA_WORDSNUM;
        CLK_CNT_WIDTH    : integer := 16;
        MULT_WIDTH       : integer := 16
    );
    port (
        -- External inputs
        rst_i               : in  std_logic;
        clk_i               : in  std_logic;
        smclk_i             : in  std_logic;
        divclk_i            : in  std_logic;
        KEY0_i              : in  std_logic;
        KEY1_i              : in  std_logic;
        KEY2_i              : in  std_logic;
        KEY3_i              : in  std_logic;
        SW_i                : in  std_logic_vector(9 downto 0);
        CAPIN1_i            : in  std_logic := '0';
        CAPIN2_i            : in  std_logic := '0';
        UART_RXD_i          : in  std_logic := '1'; 
        -- Board outputs
        PWM_o               : out std_logic;
        LEDR_o              : out std_logic_vector(9 downto 0);
        HEX0_o              : out std_logic_vector(6 downto 0);
        HEX1_o              : out std_logic_vector(6 downto 0);
        HEX2_o              : out std_logic_vector(6 downto 0);
        HEX3_o              : out std_logic_vector(6 downto 0);
        HEX4_o              : out std_logic_vector(6 downto 0);
        HEX5_o              : out std_logic_vector(6 downto 0);
        UART_TXD_o          : out std_logic;

        -- CPU verification
        PC_o                : out std_logic_vector(PC_WIDTH-1 downto 0);
        Instruction_o       : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        INTA_o              : out std_logic;
        GIE_o               : out std_logic;
        INTR_o              : out std_logic;
        MemRead_ctrl_o      : out std_logic;
        RegWrite_ctrl_o     : out std_logic;
        MemWrite_ctrl_o     : out std_logic;
        Branch_ctrl_o       : out std_logic;
        read_data1_o        : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        read_data2_o        : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        write_data_o        : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        alu_res_o           : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        brTaken_o           : out std_logic;
        dtcm_addr_o         : out std_logic_vector(DTCM_ADDR_WIDTH-1 downto 0);
        dtcm_data_wr_o      : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        dtcm_data_rd_o      : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        mclk_cnt_o          : out std_logic_vector(CLK_CNT_WIDTH-1 downto 0);

        -- Peripheral verification outputs
        DataBUS_o           : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
        BTIFG_o             : out std_logic;
        BTCAPR_o            : out std_logic_vector(DATA_BUS_WIDTH-1 downto 0)
    );
end entity MCU;

architecture structure of MCU is
    signal mclk_w     : std_logic;
    signal smclk_w    : std_logic;
    signal divclk_w   : std_logic;
    
    signal DataBUS_w      : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal address_full_w : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal address_w      : std_logic_vector(13 downto 0);
    signal GPIOaddress_w  : std_logic_vector(5 downto 0);
    signal BTaddress_w    : std_logic_vector(5 downto 0);
    signal ICaddress_w    : std_logic_vector(5 downto 0);
    signal UARTaddress_w  : std_logic_vector(6 downto 0);

    signal KEY0_rst_w     : std_logic;
    signal cnt_rst_w      : std_logic;
    signal Reset_w        : std_logic;
    signal MemRead_w      : std_logic;
    signal RegWrite_w     : std_logic;
    signal MemWrite_w     : std_logic;
    signal Branch_w       : std_logic;
    signal INTA_w         : std_logic;
    signal INTR_w         : std_logic;
    signal GIE_w          : std_logic;

    signal read_data1_w   : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal read_data2_w   : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal write_data_w   : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal brTaken_w      : std_logic;
    signal dtcm_addr_w    : std_logic_vector(DTCM_ADDR_WIDTH-1 downto 0);
    signal dtcm_data_wr_w : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal dtcm_data_rd_w : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);
    signal mclk_cnt_w     : std_logic_vector(CLK_CNT_WIDTH-1 downto 0);

    signal IS_w           : std_logic_vector(6 downto 0);
    signal BTIFG_w        : std_logic;
    signal BTCAPR_w       : std_logic_vector(DATA_BUS_WIDTH-1 downto 0);

    signal UART_TXD_w     : std_logic;
    signal UART_RXD_w     : std_logic;
    signal Status_IFG_w   : std_logic;
    signal RX_IFG_w       : std_logic;
    signal TX_IFG_w       : std_logic;
    
    signal PORT_LEDR_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX0_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX1_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX2_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX3_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX4_w    : std_logic_vector(7 downto 0);
    signal PORT_HEX5_w    : std_logic_vector(7 downto 0);

begin
    KEY0_rst_w  <= not KEY0_i;

    Reset_w <= rst_i or cnt_rst_w;
    --------------------------------------------------------------------------
    -- Address-bus wiring
    --------------------------------------------------------------------------
    address_w <= address_full_w(13 downto 0);

    -- GPIO and Timer expect: A13, A5-A2, A0.
    GPIOaddress_w <= address_w(13) & address_w(5 downto 2) & address_w(0);
    BTaddress_w   <= address_w(13) & address_w(5 downto 2) & address_w(0);

    -- Interrupt Controller expects: A13, A5, A3-A0.
    ICaddress_w     <= address_w(13) & address_w(5) & address_w(3 downto 0);
    -- UART expects: A13, A5-A0.
    UARTaddress_w   <= address_w(13) & address_w(5 downto 0);
    --------------------------------------------------------------------------
    -- Interrupt sources
    --------------------------------------------------------------------------
    IS_w(6) <= Status_IFG_w;       -- UART status error: not implemented yet.
    IS_w(0) <= RX_IFG_w;       -- UART RX: not implemented yet.
    IS_w(1) <= TX_IFG_w;       -- UART TX: not implemented yet.
    IS_w(2) <= BTIFG_w;   -- Basic Timer.
    IS_w(3) <= not KEY1_i;  -- Pushbutton 1, active low.
    IS_w(4) <= not KEY2_i;  -- Pushbutton 2, active low.
    IS_w(5) <= not KEY3_i;  -- Pushbutton 3, active low.


    LEDR_o(7 downto 0) <= PORT_LEDR_w;
    LEDR_o(9 downto 8) <= "00";

    --------------------------------------------------------------------------
    -- RV32IM CPU
    --------------------------------------------------------------------------
    CPU : RV32IM_CORE
        generic map (
            WORD_GRANULARITY => WORD_GRANULARITY,
            MODELSIM         => 1,
            DATA_BUS_WIDTH   => DATA_BUS_WIDTH,
            ITCM_ADDR_WIDTH  => ITCM_ADDR_WIDTH,
            DTCM_ADDR_WIDTH  => DTCM_ADDR_WIDTH,
            PC_WIDTH         => PC_WIDTH,
            MA_WIDTH         => MA_WIDTH,
            DATA_WORDS_NUM   => DATA_WORDS_NUM,
            CLK_CNT_WIDTH    => CLK_CNT_WIDTH,
            MULT_WIDTH       => MULT_WIDTH
        )
        port map (
            rst_i            => rst_i,
            clk_i            => mclk_w,
            divclk_i         => divclk_w,
            INTR_i           => INTR_w,
            DataBUS_io       => DataBUS_w,
            PC_o             => PC_o,
            instruction_o    => Instruction_o,
            INTA_o           => INTA_w,
            GIE_o            => GIE_w,
		    Key_rst_o		 => cnt_rst_w,
            MemRead_ctrl_o   => MemRead_w,
            RegWrite_ctrl_o  => RegWrite_w,
            MemWrite_ctrl_o  => MemWrite_w,
            Branch_ctrl_o    => Branch_w,
            read_data1_o     => read_data1_w,
            read_data2_o     => read_data2_w,
            write_data_o     => write_data_w,
            alu_res_o        => address_full_w,
            brTaken_o        => brTaken_w,
            dtcm_addr_o      => dtcm_addr_w,
            dtcm_data_wr_o   => dtcm_data_wr_w,
            dtcm_data_rd_o   => dtcm_data_rd_w,
            mclk_cnt_o       => mclk_cnt_w
        );

    --------------------------------------------------------------------------
    -- GPIO
    --------------------------------------------------------------------------
    GPIO_UNIT : GPIO
        generic map (
            BUS_WIDTH => DATA_BUS_WIDTH
        )
        port map (
            clk_i       => mclk_w,
            rst_i       => Reset_w,
            IOpin_io    => DataBUS_w,
            MemWrite_i  => MemWrite_w,
            MemRead_i   => MemRead_w,
            Address_i   => GPIOaddress_w,
            SW_i        => SW_i(7 downto 0),
            PORT_LEDR_o => PORT_LEDR_w,
            PORT_HEX0_o => HEX0_o,
            PORT_HEX1_o => HEX1_o,
            PORT_HEX2_o => HEX2_o,
            PORT_HEX3_o => HEX3_o,
            PORT_HEX4_o => HEX4_o,
            PORT_HEX5_o => HEX5_o
        );

    --------------------------------------------------------------------------
    -- Memory-mapped Basic Timer
    --------------------------------------------------------------------------
    TIMER_UNIT : BasicTimer
        generic map (
            BUS_WIDTH => DATA_BUS_WIDTH
        )
        port map (
            SMCLK_i    => mclk_w,
            rst_i      => Reset_w,
            Address_i  => BTaddress_w,
            DataBus_io => DataBUS_w,
            MemRead_i  => MemRead_w,
            MemWrite_i => MemWrite_w,
            CAPIN1_i   => CAPIN1_i,
            CAPIN2_i   => CAPIN2_i,
            PWM_o      => PWM_o,
            BTIFG_o    => BTIFG_w,
            BTCAPR_o   => BTCAPR_w
        );
    --------------------------------------------------------------------------
    -- Uart
    --------------------------------------------------------------------------
    Uart_unit : UART 
        generic map (
            BUS_WIDTH => DATA_BUS_WIDTH,
            CLK_FREQ =>  25e6,
            BAUD_RATE => 9600,
            USE_DEBOUNCER => True
        )
        port map (
            CLK         => mclk_w,
            RST         => Reset_w,
            MemRead_i   => MemRead_w,
            MemWrite_i  => MemWrite_w,
            Address_i   => UARTaddress_w,
            DataBus_io  => DataBUS_w,
            UART_RXD    => UART_RXD_i,
            UART_TXD    => UART_TXD_o,
            Status_IFG_o=> Status_IFG_w,
            RX_IFG_o    => RX_IFG_w,
            TX_IFG_o    => TX_IFG_w
        );
    --------------------------------------------------------------------------
    -- Interrupt Controller
    --------------------------------------------------------------------------
    IC_UNIT : InterruptControl
        generic map (
            BUS_WIDTH => DATA_BUS_WIDTH
        )
        port map (
            clk_i      => mclk_w,
            rst_i      => Reset_w,
            rst_btn_i  => KEY0_rst_w,
            Address_i  => ICaddress_w,
            INTA_i     => INTA_w,
            MemRead_i  => MemRead_w,
            MemWrite_i => MemWrite_w,
            IS_i       => IS_w,
            IOpin_io   => DataBUS_w,
            GIE_i      => GIE_w,
            INTR_o     => INTR_w
        );
        --=======================================
        -- PLL module connection
        --=======================================
        G0:
        if G_MODELSIM = 0 generate

            MCLK : PLL
                port map (
                    inclk0 => clk_i,
                    c0     => mclk_w
                );

            SMCLK : PLL_SM
                port map (
                    inclk0 => clk_i,
                    c0     => smclk_w
                );

            DIVCLK : PLL_DIV
                port map (
                    inclk0 => clk_i,
                    c0     => divclk_w
                );

        else generate

            mclk_w   <= clk_i;
            smclk_w  <= smclk_i;
            divclk_w <= divclk_i;

        end generate;
    --------------------------------------------------------------------------
    -- Verification outputs
    --------------------------------------------------------------------------
    INTA_o          <= INTA_w;
    GIE_o           <= GIE_w;
    INTR_o          <= INTR_w;
    MemRead_ctrl_o  <= MemRead_w;
    RegWrite_ctrl_o <= RegWrite_w;
    MemWrite_ctrl_o <= MemWrite_w;
    Branch_ctrl_o   <= Branch_w;
    read_data1_o    <= read_data1_w;
    read_data2_o    <= read_data2_w;
    write_data_o    <= write_data_w;
    alu_res_o       <= address_full_w;
    brTaken_o       <= brTaken_w;
    dtcm_addr_o     <= dtcm_addr_w;
    dtcm_data_wr_o  <= dtcm_data_wr_w;
    dtcm_data_rd_o  <= dtcm_data_rd_w;
    mclk_cnt_o      <= mclk_cnt_w;
    DataBUS_o       <= DataBUS_w;
    BTIFG_o         <= BTIFG_w;
    BTCAPR_o        <= BTCAPR_w;

end architecture structure;
