# SingularitySurfer: An FPGA Lock-In Amplifier
Repository for the development of an FPGA based DSP Lock-In Amplifier.

Currently the FPGA code targets a Lattice iCE40UP5K-B-EVN devboard.

The Lattice ICE40Up5K FPGA will be used as the DSP platform and some additional hardware will be developed.
The project uses the open-source ICESTORM toolchain that is YOSYS for synthesis, NextPNR for place and route and finally ICEPACK/PROG to get it onto the FPGA. The external hardware will be developed in KiCad.

Block Diagram:
![Block Diagram](https://github.com/SingularitySurfer/SingularitySurfer-FPGA-Lock-In-Amplifier/edit/master/LockIn.png)
