restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0
force init 0 60, 1 80, 0 100
force received 1 10000, 0 10020
force mess_input 10#70 10000, 0 10500
force init 0 11500, 1 11520, 0 11540
force received 1 13200, 0 13220
force mess_input 10#50 13200, 0 13520
run 20000