
input clk,
  input wire[7:0] addr,
  input wire[7:0] din,
  output wire[7:0] dout,
  inout w_en


module my_SRAM (
  input clk,
  input wire[7:0] addr,
  input wire[7:0] din,
  output wire[7:0] dout,
  inout w_en
  );


  SB_SPRAM256KA ram00 (
		.ADDRESS(addr[7:0]),
		.DATAIN(din[7:0]),
		.MASKWREN({wen[1], wen[1], wen[0], wen[0]}),
		.WREN(w_en),
		.CHIPSELECT(1'b1),
		.CLOCK(clk),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1),
		.DATAOUT(dout[7:0])
	);



endmodule //my_SRAM
