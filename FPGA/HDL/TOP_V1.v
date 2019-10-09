
// This is the overall top module for the final rev 1 board

module top (
  input CLK12,

  output wire LCD_RS,
  output wire LCD_RW,
  output wire LCD_E,
  output wire [3:0] SF_D,
  input [3:0] Button,

  output wire [15:0] HC,

  output R,
  output G,
  output B
  );


 //basics
assign LCD_RW=0;
assign {R,G,B}={2'b11,LCD_RS};
reg rst=1;
reg[31:0] cnt=0;

wire clk;


// settings
wire[1:0] gain;
wire[3:0] TC;
wire[2:0] reffreq;
wire[1:0] refampl;
wire refIO;
wire[3:0] debug;


// Signals
wire[31:0] X,Y;
wire[16:0] Mag,Ang;   //17 bits beacuse of sign bit (cordic core)


assign Y=cnt;

always @ ( posedge clk ) begin
  cnt<=cnt+1;
  if(&cnt[5:0]) rst<=0;
end


UI UI_inst (
  clk,
  rst,

  // IO LCD
  LCD_RS,
  LCD_E,
  SF_D,
  // IO buttons
  ~Button,

  // Interface
  // {X[25:10],10'h000},//X,
  // {Y[25:10],10'h000},//Y,
  // X[16:0],//MAG,
  // Y[16:0],//Ang,

  X,//X,
  Y,//Y,
  01234,
  98765,

  gain,
  TC,
  reffreq,
  refampl,
  refIO

  );

// wire[16:0] dummyY;
//
// cordic cordicCORE (
//   .clk(clk),
//   .rst(rst),
//   .x_i(X),
//   .y_i(Y),
//   .theta_i(0),
//   .x_o(Mag),
//   .y_o(dummyY),
//   .theta_o(Ang)
//   );


CIC Filter(
  clk,

  TC,

  cnt,
  X

);




SB_PLL40_CORE #(
	.FEEDBACK_PATH("SIMPLE"),
	.PLLOUT_SELECT("GENCLK"),
  .DIVR(4'b0000),
  .DIVF(7'b1001111),
  .DIVQ(3'b101),
  .FILTER_RANGE(3'b001)
) PLL (
	.LOCK(lock),
	.RESETB(1'b1),
	.BYPASS(1'b0),
	.REFERENCECLK(CLK12),
	.PLLOUTCORE(clk)
);


endmodule
