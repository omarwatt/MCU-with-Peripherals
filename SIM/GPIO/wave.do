onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /gpio_tb/clk
add wave -noupdate -radix hexadecimal /gpio_tb/rst
add wave -noupdate -radix hexadecimal /gpio_tb/MemWrite
add wave -noupdate -radix hexadecimal /gpio_tb/MemRead
add wave -noupdate -radix hexadecimal /gpio_tb/Address
add wave -noupdate -radix hexadecimal /gpio_tb/SW
add wave -noupdate -radix hexadecimal /gpio_tb/DataBus
add wave -noupdate -radix hexadecimal /gpio_tb/TB_Data
add wave -noupdate -radix hexadecimal /gpio_tb/TB_BusEnable
add wave -noupdate -radix hexadecimal /gpio_tb/LEDR
add wave -noupdate -radix hexadecimal /gpio_tb/HEX0
add wave -noupdate -radix hexadecimal /gpio_tb/HEX1
add wave -noupdate -radix hexadecimal /gpio_tb/HEX2
add wave -noupdate -radix hexadecimal /gpio_tb/HEX3
add wave -noupdate -radix hexadecimal /gpio_tb/HEX4
add wave -noupdate -radix hexadecimal /gpio_tb/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1070000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {2360064 ps}
