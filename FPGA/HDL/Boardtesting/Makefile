# Makefile for ICE40UP5K projects





boardtestsynth.bin: boardtest.v 
	yosys -l yosyslog.log -p 'synth_ice40 -top boardtest -json yosysout.json' $^
	nextpnr-ice40 --freq 30 --up5k --asc pnrout.asc --pcf SingularitySurferV1.pcf --json yosysout.json
	icepack pnrout.asc boardtestsynth.bin

boardtestprog: boardtestsynth.bin
	iceprog $^
