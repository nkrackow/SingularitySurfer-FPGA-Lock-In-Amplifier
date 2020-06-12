
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
//reg [15:0] outstuff=0;


 //basics
wire clipping;
reg rst=1;
reg[24:0] cnt=0;
wire tick;


// settings
wire[1:0] gain;
wire[3:0] TC;
wire[2:0] reffreqset;
wire[1:0] refamplset;
wire refIO;
wire ismagphase;
wire[3:0] debug;


// DSP Signals
wire [17:0] oscphase,phase,pllphase;
wire signed [31:0] X,Y;
wire[16:0] Mag,Ang;    //17 bits beacuse of sign bit (cordic core)
wire signed [15:0] sin,cos;    // sin and cos from DDS core
wire signed [15:0] adcdata;    // raw adc samples
wire signed [31:0] sinmod,cosmod;   // sin and cos modulated signals

// CORES aux Signals
reg loadlookup=0;
wire wen,wen_w,busy,newdata,islocked;
wire[15:0] addr,wdata,dout,addr_r,addr_w;


// Basic assigns
assign SDI=1'b1;    // SUPER IMPORTANT, ADC IS DISABLED IF NOT HIGH
assign LCD_RW=0;    // LCD in write only mode

//assign Y=cnt;

assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};


assign phase= refIO ? pllphase : oscphase ;

// assert clipping if adcdata mag very big
assign clipping=(!adcdata[15]&&(&adcdata[14:11]))||(adcdata[15]&&(&~adcdata[14:11]));


// LED assigns
assign {A1,A0}=gain;
assign L2=|adcdata;
assign L1=islocked;
assign L0=clipping;
assign L3=cnt[22];



assign tick=&cnt[10:0];

always @ ( posedge CLK36 ) begin
  cnt<=cnt+1;
  if(&cnt[5:0]) rst<=0;
  if(!loadlookup&&cnt[9]) loadlookup<=1;
//  outstuff<=X[31:16];
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

  X,
  Y,
  Mag,
  Ang,

  gain,
  TC,
  reffreqset,
  refamplset,
  refIO,
  ismagphase

  );


oscillator OSC(
  CLK36,
  reffreqset,
  oscphase
  );



pll PLL(
  CLK36,
  REFIN,
  pllphase,
  islocked
  );


dds DDS(
  CLK36,
  cnt[2],
  //sweep,
  //{pllphase},
  phase,
  //cnt[17:0],
  sin,
  cos,

// sram
  addr_r,
  dout
  );

sigma_delta DAC1(
  CLK36,
  ismagphase ? Mag : {~X[31],X[30:16]},
  X_R
  );

sigma_delta DAC2(
  CLK36,
  ismagphase ? Ang : {~Y[31],Y[30:16]},
  Y_T
  );

sigma_delta DAC3(
  CLK36,
  ({!sin[15],sin[14:0]}>>refamplset),
  REFOUT
  );


adc_host ADC(
  CLK36,
  1'b1,
  CONVST,
  SCLK,
  SDO,
  adcdata,
  newdata
  );

mult16x16 Mult1(
  CLK36,
  sin,
  adcdata,
  sinmod
  );

mult16x16 Mult2(
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
defparam Filter1.rate=1024;
defparam Filter1.log2rate=10;


CIC Filter2(
  CLK36,
  newdata,
  TC,
  cosmod,
  Y
);
defparam Filter2.rate=1024;
defparam Filter2.log2rate=10;


fullcordic CORDIC(
  CLK36,
  rst,
  X[31:15],
  Y[31:15],
  Mag,
  Ang
  );


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
