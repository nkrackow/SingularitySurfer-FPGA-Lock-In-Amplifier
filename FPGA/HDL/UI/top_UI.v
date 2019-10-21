



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
assign {R,G,B}={2'b11,LCD_RS};

wire[1:0] gain;
wire[3:0] TC;
wire[2:0] reffreq;
wire[1:0] refampl;
wire refIO;

reg rst=1;
reg[4:0] cnt=0;

always @ ( posedge CLK12 ) begin
  cnt<=cnt+1;
  if(&cnt) rst<=0;
end

UI UI_inst (
  CLK12,
  rst,

  // IO LCD
  LCD_RS,
  LCD_E,
  SF_D,
  // IO buttons
  ~Button,

  // Interface
  32'h000FF000,//X,
  ~cnt,//Y,
  cnt,//Rad,
  ~cnt,//Ang,

  gain,
  TC,
  reffreq,
  refampl,
  refIO

  );





endmodule
