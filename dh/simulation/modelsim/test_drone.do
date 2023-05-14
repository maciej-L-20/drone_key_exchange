restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0
force init 0 0, 1 40, 0 60
force received 1 10000, 0 100200
force mess_input 10#70 10000
run 20000