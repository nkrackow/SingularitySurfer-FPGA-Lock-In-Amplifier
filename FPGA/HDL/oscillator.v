

// Numerical oscillator. gives out phase only.

// uses pseudorandom fib seq for dithering


`default_nettype none



module oscillator (
  input clk,            // f_clk=36 MHz
  input [2:0] freq,    // freq in 10Hz steps
  output [17:0] phase
  );


  parameter word1 = 18'b111010010000010001;
  parameter word2 = 22'b1001000110100010101100;
  parameter word3 = 24'b101101100000101101100000;


  wire [14:0]fib;
  reg [31:0] phasereg;
  reg [31:0] PHASENAKKUMULATOOOOOR=0;   // full phase in fixed point 18.14 bit format
  reg [24:0] phaseword=0;

  assign phase=phasereg[31:14];




  always @ ( posedge clk ) begin
    PHASENAKKUMULATOOOOOR<=PHASENAKKUMULATOOOOOR+phaseword;
    phasereg<=PHASENAKKUMULATOOOOOR+fib;

    case(freq)
      0:  phaseword<=word1>>2;    //500Hz
      1:  phaseword<=word1>>1;    //1000Hz
      2:  phaseword<=word1;       //2000Hz
      3:  phaseword<=word2>>2;    //5000Hz
      4:  phaseword<=word2>>1;    //10000Hz
      5:  phaseword<=word2;       //20000Hz
      6:  phaseword<=word3>>1;    //50000Hz
      7:  phaseword<=word3;       //100000Hz
      default phaseword<=word1>>1;    //1000Hz
    endcase
  end


  fibonacci15 randgen(clk,fib);


endmodule //
