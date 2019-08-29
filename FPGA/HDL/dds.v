
// SingularitySurfers DDS core

// Uses all of the onboard sram as a quater sin lookup
// to implement a 16 bit sin/cos - 18 bit phase resolution DDS core

module dds (
  input clk,
  input go,
  input[17:0] phase,
  output reg [15:0] sin,
  output reg [15:0] cos,

  //sram interface
  output reg [15:0] addr,
  input[15:0] data
  );

  reg iscos=0, lastgo=0,islast=0;

  always @ (posedge clk ) begin
    lastgo<=go;
    if(!lastgo&&go)begin
      iscos<=1;
      case (phase[16])                // sin: second and fourth quater need to be flipped
        1'b0:   addr<=phase[15:0];
        1'b1:   addr<=~phase[15:0];
        default: addr<=phase[15:0] ;
      endcase
    end
    if(iscos)begin
      islast<=1;
      iscos<=0;
      case (phase[16])                // cos: first and third quater are flipped
        1'b0:   addr<=~phase[15:0];
        1'b1:   addr<=phase[15:0];
        default: addr<=phase[15:0] ;
      endcase
      case (phase[17])               // sin: last two qaters are neg
        1'b0:   sin<=data[15:0];
        1'b1:   sin<=~data[15:0];
        default: sin<=data[15:0] ;
      endcase
    end
    if(islast)begin
      islast<=0;
      //addr<=16'h0000;
      case (phase[17:16])
        2'b00:   cos<=data[15:0];   //first quater is pos
        2'b01:   cos<=~data[15:0];   // second and third are neg
        2'b10:   cos<=~data[15:0];
        2'b11:   cos<=data[15:0];   //fourth quater is pos
        default: cos<=data[15:0] ;
      endcase
    end
  end


endmodule // dds
