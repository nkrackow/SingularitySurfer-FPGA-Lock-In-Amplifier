


`default_nettype none

module fullcordic(
  input clk,
  input rst,
  input [16:0] X,
  input [16:0] Y,
  output [16:0] Mag,
  output [16:0] Ang
  );

  parameter iterations=9;

  integer i;

  reg [1:0] quadmem [iterations-1:0];

  wire [16:0] x_i,y_i,Ang_o;



// rotate the circle until it fits in a square, works, try it :P


  assign x_i= (!X[16]&&!Y[16]) ? X  :
              (X[16]&&!Y[16])  ? Y  :
              (X[16]&&Y[16])   ? ~X :
                                 ~Y;


  assign y_i= (!X[16]&&!Y[16]) ? Y  :
              (X[16]&&!Y[16])  ? ~X :
              (X[16]&&Y[16])   ? ~Y :
                                 X;


  assign Ang =  (quadmem[iterations-1]==2'b00) ? Ang_o :
                (quadmem[iterations-1]==2'b01) ? Ang_o+17'h05A00 : // +90 deg
                (quadmem[iterations-1]==2'b10) ? Ang_o+17'h0B400 : // +180 deg
                                                 Ang_o+17'h10E00;   // +270 deg

  always @ (posedge clk) begin
    quadmem[0]<=2'b00;              // x and y pos Q1
    if(X[16]&&!Y[16]) quadmem[0]<=2'b01;    // x neg, y pos   Q2
    if(X[16]&&Y[16]) quadmem[0]<=2'b10;     // x neg, y neg   Q3
    if(!X[16]&&Y[16]) quadmem[0]<=2'b11;    // x pos, y neg   Q4
    for(i=0;i<iterations-1;i=i+1)begin
      quadmem[i+1]<=quadmem[i];
    end
  end




  cordic cordicCORE (
    .clk(clk),
    .rst(rst),
    //.init(cinit),
    .x_i(x_i),
    .y_i(y_i),
    .theta_i(0),
    .x_o(Mag),
    .y_o(),
    .theta_o(Ang_o)
    );


endmodule
