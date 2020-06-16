



module serial_out (
  input clk,
  input sclk,
  output reg miso=0,
  output reg [15:0] addr=0,
  input [15:0] data,
  output reg done=0
  );


  reg last_sclk=0,last_last_sclk=0;
  reg [3:0] dcount=15;

  always @ (posedge clk ) begin
    done<=0;
    if(!(|(addr))) done<=1;
    last_sclk<=sclk;
    last_last_sclk<=last_sclk;
    if(!last_last_sclk&&last_sclk)begin
      miso<=data[dcount];
      dcount<=dcount-1;   //underflows
      if(dcount==0) addr<=addr+1;      //overflows at 65536 (2^16)
    end


  end

endmodule // sigma_delta
