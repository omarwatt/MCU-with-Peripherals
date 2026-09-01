onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/clk
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/rst
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/rst_btn
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/Address
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/INTA
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/MemRead
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/MemWrite
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/IS_i
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/GIE
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/INTR
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/DataBus
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/TB_Data
add wave -noupdate -radix hexadecimal /interruptcontrol_tb/TB_BusEnable
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/clk_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/rst_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/rst_btn_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/Address_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/INTA_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/MemRead_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/MemWrite_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IS_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IOpin_io
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/GIE_i
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/INTR_o
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/Dout_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/Din_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/en_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/CS_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/clr_rst_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/clr_irq_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IE_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/Type_in_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/Type_out_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IR_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/rst_in_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/rst_out_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IFG_in_w
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IFG_out_q
add wave -noupdate -expand -group DUT -radix hexadecimal /interruptcontrol_tb/DUT/IFG_or_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {267165 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
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
WaveRestoreZoom {0 ps} {1436712 ps}
