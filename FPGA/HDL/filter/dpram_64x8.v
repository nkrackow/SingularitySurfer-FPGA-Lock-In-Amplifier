

module dpram_64x8 (
  input clk,

  input[63:0] indat,
  input[7:0] inaddr,
  input we,

  output[63:0] outdat,
  input[7:0] outaddr

  );




SB_RAM40_4K ram40_4k0 (
.RDATA(outdat[15:0]),
.RADDR(outaddr),
.WADDR(inaddr),
.MASK(16'h0000),
.WDATA(indat[15:0]),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1),
.WCLKE(1'b1),
.WCLK(clk),
.WE(we)
);

SB_RAM40_4K ram40_4k1 (
.RDATA(outdat[31:16]),
.RADDR(outaddr),
.WADDR(inaddr),
.MASK(16'h0000),
.WDATA(indat[31:16]),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1),
.WCLKE(1'b1),
.WCLK(clk),
.WE(we)
);

SB_RAM40_4K ram40_4k2 (
.RDATA(outdat[47:32]),
.RADDR(outaddr),
.WADDR(inaddr),
.MASK(16'h0000),
.WDATA(indat[47:32]),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1),
.WCLKE(1'b1),
.WCLK(clk),
.WE(we)
);

SB_RAM40_4K ram40_4k3 (
.RDATA(outdat[63:48]),
.RADDR(outaddr),
.WADDR(inaddr),
.MASK(16'h0000),
.WDATA(indat[63:48]),
.RCLKE(1'b1),
.RCLK(clk),
.RE(1'b1),
.WCLKE(1'b1),
.WCLK(clk),
.WE(we)
);

endmodule
