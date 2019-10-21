

`default_nettype none

module top (
  input CLK12,

  output wire ss,
  input wire  miso,
  output wire mosi,
  output wire sck,

  output wire [15:0] HC,
  output wire [3:0] HB,
  input wire v,
  input wire [3:0] S,

  output R,
  output G,
  output B
  );
  parameter issimulation=0;   // sets clock to input clk for sim.


  reg[31:0] count=0;
  reg[17:0] sweep=0;
  reg rst=0,loadlookup=0;

  wire wen,wen_w,busy,pulse_out1,pulse_out2;
	wire[15:0] addr, wdata, addr_w, addr_r, dout,
  sin, cos,debug;
  wire [31:0] product;
  wire [17:0] pllphase;

  // PLL vars
  wire lock,clk,internalpllclk,islocked;



  // Assignments

  assign clk= issimulation?  CLK12 : internalpllclk;    // if this gets synthed migh effect clk skew??

  assign {R,G,B}=~{islocked,v};

  assign HC={~cos[15],cos[14:0]};

  assign {HB[3],HB[0]}={pulse_out1,pulse_out2};

  //assign HB[2]= S[1]? !pulse_out:0;



  assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};
  //assign addr_r={sweep};

  always @ (posedge clk) begin
    if(!loadlookup&&count[8]) loadlookup<=1;
    rst<=1;
    count<=count+1;
    sweep<=sweep+count[26:20];
  end



  sram16x16 SRAM(
    clk,
    wen,
    addr,
    wdata,
    dout
  );


  Flash_to_SRAM F2SRAM(
      CLK12,
      rst,

      loadlookup,
      busy,

    // spi interface
      mosi,
      miso,
      ss,
      sck,

    // sram interface
      wen_w,
    	addr_w,
    	wdata

    );



dds dds_core(
    clk,
    count[2],
    //sweep,
    //{pllphase},
    //{count[11:0],6'b0},
    count[17:0],
    sin,
    cos,

// sram
    addr_r,
    dout
  );


sigma_delta DAC1(
    clk,
    {~cos[15],cos[14:1]},
    pulse_out1
  );

sigma_delta DAC2(
    clk,
    {~sin[15],sin[14:1]},
    pulse_out2
  );



  SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.PLLOUT_SELECT("GENCLK"),
    .DIVR(4'b0000),
    .DIVF(7'b1001111),
    .DIVQ(3'b101),
    .FILTER_RANGE(3'b001)
	) PLL (
		.LOCK(lock),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(CLK12),
		.PLLOUTCORE(internalpllclk)
	);


  // mult16x16 mult(
  //   clk,
  //   cos,
  //   cos,
  //   product
  //   );

  pll pll1(
    clk,
    v,
    pllphase,
    islocked
    );



//       parameter signed KD= 16'hffff;   // Loopfilter Differential Gain in s7.8 format
//       parameter signed KP= 16'hffff;   // Loopfilter Proportional Gain in s7.8 format
//
//
//     wire signed [15:0] eD,eP;     // Differential and Propotrional Error terms
//     wire [31:0] KPout;           // Output of Proportional Gain mult
//     wire [31:0] fullout;   // full 32 bit output wit KP and KD added up
//
//
// assign {eD,eP}={0};
//
//
//
//         SB_MAC16 KP_mult
//          ( // port interfaces
//          .A(KP),
//          .B(eP),
//          .C(0),
//          .D(0),
//          .O(KPout),
//          .CLK(clk),
//          .CE(1'b1),
//          .IRSTTOP(0),
//          .IRSTBOT(0),
//          .ORSTTOP(0),
//          .ORSTBOT(0),
//          .AHOLD(0),
//          .BHOLD(0),
//          .CHOLD(0),
//          .DHOLD(0),
//          .OHOLDTOP(0),
//          .OHOLDBOT(0),
//          .OLOADTOP(0),
//          .OLOADBOT(0),
//          .ADDSUBTOP(0),
//          .ADDSUBBOT(0),
//          .CO(),
//          .CI(),
//          .ACCUMCI(),
//          .ACCUMCO(),
//          .SIGNEXTIN(),
//          .SIGNEXTOUT()
//         );
//         defparam KP_mult.TOPOUTPUT_SELECT = 2'b11; //Mult16x16 data output
//         defparam KP_mult.BOTOUTPUT_SELECT = 2'b11;
//         defparam KP_mult.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
//         defparam KP_mult.A_SIGNED = 1'b1; //Signed Inputs
//         defparam KP_mult.B_SIGNED = 1'b1;
//
//
//         SB_MAC16 KD_mult_and_acc
//          ( // port interfaces
//          .A(KD),
//          .B(eD),
//          .C(KPout[31:16]),    //upper 16 KPout bits
//          .D(KPout[15:0]),     // lower 16
//          .O(fullout),
//          .CLK(clk),
//          .CE(1'b1),
//          .IRSTTOP(0),
//          .IRSTBOT(0),
//          .ORSTTOP(0),
//          .ORSTBOT(0),
//          .AHOLD(0),
//          .BHOLD(0),
//          .CHOLD(0),
//          .DHOLD(0),
//          .OHOLDTOP(0),
//          .OHOLDBOT(0),
//          .OLOADTOP(0),
//          .OLOADBOT(0),
//          .ADDSUBTOP(0),
//          .ADDSUBBOT(0),
//          .CO(),
//          .CI(),
//          .ACCUMCI(),
//          .ACCUMCO(),
//          .SIGNEXTIN(),
//          .SIGNEXTOUT()
//         );
//         defparam KD_mult_and_acc.TOPOUTPUT_SELECT = 2'b00; // adder output
//         defparam KD_mult_and_acc.BOTOUTPUT_SELECT = 2'b00;  // adder output
//         defparam KD_mult_and_acc.TOPADDSUB_CARRYSELECT = 2'b10; // use carry bit from lower adder
//         defparam KD_mult_and_acc.TOPADDSUB_LOWERINPUT = 2'b10;  // use 16x16 as adder input
//         defparam KD_mult_and_acc.BOTADDSUB_LOWERINPUT = 2'b10;  // use 16x16 as adder input
//         defparam KD_mult_and_acc.BOTADDSUB_UPPERINPUT = 1'b1;   // use input D for lower adder
//         defparam KD_mult_and_acc.TOPADDSUB_UPPERINPUT = 1'b1;   // use input C for lower adder
//         defparam KD_mult_and_acc.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
//         defparam KD_mult_and_acc.A_SIGNED = 1'b1; //Signed Inputs
//         defparam KD_mult_and_acc.B_SIGNED = 1'b1;
//













endmodule //top
