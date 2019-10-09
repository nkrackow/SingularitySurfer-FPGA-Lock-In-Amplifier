


cordicsim: tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

tb.vvp: tb_cordic.v 
	iverilog -s tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`
