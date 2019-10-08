


module UI (
  input clk,

  // IO LCD
  output wire LCD_RS,
  output wire LCD_E,
  output wire [3:0] SF_D,
  // IO buttons
  input [3:0] Button,

  // Interface
  input [31:0] X,
  input [31:0] Y,
  input [31:0] Rad,
  input [31:0] Ang,

  output reg [1:0] gain=0,
  output reg [3:0] TC=0,
  output reg [2:0] reffreq=0,
  output reg [1:0] refampl=0,
  output reg refIO=0,

  output wire [3:0] debug

  );


  // wireing
  wire[7:0] dat;
  wire[4:0] addr;
  wire we,repaint;
  wire[7:0] datBTL;
  wire[4:0] addrBTL;
  wire weBTL;

  // basics
  reg [31:0] count=0,number1=32'hfffffff0;
  wire update, busy;
  reg reset=1;

  assign update=&count[21:0];

  assign debug=state;

  // debouncing vars
  reg[3:0] BP=0;
  reg[21:0] cnt0=0,cnt1=0,cnt2=0,cnt3=0;
  reg btnt0=0,btnt1=0,btnt2=0,btnt3=0;

  // statemachine
  reg[3:0] state=0;

  parameter disp = 4'h0;
  parameter setTC = 4'h1;
  parameter setgain = 4'h2;
  parameter setrefIO = 4'h3;
  parameter setreffreq = 4'h4;
  parameter setrefampl = 4'h5;


  //substate logic
  reg ismagphase=0;
  reg[7:0] datS=0;
  reg weS=0, repaintS=0;
  reg [4:0] disppos=0;
  reg dispdone=0;
  wire [4:0] addrS;





  always @ ( posedge clk ) begin
    BP[0]<=0;
    BP[1]<=0;
    BP[2]<=0;
    BP[3]<=0;
    if(btnt0) begin
      cnt0<=cnt0+1;
      if(&cnt0) btnt0<=0;
    end
    if(Button[0]&&!btnt0)begin
      BP[0]<=1;
      btnt0<=1;
      cnt0<=0;
    end

    if(btnt1) begin
      cnt1<=cnt1+1;
      if(&cnt1) btnt1<=0;
    end
    if(Button[1]&&!btnt1)begin
      BP[1]<=1;
      btnt1<=1;
      cnt1<=0;
    end

    if(btnt2) begin
      cnt2<=cnt2+1;
      if(&cnt2) btnt2<=0;
    end
    if(Button[2]&&!btnt2)begin
      BP[2]<=1;
      btnt2<=1;
      cnt2<=0;
    end

    if(btnt3) begin
      cnt3<=cnt3+1;
      if(&cnt3) btnt3<=0;
    end
    if(Button[3]&&!btnt3)begin
      BP[3]<=1;
      btnt3<=1;
      cnt3<=0;
    end
  end


  assign addrS=disppos-1;
  assign {dat,addr,we,repaint}= (state==disp)? {datBTL,addrBTL,weBTL,update} :
                                      {datS,addrS,weS,repaintS};



  always @ ( posedge clk ) begin
    count<=count+1;
    if(&count[4:0]) reset<=0;
    if(&count[21:0]) number1<=number1+1;



    repaintS<=0;
    weS<=0;

    if(&disppos) dispdone<=1;
    if(state!=disp&&!dispdone)begin
      disppos<=disppos+1;
      weS<=1;
    end


    state<=state;

    case (state)
      disp: begin
        case (BP)
          4'b0001: begin
            state<=setTC;
            repaintS<=1;
            dispdone<=0;
          end
          4'b0010: ismagphase<=!ismagphase;
        endcase
      end


      setTC:begin
        case (disppos)
          5'h00: datS<=8'b00100000;//_
          5'h01: datS<=8'b01010100;//T
          5'h02: datS<=8'b01101001;//i
          5'h03: datS<=8'b01101101;//m
          5'h04: datS<=8'b01100101;//e
          5'h05: datS<=8'b00100000;//_
          5'h06: datS<=8'b01000011;//C
          5'h07: datS<=8'b01101111;//o
          5'h08: datS<=8'b01101110;//n
          5'h09: datS<=8'b01110011;//s
          5'h0a: datS<=8'b01110100;//t
          5'h0b: datS<=8'b01100001;//a
          5'h0c: datS<=8'b01101110;//n
          5'h0d: datS<=8'b01110100;//t
          5'h0e: datS<=8'b00111010;//:
          5'h0f: datS<=8'b00100000;//_

          5'h10: datS<=8'b00100000;//_
          5'h11:begin
            datS<=8'b00100000;//_
            if(TC==4'hf) datS<=8'b00110001;//1
          end
          5'h12:begin
            datS<=8'b00100000;//_
            if(TC>4'he) datS<=8'b00110000;//0
            if(TC==4'he) datS<=8'b00110001;//1
          end
          5'h13:begin
            datS<=8'b00100000;//_
            if(TC>4'hd) datS<=8'b00110000;//0
            if(TC==4'hd) datS<=8'b00110001;//1
          end
          5'h1d: datS<=8'b01101101;//m
          5'h1e: datS<=8'b01110011;//s

          default: datS<=8'b00100000;//_
        endcase

        case (BP)
          4'b0001: state<=setgain;
          4'b0010: state<=disp;
          4'b0100: TC<=TC+1;
          4'b1000: TC<=TC-1;
        endcase

        if(|BP)begin
          disppos<=0;
          repaintS<=1;
          dispdone<=0;
        end

      end


      setgain:begin
        case (disppos)
          5'h00: datS<=8'b00100000;//_
          5'h01: datS<=8'b01000111;//G
          5'h02: datS<=8'b01100001;//a
          5'h03: datS<=8'b01101001;//i
          5'h04: datS<=8'b01101110;//n
          5'h05: datS<=8'b00111010;//:

          5'h10: datS<=8'b00100000;//_
          5'h11:begin
            datS<=8'b00100000;//_
            if(gain==3) datS<=8'b00110110;//6
            if(gain==2) datS<=8'b00110100;//4
            if(gain==1) datS<=8'b00110010;//2
            if(gain==0) datS<=8'b00100000;//_
          end
          5'h12: datS<=8'b00110000;//0
          5'h13: datS<=8'b01100100;//d
          5'h14: datS<=8'b01000010;//B

          default: datS<=8'b00100000;//_
        endcase

        case (BP)
          4'b0001: state<=setrefIO;
          4'b0010: state<=disp;
          4'b0100: gain<=gain+1;
          4'b1000: gain<=gain-1;
        endcase
        if(|BP)begin
          disppos<=0;
          repaintS<=1;
          dispdone<=0;
        end
      end


      setrefIO:begin
        case (disppos)
          5'h00: datS<=8'b00100000;//_
          5'h01: datS<=8'b01010010;//R
          5'h02: datS<=8'b01100101;//e
          5'h03: datS<=8'b01100110;//f
          5'h04: datS<=8'b01100101;//e
          5'h05: datS<=8'b01110010;//r
          5'h06: datS<=8'b01100101;//e
          5'h07: datS<=8'b01101110;//n
          5'h08: datS<=8'b01100011;//c
          5'h09: datS<=8'b01100101;//e
          5'h0a: datS<=8'b00111010;//:

          5'h10: datS<=8'b00100000;//_
          5'h11: begin
            datS<=8'b01101001;//i
            if(refIO) datS<=8'b01100101;//e
          end
          5'h12: begin
            datS<=8'b01101110;//n
            if(refIO) datS<=8'b01111000;//x
          end
          5'h13: datS<=8'b01110100;//t
          5'h14: datS<=8'b01100101;//e
          5'h15: datS<=8'b01110010;//r
          5'h16: datS<=8'b01101110;//n
          5'h17: datS<=8'b01100001;//a
          5'h18: datS<=8'b01101100;//l

          default: datS<=8'b00100000;//_
        endcase
        case (BP)
          4'b0001: state<=setreffreq;
          4'b0010: state<=disp;
          4'b0100: refIO<=!refIO;
          4'b1000: refIO<=!refIO;
        endcase
        if(|BP)begin
          disppos<=0;
          repaintS<=1;
          dispdone<=0;
        end
      end


      setreffreq:begin
      case (disppos)
        5'h00: datS<=8'b00100000;//_
        5'h01: datS<=8'b01101001;//i
        5'h02: datS<=8'b01101110;//n
        5'h03: datS<=8'b01110100;//t
        5'h04: datS<=8'b00101110;//.
        5'h05: datS<=8'b00100000;//_
        5'h06: datS<=8'b01010010;//R
        5'h07: datS<=8'b01100101;//e
        5'h08: datS<=8'b01100110;//f
        5'h09: datS<=8'b00101110;//.
        5'h0a: datS<=8'b00100000;//_
        5'h0b: datS<=8'b01000110;//F
        5'h0c: datS<=8'b01110010;//r
        5'h0d: datS<=8'b01100101;//e
        5'h0e: datS<=8'b01110001;//q
        5'h0f: datS<=8'b00111010;//:



        default: datS<=8'b00100000;//_
      endcase
        case (BP)
          4'b0001: state<=setrefampl;
          4'b0010: state<=disp;
          4'b0100: reffreq<=reffreq+1;
          4'b1000: reffreq<=reffreq-1;
        endcase
        if(|BP)begin
          disppos<=0;
          repaintS<=1;
          dispdone<=0;
        end
      end


      setrefampl:begin
      case (disppos)
        5'h00: datS<=8'b00100000;//_
        5'h01: datS<=8'b01101001;//i
        5'h02: datS<=8'b01101110;//n
        5'h03: datS<=8'b01110100;//t
        5'h04: datS<=8'b00101110;//.
        5'h05: datS<=8'b00100000;//_
        5'h06: datS<=8'b01010010;//R
        5'h07: datS<=8'b01100101;//e
        5'h08: datS<=8'b01100110;//f
        5'h09: datS<=8'b00101110;//.
        5'h0a: datS<=8'b00100000;//_
        5'h0b: datS<=8'b01000001;//A
        5'h0c: datS<=8'b01101101;//m
        5'h0d: datS<=8'b01110000;//p
        5'h0e: datS<=8'b01101100;//l
        5'h0f: datS<=8'b00111010;//:



        default: datS<=8'b00100000;//_
      endcase
        case (BP)
          4'b0001: state<=setTC;
          4'b0010: state<=disp;
          4'b0100: refampl<=refampl+1;
          4'b1000: refampl<=refampl-1;
        endcase
        if(|BP)begin
          disppos<=0;
          repaintS<=1;
          dispdone<=0;
        end
      end


    endcase

  end


  BinToLCD diplay_number(
    clk,

    update,

    number1,
    ~number1,
    ismagphase,

    datBTL,
  	addrBTL,
  	weBTL
    );


  lcd LCD(
    clk,
  	reset,

  	dat,
  	addr,
  	we,

  	repaint,
    busy,
  	SF_D,
  	LCD_E,
  	LCD_RS
    );




endmodule
