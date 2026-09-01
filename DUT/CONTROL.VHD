--============================================================================
-- Copyright 2026 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
-- Control-Unit module
--============================================================================ 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package.all;


ENTITY control IS
  PORT( 
		--Inputs
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
END control;


ARCHITECTURE behavior OF control IS
	Type	Div_State is (DIV_IDLE,DIV_WAIT,DIV_BUSY,DIV_DONE);
	Type	IC_State is (IC_IDLE,IC_Cycle1,IC_Cycle2);
	SIGNAL	Div_state_q	: Div_State;
	SIGNAL	IC_State_q 	: IC_State;	 
	SIGNAL	Rtype_w, Itype_w, Stype_w, SBtype_w, Utype_w, UJtype_w 								: STD_LOGIC;
	SIGNAL	lb_w, lh_w, lw_w, lbu_w, lhu_w, lwu_w, ld_w, sb_w, sh_w, sw_w, st_w					: STD_LOGIC;
	SIGNAL	beq_w, bne_w, blt_w, bge_w, bltu_w, bgeu_w, branch_w, jal_w, jalr_w 				: STD_LOGIC;
	SIGNAL	add_w, addi_w, and_w, andi_w, or_w, ori_w, sll_w, slli_w, sra_w, srai_w				: STD_LOGIC;
	SIGNAL	srl_w, srli_w, sub_w, xor_w, xori_w, auipc_w, lui_w, slt_w, slti_w, sltu_w, sltiu_w	: STD_LOGIC;
	SIGNAL	mul_w,div_w,rem_w,divide_w	: STD_LOGIC;
	SIGNAL 	DIVHOLD_w	: STD_LOGIC;
	SIGNAL  WBSrc1_w : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL  opc_w : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL 	GIE_q : STD_LOGIC;
	SIGNAL 	Key_rst_q : STD_LOGIC;
	SIGNAL 	Type_addr_q : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL 	reti_w : std_logic;
BEGIN           
	opc_w 		<=	instruction_i(6 DOWNTO 0);
	-- Code to generate control signals using opcode bits
	Rtype_w		<=  '1'	WHEN	opc_w = RTYPE_OPC  ELSE '0';
	Itype_w		<=  '1'	WHEN	(opc_w = ITYPE_OPC) or (ld_w = '1') or (jalr_w = '1') ELSE '0';
	Stype_w 	<=  '1'	WHEN	opc_w = STYPE_OPC  ELSE '0';
	SBtype_w 	<=  '1'	WHEN	opc_w = SBTYPE_OPC ELSE '0';
	Utype_w 	<=  '1'	WHEN	((opc_w and UTYPE_OPC) = UTYPE_OPC)  ELSE '0';
	UJtype_w 	<=  '1'	WHEN	opc_w = UJTYPE_OPC ELSE '0';

	lb_w		<=	'1'	WHEN	(instruction_i and INST_LB_MASK) = INST_LB				ELSE 	'0';	--lb		
	lh_w		<=	'1'	WHEN	(instruction_i and INST_LH_MASK) = INST_LH				ELSE 	'0';	--lh
	lw_w		<=	'1'	WHEN	(instruction_i and INST_LW_MASK) = INST_LW				ELSE 	'0';	--lw
	lbu_w		<=	'1'	WHEN	(instruction_i and INST_LBU_MASK) = INST_LBU			ELSE	'0';	--lbu
	lhu_w		<=	'1'	WHEN	(instruction_i and INST_LHU_MASK) = INST_LHU			ELSE	'0';	--lhu
	lwu_w		<=	'1'	WHEN	(instruction_i and INST_LWU_MASK) = INST_LWU			ELSE	'0';	--lwu
	
	ld_w 		<=	'1' WHEN 	 lb_w or lh_w or lw_w or lbu_w or lhu_w or lwu_w	ELSE	'0';	--Load      

	sb_w		<=	'1'	WHEN	(instruction_i and INST_SB_MASK) = INST_SB				ELSE	'0';	--sb
	sh_w		<=	'1'	WHEN	(instruction_i and INST_SH_MASK) = INST_SH				ELSE	'0';	--sh
	sw_w		<=	'1'	WHEN	(instruction_i and INST_SW_MASK) = INST_SW				ELSE	'0';	--sw																																						               
	
	st_w		<=	'1'	WHEN	sb_w or sh_w or sw_w															ELSE	'0';	--Store   	
													
	beq_w		<=	'1'	WHEN	(instruction_i and INST_BEQ_MASK) = INST_BEQ			ELSE	'0';	--beq												
	bne_w		<=	'1'	WHEN	(instruction_i and INST_BNE_MASK) = INST_BNE			ELSE	'0';	--bne
	blt_w		<=	'1'	WHEN	(instruction_i and INST_BLT_MASK) = INST_BLT			ELSE	'0';	--blt
	bge_w		<=	'1'	WHEN	(instruction_i and INST_BGE_MASK) = INST_BGE			ELSE	'0';	--bge
	bltu_w	<=	'1'	WHEN	(instruction_i and INST_BLTU_MASK) = INST_BLTU		ELSE	'0';	--bltu
	bgeu_w	<=	'1'	WHEN	(instruction_i and INST_BGEU_MASK) = INST_BGEU		ELSE	'0';	--bgeu
	
	branch_w	<=	'1'	WHEN	beq_w or bne_w or blt_w or bge_w or bltu_w or bgeu_w		ELSE	'0';	--Branch     	
																										
	jal_w		<=		'1'	WHEN	(instruction_i and INST_JAL_MASK) = INST_JAL	ELSE 	'0';		--jal	

	jalr_w	<=	'1'	WHEN	(instruction_i and INST_JALR_MASK) = INST_JALR	ELSE 	'0';
	
	add_w		<=	'1' WHEN	(instruction_i and INST_ADD_MASK) = INST_ADD	ELSE	'0';			--add	
	
	addi_w	<=	'1' WHEN	(instruction_i and INST_ADDI_MASK) = INST_ADDI	ELSE	'0';		--addi
	
	auipc_w	<=	'1' WHEN	(instruction_i and INST_AUIPC_MASK) = INST_AUIPC	ELSE	'0';	--auipc
	
	lui_w		<=	'1' WHEN	(instruction_i and INST_LUI_MASK) = INST_LUI	ELSE	'0';			--lui
	
	and_w		<=	'1' WHEN	(instruction_i and INST_AND_MASK) = INST_AND	ELSE	'0';			--and
	
	andi_w	<=	'1' WHEN	(instruction_i and INST_ANDI_MASK) = INST_ANDI	ELSE	'0';		--andi
	
	or_w		<=	'1' WHEN	(instruction_i and INST_OR_MASK) = INST_OR	ELSE	'0';				--or
	
	ori_w		<=	'1' WHEN	(instruction_i and INST_ORI_MASK) = INST_ORI	ELSE	'0';			--ori
	
	sll_w		<=	'1' WHEN	(instruction_i and INST_SLL_MASK) = INST_SLL	ELSE	'0';			--sll
	
	slli_w 	<=	'1' WHEN	(instruction_i and INST_SLLI_MASK) = INST_SLLI	ELSE	'0';		--slli
	
	sra_w 	<=	'1' WHEN	(instruction_i and INST_SRA_MASK) = INST_SRA	ELSE	'0';			-- sra
	
	srai_w 	<=	'1' WHEN	(instruction_i and INST_SRAI_MASK) = INST_SRAI	ELSE	'0';		-- srai
	
	srl_w 	<=	'1' WHEN	(instruction_i and INST_SRL_MASK) = INST_SRL	ELSE	'0';			-- srl
	
	srli_w 	<=	'1' WHEN	(instruction_i and INST_SRLI_MASK) = INST_SRLI	ELSE	'0';		-- srli
	
	sub_w 	<=	'1' WHEN	(instruction_i and INST_SUB_MASK) = INST_SUB	ELSE	'0';			-- sub
	
	xor_w 	<=	'1' WHEN	(instruction_i and INST_XOR_MASK) = INST_XOR	ELSE	'0';			-- xor
	
	xori_w 	<=	'1' WHEN	(instruction_i and INST_XORI_MASK) = INST_XORI	ELSE	'0';		-- xori
	
	slt_w 	<=	'1' WHEN	(instruction_i and INST_SLT_MASK) = INST_SLT	ELSE	'0';			-- slt
	
	slti_w 	<=	'1' WHEN	(instruction_i and INST_SLTI_MASK) = INST_SLTI	ELSE	'0';		-- slti
	
	sltu_w 	<=	'1' WHEN	(instruction_i and INST_SLTU_MASK) = INST_SLTU	ELSE	'0';		-- sltu
	
	sltiu_w <=	'1' WHEN	(instruction_i and INST_SLTIU_MASK) = INST_SLTIU	ELSE	'0';	-- sltiu
	
	mul_w 	 <=	'1' when (instruction_i and INST_MUL_MASK) = INST_MUL ELSE '0'; --MUL

	div_w	<= '1' when (instruction_i and INST_DIV_MASK) = INST_DIV ELSE '0';

	rem_w	<= '1' when (instruction_i and INST_REM_MASK) = INST_REM ELSE '0';

	divide_w	<= div_w or rem_w;

	WBSrc1_w	<= 	"00" when rem_w else
					"01" when div_w else
					"10" when mul_w else
					"11";
					
	Division: process (clk_i,rst_i)
	begin
		if rst_i = '1' then
			Div_state_q <= DIV_IDLE;
		elsif (rising_edge(clk_i)) then
			case Div_state_q is
				when DIV_IDLE =>
					if divide_w = '1' and IC_State_q = IC_IDLE then
						Div_state_q <= DIV_WAIT;
					end if;
				when DIV_WAIT =>	-- in this state we wait for divbust to become 1
					if DIVBUSY_i = '1' then
						Div_state_q <= DIV_BUSY;
					end if;
				when DIV_BUSY =>	-- cheeking if divbusy = 0 which means we finished division
					if DIVBUSY_i = '0' then 
						Div_state_q <= DIV_DONE;
					end if;
				when DIV_DONE =>	
					Div_state_q <= DIV_IDLE; --RF write and then to idle
			end case;
		end if;
	end process;

	DIVHOLD_w	<= '1' when IC_State_q = IC_IDLE and 
							((Div_state_q = DIV_IDLE and divide_w = '1') or
							Div_state_q = DIV_WAIT or
							Div_state_q = DIV_BUSY) else '0';

	reti_w <= '1' when instruction_i = x"00020067" else '0';
	Interrupt: process (clk_i,rst_i)
	begin
		if rst_i = '1' then
			Type_addr_q	<= (others => '0');
			GIE_q		<= '1';
			IC_State_q 	<= IC_IDLE;
			Key_rst_q 	<= '0';
		elsif rising_edge(clk_i) then
			Key_rst_q <= '0';
			case IC_State_q is
				when IC_IDLE =>
					if reti_w = '1' then
						GIE_q <= '1';
					end if;
					if INTR_i = '1' and divide_w = '0' and Div_state_q = DIV_IDLE then --accept intr when no div
						IC_State_q <= IC_Cycle1;
					end if;
				when IC_Cycle1 =>
					GIE_q <= '0';
					Type_addr_q	<= DataBus_i(7 downto 0);
					IC_State_q <= IC_Cycle2;

				when IC_Cycle2 =>
					if Type_addr_q = x"00" then
						GIE_q 		<= '1';
						Key_rst_q 	<= '1';
					end if;
					IC_State_q <= IC_IDLE;
			end case;
		end if;
	end process;

	RegWrite_ctrl_o 	<=  '0' when IC_State_q /= IC_IDLE else '1' when Div_state_q = DIV_DONE else 
							'0' when divide_w = '1' else Rtype_w or Itype_w or Utype_w or UJtype_w;
	MemtoReg_ctrl_o 	<=  ld_w		when IC_State_q = IC_IDLE else '0';
	MemWrite_ctrl_o 	<=  st_w 		when IC_State_q = IC_IDLE else '0';
	MemRead_ctrl_o 		<=  ld_w 		when IC_State_q = IC_IDLE else '0';
	Branch_ctrl_o     	<=	branch_w 	when IC_State_q = IC_IDLE else '0';
	Jal_ctrl_o			<=	jal_w		when IC_State_q = IC_IDLE else '0'; 
	Jalr_ctrl_o			<=	jalr_w		when IC_State_q = IC_IDLE else '0';  
	RegDst_ctrl_o		<=	jal_w or jalr_w;
	ALUSrc_ctrl_o  		<=  Itype_w or Stype_w or Utype_w or UJtype_w;

	WBSrc0_o			<= '1' when WBSrc1_w = "11"  else '0';
	WBSrc1_o 			<= WBSrc1_w;


	UpperIm_ctrl_o		<=	"01" WHEN auipc_w ELSE
							"10" WHEN lui_w   ELSE
							"00";
		  						      		
	ALUOp_ctrl_o		 	<=  ALU_ADD									WHEN	add_w	or addi_w or auipc_w or lui_w or jal_w or jalr_w	or ld_w or st_w ELSE																																																				
												
												ALU_AND									WHEN	and_w or andi_w																ELSE																			
																			
												ALU_OR									WHEN	or_w or ori_w																	ELSE
																										
												ALU_SHIFTL							WHEN	sll_w or	slli_w															ELSE																					
																					
												ALU_SHIFTR_ARITH				WHEN	sra_w or	srai_w															ELSE 																									
																								
												ALU_SHIFTR							WHEN	srl_w or srli_w																ELSE																					
												
												ALU_SUB									WHEN	sub_w																					ELSE	
			
												ALU_XOR									WHEN	xor_w or xori_w																ELSE 	
																																						
												ALU_LESS_THAN_SIGNED		WHEN	slt_w or slti_w 															ELSE
																																																				
												ALU_LESS_THAN_UNSIGNED	WHEN	sltu_w or sltiu_w															ELSE																						
																						
												ALU_BEQ									WHEN	beq_w																					ELSE
												
												ALU_BNE									WHEN	bne_w																					ELSE
												
												ALU_BLT									WHEN	blt_w																					ELSE
												
												ALU_BGE									WHEN	bge_w																					ELSE
												
												ALU_BLTU								WHEN	bltu_w																				ELSE
												
												ALU_BGEU								WHEN	bgeu_w																				ELSE
												
												ALU_NONE;
	
	MULOp_ctrl_o <= Multi_Mul 		when 	mul_w 		else
					Multi_NONE;
	
	DIV_ctrl_o	<= '1' when IC_State_q = IC_IDLE and Div_state_q = DIV_WAIT and divide_w = '1' else '0';
	
	PChold_o <= '1' when DIVHOLD_w = '1' or IC_State_q = IC_Cycle1 else '0'; 


	INTA_o 		<= '0' when IC_State_q = IC_Cycle1 else '1';
	Type_addr_o	<= Type_addr_q;
	TYPE_ctl_o 	<= '1' when IC_State_q = IC_Cycle2 else '0';
	GIE_o 		<= GIE_q and gp0_i;
	Key_rst_o 	<= Key_rst_q;
end behavior;