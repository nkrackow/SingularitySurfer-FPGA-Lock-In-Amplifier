

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
  output reg REFOUT=0

  );





reg [22:0] cnt=0;



always @ ( posedge CLK36 ) begin
  cnt<=cnt+1;
  //if(&cnt) {L1,L2,L3,L0}<={L0,L1,L2,L3};
  {L0,L1,L2,L3}<={MENU,SET,PLUS,MINUS};
  if(!MENU) X_R<=!X_R;
  if(!SET) Y_T<=!Y_T;
  if(!PLUS) REFOUT<=!REFOUT;
end



endmodule // boardtest
