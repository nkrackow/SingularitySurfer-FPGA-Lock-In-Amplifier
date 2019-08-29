
module mult16x16 (
  input clk,
  input wire [15:0] in1,
  input wire [15:0] in2,
  output wire [31:0] out
  );






SB_MAC16 i_sbmac16
 ( // port interfaces
 .A(in1),
 .B(in2),
 .C(0),
 .D(0),
 .O(out),
 .CLK(clk),
 .CE(1'b1),
 .IRSTTOP(0),
 .IRSTBOT(0),
 .ORSTTOP(0),
 .ORSTBOT(0),
 .AHOLD(0),
 .BHOLD(0),
 .CHOLD(0),
 .DHOLD(0),
 .OHOLDTOP(0),
 .OHOLDBOT(0),
 .OLOADTOP(0),
 .OLOADBOT(0),
 .ADDSUBTOP(0),
 .ADDSUBBOT(0),
 .CO(),
 .CI(),
 .ACCUMCI(),
 .ACCUMCO(),
 .SIGNEXTIN(),
 .SIGNEXTOUT()
);
defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b11; //Mult16x16 data output
defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b11;
defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
defparam i_sbmac16.A_SIGNED = 1'b1; //Signed Inputs
defparam i_sbmac16.B_SIGNED = 1'b1;

endmodule // mult16x16
