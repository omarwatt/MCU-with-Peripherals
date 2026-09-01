---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_compilation_package.all;

package aux_package is
	component MCU is
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
			UART_RXD_i			: in  std_logic := '1';

			-- Board outputs
			PWM_o               : out std_logic;
			LEDR_o              : out std_logic_vector(9 downto 0);
			HEX0_o              : out std_logic_vector(6 downto 0);
			HEX1_o              : out std_logic_vector(6 downto 0);
			HEX2_o              : out std_logic_vector(6 downto 0);
			HEX3_o              : out std_logic_vector(6 downto 0);
			HEX4_o              : out std_logic_vector(6 downto 0);
			HEX5_o              : out std_logic_vector(6 downto 0);
			UART_TXD_o			: out  std_logic;

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
	end component;
---------------------------------------------------------	
	component RV32IM_CORE is
		generic( 
			WORD_GRANULARITY 	: boolean 	:= G_WORD_GRANULARITY;
	    	MODELSIM 			: integer 	:= G_MODELSIM;
			DATA_BUS_WIDTH 		: integer 	:= 32;
			ITCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
			DTCM_ADDR_WIDTH 	: integer 	:= G_ADDRWIDTH;
			PC_WIDTH 			: integer 	:= 10;
			MA_WIDTH 			: integer 	:= 10;
			DATA_WORDS_NUM 		: integer 	:= G_DATA_WORDSNUM;
			CLK_CNT_WIDTH 		: integer 	:= 16;
			MULT_WIDTH 			: integer 	:= 16
		);
		PORT(	
			--Inputs
			rst_i		 	: IN	STD_LOGIC;
			clk_i			: IN	STD_LOGIC;
			divclk_i		: IN	STD_LOGIC;
			INTR_i 			: IN 	STD_LOGIC;
			DataBUS_io		: INOUT STD_LOGIC_VECTOR( DATA_BUS_WIDTH-1 DOWNTO 0 );
			--Outputs (used also for Signal-Tap auxiliary pins)

			pc_o				:OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			instruction_o		:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			INTA_o       		:OUT 	STD_LOGIC;
			GIE_o        		:OUT 	STD_LOGIC;
			Key_rst_o			:OUT 	STD_LOGIC;
			MemRead_ctrl_o 		:OUT 	STD_LOGIC;
			RegWrite_ctrl_o		:OUT 	STD_LOGIC;
			MemWrite_ctrl_o		:OUT 	STD_LOGIC;
			Branch_ctrl_o		:OUT 	STD_LOGIC;
			
			read_data1_o 		:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o 		:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			write_data_o		:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			
			alu_res_o 			:OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);															
			brTaken_o			:OUT 	STD_LOGIC; 
			
			dtcm_addr_o			:OUT 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
			dtcm_data_wr_o		:OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			dtcm_data_rd_o		:OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			
			mclk_cnt_o			:OUT	STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0)
		);		
	end component;
---------------------------------------------------------  
	component control is
		PORT( 
			instruction_i 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
			DataBus_i 			: in 	STD_LOGIC_VECTOR(31 downto 0);
			clk_i				: IN	STD_LOGIC;
			rst_i				: IN	STD_LOGIC;
			DIVBUSY_i			: IN	STD_LOGIC;
			INTR_i				: IN 	STD_LOGIC;
			gp0_i				: IN 	STD_LOGIC;
			--Outputs
			RegDst_ctrl_o 		: OUT 	STD_LOGIC;
			ALUSrc_ctrl_o 		: OUT 	STD_LOGIC;
			MemtoReg_ctrl_o 	: OUT 	STD_LOGIC;
			RegWrite_ctrl_o 	: OUT 	STD_LOGIC;
			MemRead_ctrl_o 		: OUT 	STD_LOGIC;
			MemWrite_ctrl_o	 	: OUT 	STD_LOGIC;
			Branch_ctrl_o 		: OUT 	STD_LOGIC;
			Jal_ctrl_o 			: OUT 	STD_LOGIC;
			Jalr_ctrl_o 		: OUT 	STD_LOGIC;
			WBSrc0_o			: OUT 	STD_LOGIC;
			WBSrc1_o			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			UpperIm_ctrl_o		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUOp_ctrl_o	 	: OUT 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			MULOp_ctrl_o	 	: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			DIV_ctrl_o			: OUT 	STD_LOGIC;
			PChold_o			: OUT 	STD_LOGIC;

			TYPE_ctl_o 			: OUT 	STD_LOGIC;
			Type_addr_o			: OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			GIE_o				: OUT 	STD_LOGIC;
			INTA_o				: OUT 	STD_LOGIC;
			Key_rst_o			: OUT 	STD_LOGIC
		);
	end component;
