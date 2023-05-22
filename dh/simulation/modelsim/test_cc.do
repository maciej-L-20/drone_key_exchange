restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0

force drone_rdy 1 160, 0 180
force mess_input_cc 10#388 160, 0 180

run 20000