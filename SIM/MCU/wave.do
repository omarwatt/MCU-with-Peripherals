onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_mcu/rst_i
add wave -noupdate -radix hexadecimal /tb_mcu/clk_i
add wave -noupdate -radix hexadecimal /tb_mcu/smclk_i
add wave -noupdate -radix hexadecimal /tb_mcu/divclk_i
add wave -noupdate -radix hexadecimal /tb_mcu/KEY0_i
add wave -noupdate -radix hexadecimal /tb_mcu/KEY1_i
add wave -noupdate -radix hexadecimal /tb_mcu/KEY2_i
add wave -noupdate -radix hexadecimal /tb_mcu/KEY3_i
add wave -noupdate -radix hexadecimal /tb_mcu/SW_i
add wave -noupdate -radix hexadecimal /tb_mcu/CAPIN1_i
add wave -noupdate -radix hexadecimal /tb_mcu/CAPIN2_i
add wave -noupdate -radix hexadecimal /tb_mcu/UART_RXD_i
add wave -noupdate -radix hexadecimal /tb_mcu/PWM_o
add wave -noupdate -radix hexadecimal /tb_mcu/LEDR_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX0_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX1_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX2_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX3_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX4_o
add wave -noupdate -radix hexadecimal /tb_mcu/HEX5_o
add wave -noupdate -radix hexadecimal /tb_mcu/UART_TXD_o
add wave -noupdate -radix hexadecimal /tb_mcu/PC_o
add wave -noupdate -radix hexadecimal /tb_mcu/Instruction_o
add wave -noupdate -radix hexadecimal /tb_mcu/INTA_o
add wave -noupdate -radix hexadecimal /tb_mcu/GIE_o
add wave -noupdate -radix hexadecimal /tb_mcu/INTR_o
add wave -noupdate -radix hexadecimal /tb_mcu/MemRead_ctrl_o
add wave -noupdate -radix hexadecimal /tb_mcu/RegWrite_ctrl_o
add wave -noupdate -radix hexadecimal /tb_mcu/MemWrite_ctrl_o
add wave -noupdate -radix hexadecimal /tb_mcu/Branch_ctrl_o
add wave -noupdate -radix hexadecimal /tb_mcu/read_data1_o
add wave -noupdate -radix hexadecimal /tb_mcu/read_data2_o
add wave -noupdate -radix hexadecimal /tb_mcu/write_data_o
add wave -noupdate -radix hexadecimal /tb_mcu/alu_res_o
add wave -noupdate -radix hexadecimal /tb_mcu/brTaken_o
add wave -noupdate -radix hexadecimal /tb_mcu/dtcm_addr_o
add wave -noupdate -radix hexadecimal /tb_mcu/dtcm_data_wr_o
add wave -noupdate -radix hexadecimal /tb_mcu/dtcm_data_rd_o
add wave -noupdate -radix hexadecimal /tb_mcu/mclk_cnt_o
add wave -noupdate -radix hexadecimal /tb_mcu/DataBUS_o
add wave -noupdate -radix hexadecimal /tb_mcu/BTIFG_o
add wave -noupdate -radix hexadecimal /tb_mcu/BTCAPR_o
add wave -noupdate -radix hexadecimal /tb_mcu/seen_timer_s
add wave -noupdate -radix hexadecimal /tb_mcu/seen_key1_s
add wave -noupdate -radix hexadecimal /tb_mcu/seen_key2_s
add wave -noupdate -radix hexadecimal /tb_mcu/seen_key3_s
add wave -noupdate -radix hexadecimal /tb_mcu/seen_key0_s
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/rst_i
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/clk_i
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/divclk_i
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/INTR_i
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/BPADDR_i
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/DataBUS_io
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/pc_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/instruction_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/INTA_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/GIE_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Key_rst_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/MemRead_ctrl_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/RegWrite_ctrl_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/MemWrite_ctrl_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Branch_ctrl_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/read_data1_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/read_data2_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/write_data_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/alu_res_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/brTaken_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/dtcm_addr_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/dtcm_data_wr_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/dtcm_data_rd_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mclk_cnt_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/STRIGGER_o
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/pc_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/pc_ID_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/pc_plus4_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/read_data1_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/read_data2_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/sign_extend_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/addr_gen_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mul_res_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/alu_res_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/alu_res_IF_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/md_mux_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/ALUMD_mux_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/WB_mux_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/dtcm_data_rd_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/data_rd_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/dtcm_addr_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/alu_src_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/branch_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Jal_ctrl_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Jalr_ctrl_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Jalr_ctrl_IF_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/reg_write_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/RegWrite_ID_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/reg_dst_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/RegDst_ID_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/brTaken_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mem_write_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/MemtoReg_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/MemtoReg_ID_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mem_read_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/upper_im_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/alu_op_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Mul_op_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/instruction_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/instruction_ID_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mclk_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/mclk_cnt_q
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/WBSrc0_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/WBSrc1_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/STRIGGER_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/PChold_ctrl_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/PChold_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Ain_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Bin_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/DIV_ctrl_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/DIVBUSY_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Residue_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Quotient_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/gp0_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/GIE_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Key_rst_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/INTA_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/SavePC_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/TYPE_ctrl_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/TYPE_addr_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/Din_w
add wave -noupdate -group CPU -radix hexadecimal /tb_mcu/DUT/CPU/CPU_BusEn_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/IOpin_io
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/MemWrite_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/MemRead_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/Address_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/SW_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_LEDR_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX0_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX1_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX2_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX3_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX4_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX5_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/Din
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/Dout
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/en
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/CS_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN1_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN2_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN3_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN4_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN5_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN6_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/EN7_w
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_LEDR_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX0_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX1_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX2_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX3_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX4_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/PORT_HEX5_q
add wave -noupdate -group GPIO -radix hexadecimal /tb_mcu/DUT/GPIO_UNIT/A0
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/SMCLK_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/rst_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/Address_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/DataBus_io
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/MemRead_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/MemWrite_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPIN1_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPIN2_i
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/PWM_o
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTIFG_o
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCAPR_o
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/Din_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/Dout_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/bus_en_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CS_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCTL1_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCTL2_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCMPR0_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCMPR1_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCAPR_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/reset_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/clk_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/clk_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCNT_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/EQU0_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/EQU1_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPIN1_pre_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPIN2_pre_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAP_pre_q
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAP_out_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAP_Event_w
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPMD
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/CAPISEL
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTOUTMD
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTOUTEN
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTHOLD
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTSSEL
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTCLR
add wave -noupdate -group tIMER -radix hexadecimal /tb_mcu/DUT/TIMER_UNIT/BTINT
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/CLK
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RST
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/MemRead_i
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/MemWrite_i
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/Address_i
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/DataBus_io
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/UART_RXD
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/UART_TXD
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/Status_IFG_o
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RX_IFG_o
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TX_IFG_o
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/CS_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/Dout_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/Din_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/BusEnable_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/UCTL_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/UCTL_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/UARTReset_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/uart_clk_cnt
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/uart_clk_en
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/uart_rxd_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXBUF_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXBUF_full_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXData_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXDataValid_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXFrameError_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXParityError_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXBusy_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXBUF_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXBUF_full_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXReady_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXBusy_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXLaunch_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/FE_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/PE_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/OE_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/RXIFG_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/TXIFG_q
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/Busy_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/ReadRXBUF_w
add wave -noupdate -group UART -radix hexadecimal /tb_mcu/DUT/Uart_unit/WriteTXBUF_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/clk_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/rst_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/rst_btn_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/Address_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/INTA_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/MemRead_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/MemWrite_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IS_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IOpin_io
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/GIE_i
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/INTR_o
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/Dout_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/Din_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/en_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/CS_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/clr_rst_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/clr_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IE_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/Type_in_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/Type_out_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IR_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/rst_in_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/rst_out_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IFG_in_w
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IFG_out_q
add wave -noupdate -expand -group IC -radix hexadecimal /tb_mcu/DUT/IC_UNIT/IFG_or_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109298685 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {108055334 ps} {109971205 ps}
