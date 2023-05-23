restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0
force start 0 0, 1 40, 0 60
force base 2#01010011 0,10#0 80
force exp 2#01110111 0, 10#0 80
run 20000
