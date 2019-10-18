

`default_nettype none

module boardtest (
  input CLK36,
  output reg L0=1'b1,
  output reg L1=0,
  output reg L2=0,
  output reg L3=0,
  input wire MENU,
  input wire SET,
  input wire PLUS,
  input wire MINUS,
  output reg X_R=0,
  output reg Y_T=0,
  output reg REFOUT=0,
  output reg SDI=1,
  output reg SCLK=0,
  output reg SDO=0,
  output reg CONVST=0,
  input wire REFIN

  );





reg [22:0] cnt=0;
reg lastin=0,lastlastin=0;



always @ ( posedge CLK36 ) begin
  lastin<=REFIN;
  lastlastin<=lastin;
  if(!lastlastin&&lastin)  REFOUT<=!REFOUT;
  cnt<=cnt+1;
  if(&cnt) begin
    {L1,L2,L3,L0}<={L0,L1,L2,L3};
    //SCK<=!SCK;
  end
  //{L0,L1,L2,L3}<={MENU,SET,PLUS,MINUS};
  SCLK<=!SCLK;
  //SDI<=!SDI;
  if(!MENU) X_R<=!X_R;
  if(!SET) Y_T<=!Y_T;
end



endmodule // boardtest
