# Makefile for ICE40UP5K projects


synth.bin: top.v sram16x16.v Flash_to_SRAM.v spi_flash_reader.v sigma_delta.v dds.v mult16x16.v pll.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top -json yosysout.json' $^
	nextpnr-ice40 --freq 30 --up5k --asc pnrout.asc --pcf evn.pcf --json yosysout.json
	icepack pnrout.asc synth.bin

prog: synth.bin
	iceprog $^

sim: top_tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

top_tb.vvp: top_tb.v top.v sram16x16.v Flash_to_SRAM.v spi_flash_reader.v sigma_delta.v dds.v mult16x16.v pll.v
	iverilog -s top_tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

clean:
	rm -f top_tb.vvp synth.bin yosysout.json pnrout.asc
