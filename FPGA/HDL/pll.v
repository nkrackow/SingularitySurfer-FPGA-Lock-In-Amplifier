
// SingularitySurfers PLL core

// fuck that took far too long...
//assign eP=$signed(phase[24:9])-$signed(16'h7fff);    // calculate difference to 2pi


module pll (
  input clk,
  input in,
  output[17:0] phase_out,
  output reg locked=0,
  output reg[15:0]debug
  );

//  parameter signed KD= 16'h0000;   // 0.0 Loopfilter Differential Gain in s7.8 format
  parameter signed KP= 16'b0001;   // 1.0 Loopfilter Proportional Gain in s7.8 format

reg [31:0] phase=0;     // 24 bit/ 0x00ffffff equals 2 pi. upper bits to sense higher freqs

//reg [16:0] incr=16'd556;     // phase increase word.
reg signed[16:0] incr=17'd600;     // phase increase word.

reg l_in=0,l2_in=0;   //last and second last input. NECCESARY TO DOUBLE REGISTER SYNC HERE!

assign phase_out=phase[23:6];


    wire signed [15:0] eP,eD;     //  Propotrional Error term
    reg signed [15:0] last_eP;
//    wire signed [31:0] fullout;   // full 32 bit output wit KP and KD added up

assign eP= (|phase[31:25]) ? 16'h7fff:    // check if overflow and assign maxvalue
            (phase[24:9]-16'h7fff); // or phase error
assign eD=eP-last_eP;

always @ ( posedge clk ) begin
  locked<=0;
  if((&~eP[15:12])||(&eP[15:12])) locked<=1;    // locked if small pos or neg value
  phase<=phase+incr;
  l_in<=in;
  l2_in<=l_in;
  //debug<=fullout[31:16];
  //debug<=phase[23:8];
  if(!l2_in&&l_in) begin    //the edgesense has to be double registered!!! otherwise gliches occure!
    last_eP<=eP;
    phase<=32'h00000000;    // reset phase
    incr<=incr-$signed(eP[15:9])+$signed(eD[15:11]); // proportional and derivative loop gain set by adding higher or lower bits to phase increment
    //debug<=eD;
  end

end




    // multiplier wiring




  //   SB_MAC16 KP_mult
  //    ( // port interfaces
  //    .A(KP),
  //    .B(eP),
  //    .C(0),
  //    .D(0),
  //    .O(fullout),
  //    .CLK(clk),
  //    .CE(1'b1),
  //    .IRSTTOP(0),
  //    .IRSTBOT(0),
  //    .ORSTTOP(0),
  //    .ORSTBOT(0),
  //    .AHOLD(0),
  //    .BHOLD(0),
  //    .CHOLD(0),
  //    .DHOLD(0),
  //    .OHOLDTOP(0),
  //    .OHOLDBOT(0),
  //    .OLOADTOP(0),
  //    .OLOADBOT(0),
  //    .ADDSUBTOP(0),
  //    .ADDSUBBOT(0),
  //    .CO(),
  //    .CI(),
  //    .ACCUMCI(),
  //    .ACCUMCO(),
  //    .SIGNEXTIN(),
  //    .SIGNEXTOUT()
  //   );
  //   defparam KP_mult.TOPOUTPUT_SELECT = 2'b11; //Mult16x16 data output
  //   defparam KP_mult.BOTOUTPUT_SELECT = 2'b11;
  // //  defparam KP_mult.PIPELINE_16x16_MULT_REG2 = 1'b0; //no Mult16x16 output registered
  //   defparam KP_mult.A_SIGNED = 1'b1; //Signed Inputs
  //   defparam KP_mult.B_SIGNED = 1'b1;

    //
    // SB_MAC16 KD_mult_and_acc
    //  ( // port interfaces
    //  .A(KD),
    //  .B(eD),
    //  .C(KPout[31:16]),    //upper 16 KPout bits
    //  .D(KPout[15:0]),     // lower 16
    //  .O(fullout),
    //  .CLK(clk),
    //  .CE(1'b1),
    //  .IRSTTOP(0),
    //  .IRSTBOT(0),
    //  .ORSTTOP(0),
    //  .ORSTBOT(0),
    //  .AHOLD(0),
    //  .BHOLD(0),
    //  .CHOLD(0),
    //  .DHOLD(0),
    //  .OHOLDTOP(0),
    //  .OHOLDBOT(0),
    //  .OLOADTOP(0),
    //  .OLOADBOT(0),
    //  .ADDSUBTOP(0),
    //  .ADDSUBBOT(0),
    //  .CO(),
    //  .CI(),
    //  .ACCUMCI(),
    //  .ACCUMCO(),
    //  .SIGNEXTIN(),
    //  .SIGNEXTOUT()
    // );
    // defparam KD_mult_and_acc.TOPOUTPUT_SELECT = 2'b00; // adder output
    // defparam KD_mult_and_acc.BOTOUTPUT_SELECT = 2'b00;  // adder output
    // defparam KD_mult_and_acc.TOPADDSUB_CARRYSELECT = 2'b10; // use carry bit from lower adder
    // defparam KD_mult_and_acc.TOPADDSUB_LOWERINPUT = 2'b10;  // use 16x16 as adder input
    // defparam KD_mult_and_acc.BOTADDSUB_LOWERINPUT = 2'b10;  // use 16x16 as adder input
    // defparam KD_mult_and_acc.BOTADDSUB_UPPERINPUT = 1'b1;   // use input D for lower adder
    // defparam KD_mult_and_acc.TOPADDSUB_UPPERINPUT = 1'b1;   // use input C for lower adder
    // defparam KD_mult_and_acc.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
    // defparam KD_mult_and_acc.A_SIGNED = 1'b1; //Signed Inputs
    // defparam KD_mult_and_acc.B_SIGNED = 1'b1;





endmodule
