onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /basictimer_tb/SMCLK
add wave -noupdate -radix hexadecimal /basictimer_tb/rst
add wave -noupdate -radix hexadecimal /basictimer_tb/Address
add wave -noupdate -radix hexadecimal /basictimer_tb/MemRead
add wave -noupdate -radix hexadecimal /basictimer_tb/MemWrite
add wave -noupdate -radix hexadecimal /basictimer_tb/CAPIN1
add wave -noupdate -radix hexadecimal /basictimer_tb/CAPIN2
add wave -noupdate -radix hexadecimal /basictimer_tb/DataBus
add wave -noupdate -radix hexadecimal /basictimer_tb/TB_Data
add wave -noupdate -radix hexadecimal /basictimer_tb/TB_BusEnable
add wave -noupdate -radix hexadecimal /basictimer_tb/PWM
add wave -noupdate -radix hexadecimal /basictimer_tb/BTIFG
add wave -noupdate -radix hexadecimal /basictimer_tb/BTCAPR
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/SMCLK_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/rst_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/Address_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/DataBus_io
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/MemRead_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/MemWrite_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPIN1_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPIN2_i
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/PWM_o
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTIFG_o
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCAPR_o
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/Din_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/Dout_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/bus_en_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CS_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCTL1_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCTL2_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCMPR0_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCMPR1_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCAPR_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/reset_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/clk_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/clk_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCNT_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/EQU0_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/EQU1_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPIN1_pre_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPIN2_pre_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAP_pre_q
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAP_out_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAP_Event_w
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPMD
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/CAPISEL
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTOUTMD
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTOUTEN
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTHOLD
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTSSEL
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTCLR
add wave -noupdate -radix hexadecimal /basictimer_tb/DUT/BTINT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54973 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 235
configure wave -valuecolwidth 148
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
WaveRestoreZoom {0 ps} {148159 ps}
