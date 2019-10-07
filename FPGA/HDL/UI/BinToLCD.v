


module BinToLCD (
  input clk,

  input update,

  input [31:0] number1,
  input [31:0] number2,
  input ismagphase,

  output reg [7:0] dat=0,
	output wire [4:0] addr,
	output reg we=0


  );

  reg lastupdate=0,updating=0;

  reg[4:0] pos=0;

  reg[32:0] acc=0;
  reg[31:0] rest=0,lastacc=0,summand=0;
  reg[3:0] dec=0;


  wire[34:0] difference;

  assign difference=rest-acc;
  assign addr=pos-1;

  always @ (posedge clk ) begin
    lastupdate<=update;
    if(!lastupdate&&update) updating<=1;

    if(updating)begin

    acc<=acc+summand;
    lastacc<=acc;

      case (pos)

      5'h00: begin
        pos<=5'h01;
        we<=1;
        dat<=8'b01011000;     //X
        if(ismagphase) dat<=8'b01010010; //R
      end
      5'h01: begin
        pos<=5'h02;
        dat<=8'b00111010;   //:
        dec<=0;
      end
      5'h02: begin
        pos<=5'h03;
        dat<=8'b00100000;   // _
        summand<=1000000000;     // 4294967296
        acc<=1000000000;
        rest<=number1;
        dec<=0;
        lastacc<=0;
      end
      5'h03: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};     //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h04;
          rest=rest-lastacc;
          dec<=0;
          summand<=100000000;
          acc<=100000000;
          lastacc<=0;
        end
      end
      5'h04: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h05;
          rest=rest-lastacc;
          dec<=0;
          summand<=10000000;
          acc<=10000000;
          lastacc<=0;
        end
      end
      5'h05: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h06;
          rest=rest-lastacc;
          dec<=0;
          summand<=1000000;
          acc<=1000000;
          lastacc<=0;
        end
      end
      5'h06: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h07;
          rest=rest-lastacc;
          dec<=0;
          summand<=100000;
          acc<=100000;
          lastacc<=0;
        end
      end
      5'h07: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h08;
          rest=rest-lastacc;
          dec<=0;
          summand<=10000;
          acc<=10000;
          lastacc<=0;
        end
      end
      5'h08: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h09;
          rest=rest-lastacc;
          dec<=0;
          summand<=1000;
          acc<=1000;
          lastacc<=0;
        end
      end
      5'h09: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h0a;
          rest=rest-lastacc;
          dec<=0;
          summand<=100;
          acc<=100;
          lastacc<=0;
        end
      end
      5'h0a: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h0b;
          rest=rest-lastacc;
          dec<=0;
          summand<=10;
          acc<=10;
          lastacc<=0;
        end
      end
      5'h0b: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h0c;
          rest=rest-lastacc;
          dec<=0;
          summand<=1;
          acc<=1;
          lastacc<=0;
        end
      end
      5'h0c: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          dec<=0;
          pos<=5'h0d;

        end
      end
      5'h0d: begin
        pos<=5'h0e;
        we<=1;
        dat<=8'b00100000;    // _
      end
      5'h0e: begin
        pos<=5'h0f;
        we<=1;
        dat<=8'b00100000;    // _
      end
      5'h0f: begin
        pos<=5'h10;
        we<=1;
        dat<=8'b00100000;    // _
      end
      5'h10: begin
        pos<=5'h11;
        we<=1;
        dat<=8'b01011001;     //Y
        if(ismagphase) dat<=8'b11110010; //theta
      end
      5'h11: begin
        pos<=5'h12;
        dat<=8'b00111010;   //:
      end
      5'h12: begin
        pos<=5'h13;
        dat<=8'b00100000;   // _
        summand<=1000000000;     // 4294967296
        acc<=1000000000;
        rest<=number2;
        dec<=0;
        lastacc<=0;
      end
      5'h13: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};     //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h14;
          rest=rest-lastacc;
          dec<=0;
          summand<=100000000;
          acc<=100000000;
          lastacc<=0;
        end
      end
      5'h14: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h15;
          rest=rest-lastacc;
          dec<=0;
          summand<=10000000;
          acc<=10000000;
          lastacc<=0;
        end
      end
      5'h15: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h16;
          rest=rest-lastacc;
          dec<=0;
          summand<=1000000;
          acc<=1000000;
          lastacc<=0;
        end
      end
      5'h16: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h17;
          rest=rest-lastacc;
          dec<=0;
          summand<=100000;
          acc<=100000;
          lastacc<=0;
        end
      end
      5'h17: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h18;
          rest=rest-lastacc;
          dec<=0;
          summand<=10000;
          acc<=10000;
          lastacc<=0;
        end
      end
      5'h18: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h19;
          rest=rest-lastacc;
          dec<=0;
          summand<=1000;
          acc<=1000;
          lastacc<=0;
        end
      end
      5'h19: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h1a;
          rest=rest-lastacc;
          dec<=0;
          summand<=100;
          acc<=100;
          lastacc<=0;
        end
      end
      5'h1a: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h1b;
          rest=rest-lastacc;
          dec<=0;
          summand<=10;
          acc<=10;
          lastacc<=0;
        end
      end
      5'h1b: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          pos<=5'h1c;
          rest=rest-lastacc;
          dec<=0;
          summand<=1;
          acc<=1;
          lastacc<=0;
        end
      end
      5'h1c: begin
        we<=0;
        dec<=dec+1;
        if(difference[34]) begin
          dat<={4'b0011,(dec)};   //1-9
          //if(dec==0) dat<=8'b00100000;    // _
          we<=1;
          dec<=0;
          pos<=5'h1d;

        end
      end
      5'h1d: begin
        pos<=5'h1e;
        we<=1;
        dat<=8'b00100000;    // _
      end
      5'h1e: begin
        pos<=5'h1f;
        we<=1;
        dat<=8'b00100000;    // _
      end
      5'h1f: begin
        pos<=5'h00;
        we<=1;
        dat<=8'b00100000;    // _
        updating<=0;
      end


      default: begin
        we<=0;
        pos<=0;
        updating<=0;
      end


      endcase


    end // if updating


  end // posedge clk




endmodule
