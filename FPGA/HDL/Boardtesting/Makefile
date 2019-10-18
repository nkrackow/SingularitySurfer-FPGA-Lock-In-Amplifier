# Makefile for ICE40UP5K projects





boardtestsynth.bin: boardtest.v
	yosys -l yosyslog.log -p 'synth_ice40 -top boardtest -json yosysout.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout.asc --pcf SingularitySurferV1.pcf --json yosysout.json
	icepack pnrout.asc boardtestsynth.bin

boardtestprog: boardtestsynth.bin
	iceprog $^


samplesynth.bin: top_sampling.v sram16x16.v adc_host.v Flash_to_SRAM.v spi_flash_reader.v serial_out.v
	yosys -l yosyslog.log -p 'synth_ice40 -top top_sampling -json yosysout_sampling.json' $^
	nextpnr-ice40 --freq 36 --up5k --asc pnrout_sampling.asc --pcf sampling.pcf --json yosysout_sampling.json
	icepack pnrout_sampling.asc samplesynth.bin

sampleprog: samplesynth.bin
	iceprog $^