---------------------------------------------------------	
	component dmemory is
		generic(
			DATA_BUS_WIDTH 	: integer := 32;
			DTCM_ADDR_WIDTH : integer := 8;
			WORDS_NUM 			: integer := 256
		);
		PORT(	
			--Inputs
			clk_i			: IN 	STD_LOGIC;
			rst_i			: IN 	STD_LOGIC;
			dtcm_addr_i 	: IN 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
			dtcm_data_wr_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			MemRead_ctrl_i  : IN 	STD_LOGIC;
			MemWrite_ctrl_i : IN 	STD_LOGIC;
			ALU_res_i		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			Type_addr_i		: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			Type_ctrl_i		: IN 	STD_LOGIC;
			--Outputs
			dtcm_data_rd_o 	: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------		
	component Execute is
		generic(
			DATA_BUS_WIDTH 	: integer := 32;
			MULT_WIDTH 		: integer := 10;
			PC_WIDTH 		: integer := 10
		);
		PORT(	
			--Inputs
			read_data1_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			sign_extend_i 	: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			UpperIm_ctrl_i	: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUOp_ctrl_i	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			MULOp_ctrl_i	: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUSrc_ctrl_i 	: IN 	STD_LOGIC;
			pc_i			: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			--Outputs
			brTaken_o 		: OUT	STD_LOGIC;
			mul_res_o		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			alu_res_o		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			addr_gen_o 		: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------		
	component Idecode is
		generic(
			PC_WIDTH 		: integer	:= 10;
			DATA_BUS_WIDTH	: integer := 32
		);
		PORT(
			--Inputs
			clk_i				: IN 	STD_LOGIC;
			rst_i				: IN 	STD_LOGIC;
			pc_plus4_i			: IN	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			instruction_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			dtcm_data_rd_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			alu_res_i			: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			RegDst_ctrl_i 		: IN 	STD_LOGIC;
			RegWrite_ctrl_i 	: IN 	STD_LOGIC;
			MemtoReg_ctrl_i 	: IN 	STD_LOGIC;
			--Outputs
			gp0_o				: OUT STD_LOGIC;
			read_data1_o		: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o		: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			SignExt_o 			: OUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)		 
		);
	end component;
---------------------------------------------------------		
	component Ifetch is
		generic(
			WORD_GRANULARITY 	: boolean	:= False;
			DATA_BUS_WIDTH 		: integer	:= 32;
			PC_WIDTH 			: integer	:= 10;
			ITCM_ADDR_WIDTH 	: integer	:= 8;
			WORDS_NUM 			: integer	:= 256
		);
		PORT(
			--Inputs
			clk_i			: IN 	STD_LOGIC;
			rst_i 			: IN 	STD_LOGIC;
			addr_gen_i 		: IN 	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			Branch_ctrl_i	: IN 	STD_LOGIC;
			brTaken_i 		: IN 	STD_LOGIC;
			Jal_ctrl_i		: IN 	STD_LOGIC;
			Jalr_ctrl_i		: IN 	STD_LOGIC;
			alu_res_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			PChold_i		: IN	STD_LOGIC;
			--Outputs
			pc_o 			: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			pc_plus4_o 		: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			instruction_o 	: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------
	COMPONENT PLL IS
		port(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0     		: OUT STD_LOGIC ;	
			locked		: OUT STD_LOGIC 
		);
  END COMPONENT;

  COMPONENT PLL_SM IS
		port(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0     		: OUT STD_LOGIC ;	
			locked		: OUT STD_LOGIC 
		);
  END COMPONENT;

  COMPONENT PLL_DIV IS
		port(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0     		: OUT STD_LOGIC ;	
			locked		: OUT STD_LOGIC 
		);
  END COMPONENT;
---------------------------------------------------------	
	COMPONENT DIV is
		generic (
			BUS_WIDTH : INTEGER := 32
		);
		port (
			clk_i       : in  STD_LOGIC;
			rst_i       : in  STD_LOGIC;
			DIVENA_i    : in  STD_LOGIC;

			Dividend_i  : in  STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
			Divisor_i   : in  STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
			
			DIVBUSY_o   : out STD_LOGIC;
			Residue_o   : out STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
			Quotient_o  : out STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0)
		);
	end COMPONENT;
---------------------------------------------------------
	COMPONENT Sync is
		generic (
			BUS_WIDTH : integer := 32
		);
		port (
			divclk_i    : in std_logic;
			rst_i       : in std_logic;
			Ain_i       : in std_logic_vector(BUS_WIDTH-1 downto 0);
			Bin_i       : in std_logic_vector(BUS_WIDTH-1 downto 0);

			Ain_o       : OUT std_logic_vector(BUS_WIDTH-1 downto 0);
			Bin_o       : OUT std_logic_vector(BUS_WIDTH-1 downto 0)
		);
	end COMPONENT;
---------------------------------------------------------
	COMPONENT BidirPin is
		generic( width: integer:=32 );
		port(   
			Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
		);
	end COMPONENT;
---------------------------------------------------------	
	COMPONENT BasicTimer is
		generic(
			BUS_WIDTH: integer := 32
		);
		port (
			SMCLK_i     : in std_logic;
			rst_i       : in std_logic; 
			Address_i   : in std_logic_vector(5 downto 0); --A13,A5-A2,A0
			DataBus_io  : inout std_logic_vector(BUS_WIDTH-1 DOWNTO 0);
			MemRead_i   : in std_logic;
			MemWrite_i  : in std_logic;
			CAPIN1_i    : in std_logic;
			CAPIN2_i    : in std_logic;

			PWM_o       : out std_logic;
			BTIFG_o     : out std_logic;
			BTCAPR_o    : out std_logic_vector(BUS_WIDTH-1 DOWNTO 0)
		);
	end COMPONENT;
---------------------------------------------------------	
	COMPONENT GPIO is
		generic (
			BUS_WIDTH : positive := 32
		);
		port (
			clk_i       : in  std_logic;
			rst_i       : in  std_logic;
			IOpin_io    : inout std_logic_vector(BUS_WIDTH-1 downto 0);

			MemWrite_i  : in  std_logic;
			MemRead_i   : in  std_logic;
			Address_i   : in  std_logic_vector(5 downto 0); -- A13, A5--A2, A0
			SW_i        : in  std_logic_vector(7 downto 0);
			
			PORT_LEDR_o      : out std_logic_vector(7 downto 0);
			PORT_HEX0_o      : out std_logic_vector(6 downto 0);
			PORT_HEX1_o      : out std_logic_vector(6 downto 0);
			PORT_HEX2_o      : out std_logic_vector(6 downto 0);
			PORT_HEX3_o      : out std_logic_vector(6 downto 0);
			PORT_HEX4_o      : out std_logic_vector(6 downto 0);
			PORT_HEX5_o      : out std_logic_vector(6 downto 0)  
		);
	end COMPONENT;
---------------------------------------------------------
	COMPONENT InterruptControl is
		generic (
			BUS_WIDTH : INTEGER := 32
		);
		port (
			clk_i       : in std_logic;
			rst_i       : in std_logic;
			rst_btn_i   : in std_logic;
			Address_i   : in std_logic_vector(5 downto 0); --A13,A5,A3-A0
			INTA_i      : in std_logic;
			MemRead_i   : in std_logic;
			MemWrite_i  : in std_logic;
			IS_i        : in std_logic_vector(6 downto 0); --interrupt source
			IOpin_io    : inout std_logic_vector(BUS_WIDTH-1 downto 0);
			GIE_i       : in std_logic;
			
			INTR_o      : out std_logic
		);
	end COMPONENT;
---------------------------------------------------------
	COMPONENT SSD is
    port (
        ABCD_i : in STD_LOGIC_VECTOR(3 downto 0);
        Hex_o  : out STD_LOGIC_VECTOR(6 downto 0)
    );
	end COMPONENT;
---------------------------------------------------------	
	COMPONENT UART is
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
	end COMPONENT;
---------------------------------------------------------	
end aux_package;


