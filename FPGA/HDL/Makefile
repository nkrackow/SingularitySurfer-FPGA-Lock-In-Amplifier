# Makefile for ICE40UP5K projects


legacysynth.bin: top.v sram16x16.v Flash_to_SRAM.v spi_flash_reader.v sigma_delta.v dds.v mult16x16.v pll.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top -json yosysout.json' $^
	nextpnr-ice40 --freq 30 --up5k --asc pnrout.asc --pcf evn.pcf --json yosysout.json
	icepack pnrout.asc synth.bin


legacyprog: legacysynth.bin
	iceprog $^

sim: top_tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

top_tb.vvp: top_tb.v top.v sram16x16.v Flash_to_SRAM.v spi_flash_reader.v sigma_delta.v dds.v mult16x16.v pll.v
	iverilog -s top_tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

clean:
	rm -f top_tb.vvp synth.bin yosysout.json pnrout.asc


samplesynth.bin: top_sampling.v sram16x16.v adc_host.v Flash_to_SRAM.v spi_flash_reader.v serial_out.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top_sampling -json yosysout_sampling.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout_sampling.asc --pcf sampling.pcf --json yosysout_sampling.json
	icepack pnrout_sampling.asc samplesynth.bin

sampleprog: samplesynth.bin
	iceprog $^

lcdsynth.bin: lcd_top.v lcd_defines.v lcd_display.v delay_counter.v
		yosys -l yosyslog.log -p 'synth_ice40 -top lcd_top -json yosysout_lcd.json' $^
		nextpnr-ice40 --freq 12 --up5k --asc pnrout_lcd.asc --pcf lcdtest.pcf --json yosysout_lcd.json
		icepack pnrout_lcd.asc lcdsynth.bin

lcdprog: lcdsynth.bin
	iceprog $^

UIsynth.bin: top_UI.v UI.v BinToLCD.v lcd_defines.v lcd_display.v delay_counter.v
		yosys -l yosyslog.log -p 'synth_ice40 -top top_UI -json yosysout_UI.json' $^
		nextpnr-ice40 --freq 12 --up5k --asc pnrout_UI.asc --pcf lcdtest.pcf --json yosysout_UI.json
		icepack pnrout_UI.asc UIsynth.bin

UIsynth_pnrgui: top_UI.v UI.v BinToLCD.v lcd_defines.v lcd_display.v delay_counter.v
		yosys -l yosyslog.log -p 'synth_ice40 -top top_UI -json yosysout_UI.json' $^
		nextpnr-ice40 --freq 12 --up5k --asc pnrout_UI.asc --pcf lcdtest.pcf --json yosysout_UI.json --gui
		icepack pnrout_UI.asc UIsynth.bin

UIprog: UIsynth.bin
	iceprog $^

UIsim: top_UI_tb.vvp
	vvp -N $< +vcd +trace +noerror
	gtkwave out.vcd

top_UI_tb.vvp: top_UI_tb.v top_UI.v UI.v BinToLCD.v lcd_defines.v lcd_display.v delay_counter.v
	iverilog -s top_UI_tb -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

synth.bin: TOP_V1.v cordic/cordic.v UI/UI.v UI/BinToLCD.v UI/lcd_defines.v UI/lcd_display.v UI/delay_counter.v sram16x16.v Flash_to_SRAM.v spi_flash_reader.v sigma_delta.v dds.v mult16x16.v pll.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top -json yosysout.json' $^
	nextpnr-ice40 --freq 30 --up5k --asc pnrout.asc --pcf UI/lcdtest.pcf --json yosysout.json
	icepack pnrout.asc synth.bin


prog: synth.bin
	iceprog $^
