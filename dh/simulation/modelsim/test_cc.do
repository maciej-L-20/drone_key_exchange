restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0

force drone_rdy 1 10000, 0 10020
force mess_input_cc 10#363 10000, 0 10020


run 20000