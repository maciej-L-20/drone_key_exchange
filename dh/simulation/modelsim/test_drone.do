restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0
force init 0 20, 1 40, 0 60

force received 1 600 , 0 620
force mess_input 10#91 600, 0 620
run 20000