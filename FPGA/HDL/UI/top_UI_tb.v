

`timescale 1 ns / 1 ps

module top_UI_tb ();

  reg CLK=0;
  reg [3:0] Button=4'hf;
  wire R,G,B;

  wire LCD_RS;
  wire LCD_RW;
  wire LCD_E;
  wire [3:0] SF_D;

  wire [15:0] HC;


top_UI topUIinst(
    CLK,

    LCD_RS,
    LCD_RW,
    LCD_E,
    SF_D,
    Button,

    HC,

    R,
    G,
    B
    );

initial begin
  $dumpfile("out.vcd");
  $dumpvars(0, top_UI_tb);
  #10
//  Button[1]<=0;
  #10
//  Button[1]<=1;
  #3000
//  Button[1]<=0;
  #10000
  $display("hallu world");
  $finish;
end

always begin
  #1
  CLK<=!CLK;
end

endmodule //top_tb
