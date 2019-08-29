
/*
 *  SRAM
 *
 */

module sram16x16
 (
	input clk,
	input  wen,
	input [15:0] addr,
	input [15:0] wdata,
	output [15:0] rdata
);


	wire [15:0] rdata_0, rdata_1,rdata_2, rdata_3;

	assign rdata = (!addr[15]&&!addr[14]) ? rdata_0 :
	 							 (!addr[15]&&addr[14]) ? rdata_1 :
								 (addr[15]&&!addr[14]) ? rdata_2 : rdata_3;


	SB_SPRAM256KA ram00 (
		.ADDRESS(addr[13:0]),
		.DATAIN(wdata),
		.MASKWREN(4'b1111),
		.WREN(wen),
		.CHIPSELECT(!addr[15]&&!addr[14]),
		.CLOCK(clk),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1),
		.DATAOUT(rdata_0)
	);

	SB_SPRAM256KA ram01 (
		.ADDRESS(addr[13:0]),
		.DATAIN(wdata),
		.MASKWREN(4'b1111),
		.WREN(wen),
		.CHIPSELECT(!addr[15]&&addr[14]),
		.CLOCK(clk),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1),
		.DATAOUT(rdata_1)
	);

	SB_SPRAM256KA ram10 (
		.ADDRESS(addr[13:0]),
		.DATAIN(wdata),
		.MASKWREN(4'b1111),
		.WREN(wen),
		.CHIPSELECT(addr[15]&&!addr[14]),
		.CLOCK(clk),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1),
		.DATAOUT(rdata_2)
	);

	SB_SPRAM256KA ram11 (
		.ADDRESS(addr[13:0]),
		.DATAIN(wdata),
		.MASKWREN(4'b1111),
		.WREN(wen),
		.CHIPSELECT(addr[15]&&addr[14]),
		.CLOCK(clk),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1),
		.DATAOUT(rdata_3)
	);

endmodule
