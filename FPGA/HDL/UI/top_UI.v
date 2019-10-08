



module top_UI (
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

assign LCD_RW=0;
assign {R,G,B}=~debug[2:0];

wire[1:0] gain;
wire[3:0] TC;
wire[2:0] reffreq;
wire[1:0] refampl;
wire refIO;
wire[3:0] debug;

UI UI_inst (
  CLK12,

  // IO LCD
  LCD_RS,
  LCD_E,
  SF_D,
  // IO buttons
  ~Button,

  // Interface
  0,//X,
  0,//Y,
  0,//Rad,
  0,//Ang,

  gain,
  TC,
  reffreq,
  refampl,
  refIO,

  debug

  );





endmodule
