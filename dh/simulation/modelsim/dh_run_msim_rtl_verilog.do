transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/SYCY/repo/sycy_23l_projekt/dh {F:/SYCY/repo/sycy_23l_projekt/dh/cc.v}
vlog -vlog01compat -work work +incdir+F:/SYCY/repo/sycy_23l_projekt/dh {F:/SYCY/repo/sycy_23l_projekt/dh/random_generator.v}
vlog -vlog01compat -work work +incdir+F:/SYCY/repo/sycy_23l_projekt/dh {F:/SYCY/repo/sycy_23l_projekt/dh/modularPowering.v}

