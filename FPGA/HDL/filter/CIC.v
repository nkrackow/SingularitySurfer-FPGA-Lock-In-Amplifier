

// Integrator Comb Filter with different Timeconstants


module CIC (
  input clk,
  input tick,

  input[3:0] TC,

  input signed [31:0] IN,
  output reg signed [31:0] OUT

  );

parameter rate=4;//2048;
parameter log2rate=2;

reg lasttick=0;
reg[10:0] tickcount=0;

reg signed [63:0] I0=0; //Integrator Reg

reg[7:0] inaddr=0;
reg we=0;
wire[7:0] outaddr;
wire[63:0] outdat;

assign outaddr=inaddr-(8'b00000001<<(TC));


always @ ( posedge clk ) begin

  we<=0;
  lasttick<=tick;
  if(!lasttick&&tick)begin

    tickcount<=tickcount+1;
    if(tickcount>=rate-1)begin
      tickcount<=0;
      inaddr<=inaddr+1;
      we<=1;
    end
    if(!(|tickcount)) OUT<=(I0-outdat)>>(TC+log2rate);
    I0<=I0+IN;




  end

end



dpram_64x8 combram(
  clk,

  I0,
  inaddr,
  we,

  outdat,
  outaddr
  );



endmodule // CIC
