restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0

force init1 1 40, 0 80

force init2 1 1000, 0 1040

force init1 1 2800, 0 2840
run 20000