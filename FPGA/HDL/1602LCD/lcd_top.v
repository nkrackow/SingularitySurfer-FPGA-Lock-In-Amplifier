


module lcd_top (
  input CLK12,

  output wire LCD_RS,
  output wire LCD_RW,
  output wire LCD_E,
  output wire [3:0] SF_D,

  output wire [15:0] HC,

  output R,
  output G,
  output B
  );

assign LCD_RW=0;


wire repaint,we=1,busy,dummy;
reg [31:0] count=0;
reg [6:0] addr=0;
reg [7:0] dat=0,pos=0;
reg reset=1;


assign repaint=&count[20:0];
assign B=repaint;
assign G=reset;
assign R=busy;


always@(posedge CLK12)begin

  count<=count+1;

  if(count>=100) reset<=0;
  if(&count[20:0]) pos<=pos+1;
  if(pos==15) pos<=60;
  if(pos==80) pos<=0;

  addr<=addr+1;
  dat<=0;
  if(addr==pos) dat<=8'b01001000;
  if(addr==pos+1) dat<=8'b01001001;


end



lcd LCD(
  CLK12,
	reset,

	dat,
	addr,
	we,

	repaint,
  busy,
	SF_D,
	LCD_E,
	LCD_RS,
	dummy
  );




endmodule
