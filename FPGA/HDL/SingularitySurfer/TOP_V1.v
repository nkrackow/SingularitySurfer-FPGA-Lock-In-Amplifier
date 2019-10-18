
// This is the overall top module for the final rev 1 board


`default_nettype none


module top (
// OSC input
  input CLK36,

// LED outputs
  output L0,
  output L1,
  output L2,
  output L3,

// Buttons
  input MENU,
  input SET,
  input PLUS,
  input MINUS,

// "Analog" outputs
  output X_R,
  output Y_T,
  output REFOUT,

// Reference input
  input REFIN,

// ADC interface
  output SDI,
  output SCLK,
  input SDO,
  output CONVST,

// PGA interface
  output A0,
  output A1,

// LCD interface
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output LCD_D4,
  output LCD_D5,
  output LCD_D6,
  output LCD_D7,

// IO Header
  output [8:0] IO,

// SPI Flash interface
  output SS,
  output SCK,
  output SO,
  input SI

  );


// temporary stuff, you've never seen this.
reg [15:0] outstuff=0;


 //basics
assign LCD_RW=0;
reg rst=1;
reg[31:0] cnt=0;
wire tick;


// settings
wire[1:0] gain;
wire[3:0] TC;
wire[2:0] reffreq;
wire[1:0] refampl;
wire refIO;
wire[3:0] debug;


// DSP Signals
wire signed [31:0] X,Y;
wire[16:0] Mag,Ang;    //17 bits beacuse of sign bit (cordic core)
wire signed [15:0] sin,cos;    // sin and cos from DDS core
wire signed [15:0] adcdata;    // raw adc samples
wire signed [31:0] sinmod,cosmod;   // sin and cos modulated signals

// CORES aux Signals
reg loadlookup=0,cinit=0;
wire wen,wen_w,busy,newdata;
wire[15:0] addr,wdata,dout,addr_r,addr_w;


// Basic assigns
assign SDI=1'b1;    // SUPER IMPORTANT, ADC IS DISABLED IF NOT HIGH

//assign Y=cnt;

assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};


assign L2=|adcdata;
assign L1=newdata;
assign L0=busy;
assign L3=cnt[22];



assign tick=&cnt[10:0];

always @ ( posedge CLK36 ) begin
  cnt<=cnt+1;
  if(&cnt[5:0]) rst<=0;
  if(!loadlookup&&cnt[9]) loadlookup<=1;
  outstuff<=X[31:16];
  cinit<=&cnt[9:0];
end


UI UI_inst (
  CLK36,
  rst,

  // IO LCD
  LCD_RS,
  LCD_E,
  {LCD_D7,LCD_D6,LCD_D5,LCD_D4},
  // IO buttons
  {MINUS,PLUS,SET,MENU},

  // Interface
  // {X[25:10],10'h000},//X,
  // {Y[25:10],10'h000},//Y,
  // X[16:0],//MAG,
  // Y[16:0],//Ang,

  X,//X,
  Y,//Y,
  Mag,
  Ang,

  gain,
  TC,
  reffreq,
  refampl,
  refIO

  );


cordic cordicCORE (
  .clk(CLK36),
  .rst(rst),
  .init(cinit),
  .x_i(X[31:15]),
  .y_i(0),
  .theta_i(0),
  .x_o(Mag),
  .y_o(),
  .theta_o(Ang)
  );



dds dds_core(
  CLK36,
  cnt[2],
  //sweep,
  //{pllphase},
  {cnt[11:0],6'b0},
  //cnt[17:0],
  sin,
  cos,

// sram
  addr_r,
  dout
  );

sigma_delta DAC1(
  CLK36,
  {~adcdata[15],adcdata[14:0]},
  X_R
  );

sigma_delta DAC2(
  CLK36,
  {~outstuff[15],outstuff[14:0]},
  Y_T
  );

// sigma_delta DAC3(
//     CLK36,
//     {~sin[15],sin[14:1]},
//     REFOUT
//   );


adc_host adc_host_hi(
  CLK36,
  1'b1,
  CONVST,
  SCLK,
  SDO,
  adcdata,
  newdata
  );

mult16x16 mult1(
  CLK36,
  sin,
  adcdata,
  sinmod
  );

mult16x16 mult2(
  CLK36,
  cos,
  adcdata,
  cosmod
  );

CIC Filter1(
  CLK36,
  newdata,
  TC,
  sinmod,
  X
);
defparam Filter1.rate=16;
defparam Filter1.log2rate=4;

// CIC Filter2(
//   CLK36,
//   newdata,
//   TC,
//   cosmod,
//   Y
// );

Flash_to_SRAM F2SRAM(
  CLK36,
  !rst,

  loadlookup,
  busy,

// spi interface
  SO,
  SI,
  SS,
  SCK,

// sram interface
  wen_w,
  addr_w,
  wdata

  );


sram16x16 SRAM(
  CLK36,
  wen,
  addr,
  wdata,
  dout
);



endmodule
