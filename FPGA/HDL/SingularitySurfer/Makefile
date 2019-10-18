# Makefile for SingularitySurfer V1 Board



synth.bin: TOP_V1.v ../adc_host.v ../filter/CIC.v ../filter/dpram_64x8.v ../cordic/cordic.v ../UI/UI.v ../UI/BinToLCD.v ../UI/lcd_defines.v ../UI/lcd_display.v ../UI/delay_counter.v ../sram16x16.v ../Flash_to_SRAM.v ../spi_flash_reader.v ../sigma_delta.v ../dds.v ../mult16x16.v ../pll.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top -json yosysout.json' $^
	nextpnr-ice40 --freq 35.5 --up5k --asc pnrout.asc --pcf SingularitySurferV1.pcf --json yosysout.json
	icepack pnrout.asc synth.bin


prog: synth.bin
	iceprog $^

samplesynth.bin: top_sampling.v ../sram16x16.v ../adc_host.v ../Flash_to_SRAM.v ../spi_flash_reader.v ../serial_out.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top_sampling -json yosysout_sampling.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout_sampling.asc --pcf sampling.pcf --json yosysout_sampling.json
	icepack pnrout_sampling.asc samplesynth.bin

sampleprog: samplesynth.bin
	iceprog $^


lookuptest.bin: lookuptest.v ../sram16x16.v ../adc_host.v ../Flash_to_SRAM.v ../spi_flash_reader.v ../serial_out.v
	yosys -l yosyslog.log -p 'synth_ice40 -top lookuptest -json yosysout_lookuptest.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout_lookuptest.asc --pcf sampling.pcf --json yosysout_lookuptest.json
	icepack pnrout_lookuptest.asc lookuptest.bin

lookupprog: lookuptest.bin
	iceprog $^
