


// ALL TIMING FOR 50MHz CLK

module adc_host (
  input clk,
  input enable,
  output reg CONVST=0,
  output wire SCLK,
  input wire SDO,
  output reg [15:0] data=0,
  output reg newdata=0
  );

reg acq=0;
reg [7:0] count=0;
reg [15:0] shiftdata=0;

assign SCLK= (acq&&enable)? clk : 0;



always @ ( posedge clk ) begin
  newdata<=0;
  if(enable) count<=count+1;
  if(count==10) CONVST<=0;    // when at 200ns
  if(count==23) acq<=1;       // when at 720ns
  if(count==39) begin         // after 17 more clockcycles
    acq<=0;
    CONVST<=1;
    data<=shiftdata;//+16'h7fff;
    count<=0;
    newdata<=1;
  end
  if(!enable) CONVST<=0;
end


always @ ( negedge SCLK ) begin
  shiftdata<={shiftdata[14:0],SDO};
end


endmodule
