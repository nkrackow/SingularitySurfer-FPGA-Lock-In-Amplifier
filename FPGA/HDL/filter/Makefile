 # Makefile for ICE40UP5K projects





CICsim: CIC_tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

CIC_tb.vvp: CIC_tb.v CIC.v dpram_64x8.v
	iverilog -s CIC_tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

filterdemo.bin: filterdemo.v ../adc_host.v ../filter/CIC.v ../filter/dpram_64x8.v ../cordic/cordic.v ../UI/UI.v ../UI/BinToLCD.v ../UI/lcd_defines.v ../UI/lcd_display.v ../UI/delay_counter.v ../sram16x16.v ../Flash_to_SRAM.v ../spi_flash_reader.v ../sigma_delta.v ../dds.v ../mult16x16.v ../pll.v
	yosys -l yosyslog.log -p 'synth_ice40 -top filterdemo -json yosysout.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout.asc --pcf SingularitySurferV1.pcf --json yosysout.json
	icepack pnrout.asc filterdemo.bin


filterprog: filterdemo.bin
	iceprog $^
