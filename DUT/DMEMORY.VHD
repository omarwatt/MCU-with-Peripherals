---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Dmemory module (implements the data memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	generic(
		DATA_BUS_WIDTH 	: integer := 32;
		DTCM_ADDR_WIDTH : integer := 8;
		WORDS_NUM 		: integer := 256
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
END dmemory;

ARCHITECTURE behavior OF dmemory IS
	SIGNAL wrclk_w 		: STD_LOGIC;
	SIGNAL CS_w 		: STD_LOGIC;
	SIGNAL Addr_w  		: STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
BEGIN

	CS_w	<= '1' when ALU_res_i(13) = '0' and MemWrite_ctrl_i = '1' and Type_ctrl_i = '0' else '0';
	Addr_w  <=(DTCM_ADDR_WIDTH-1 downto 6 => '0') & Type_addr_i(7 downto 2) when Type_ctrl_i = '1' else dtcm_addr_i;

	data_memory : altsyncram
	GENERIC MAP  (
		operation_mode				=> "SINGLE_PORT",
		width_a						=> DATA_BUS_WIDTH,
		widthad_a					=> DTCM_ADDR_WIDTH,
		numwords_a 					=> WORDS_NUM,
		lpm_hint 					=> "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = DTCM",
		lpm_type 					=> "altsyncram",
		outdata_reg_a 				=> "UNREGISTERED",
		init_file 					=> "C:\Users\Qosay\Desktop\final project\Benchmark apps\Intrrupt-based IO\test2\bin\M9K-intel\DTCM.hex",
		intended_device_family 		=> "Cyclone"
	)
	PORT MAP (
		wren_a 						=> CS_w,
		clock0						=> wrclk_w,
		address_a					=> Addr_w,
		data_a						=> dtcm_data_wr_i,
		q_a							=> dtcm_data_rd_o	
	);

	wrclk_w <= NOT clk_i;	-- Load memory address register with write clock
	
END behavior;

