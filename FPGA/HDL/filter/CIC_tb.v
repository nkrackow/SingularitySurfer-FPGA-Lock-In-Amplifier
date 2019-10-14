

`timescale 1 ns / 1 ps

module CIC_tb ();

  reg CLK=0;
  reg tick=0;
  reg[3:0] TC=5;
  reg [31:0] IN=10000;

  wire[31:0] OUT;


  CIC Filter(
    CLK,
    tick,

    TC,

    IN,
    OUT

  );

initial begin
  $dumpfile("out.vcd");
  $dumpvars(0, CIC_tb);
   #1000000
  $display("hallu world");
  $finish;
end

always begin
  #1
  CLK<=!CLK;
end

always begin
  #10
  tick<=!tick;
//  IN<=IN+1;
end

endmodule //top_tb
