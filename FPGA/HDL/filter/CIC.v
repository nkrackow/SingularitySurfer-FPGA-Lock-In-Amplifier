

// Integrator Comb Filter with different Timeconstants


module CIC (
  input clk,
  input tick,

  input[3:0] TC,

  input signed [31:0] IN,
  output reg signed [31:0] OUT

  );

parameter rate=1024;//2048;
parameter log2rate=10;

reg lasttick=0;
reg[10:0] tickcount=0;

reg signed [48:0] I0=0, OUTpipe=0; //Integrator Reg

reg[7:0] inaddr=0;
reg we=0;
reg[7:0] outaddr;
wire[48:0] outdat;

//assign outaddr=inaddr-(8'b00000001<<(TC));


always @ ( posedge clk ) begin

  we<=0;
  lasttick<=tick;
  outaddr<=inaddr-(8'b00000001<<(TC));
  OUTpipe<=I0-outdat;
  if(!lasttick&&tick)begin

    tickcount<=tickcount+1;
    if(tickcount>=rate-1)begin
      tickcount<=0;
      inaddr<=inaddr+1;
      we<=1;
    end
    if(!(|tickcount)) OUT<=OUTpipe>>(TC+log2rate);
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
