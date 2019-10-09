# Makefile for ICE40UP5K projects





CICsim: CIC_tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

CIC_tb.vvp: CIC_tb.v CIC.v dpram_64x8.v
	iverilog -s CIC_tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`
