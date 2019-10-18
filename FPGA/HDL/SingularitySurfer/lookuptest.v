

`default_nettype none

module lookuptest (
  input CLK36,

  output wire ss,
  input wire  miso,
  output wire mosi,
  output wire sck,

  output wire sMISO,
  input wire sSCLK,
  input wire [1:0] S,

  output reg SDI=1,
  output wire SCLK,
  output wire CONVST,
  input wire SDO,
  output reg GAIN_A0=0,
  output reg GAIN_A1=0,


  output R,
  output G,
  output B,
  output L3
  );
  parameter issimulation=0;   // sets clock to input clk for sim.


  reg[31:0] count=0;
  reg rst=0,wen_adc=0,loadlookup=0,ramfull=0,holdoff=1,lastdone=0,fdatholdoff=1;

  wire wen,wen_w,busy,adcen,newdata,done;
	wire[15:0] addr, wdata, addr_w, addr_r, dout, adcdata;
  reg [15:0] addr_adc=16'hffff;
  reg misoreg=0;
  // PLL vars
  wire lock,clk,internalpllclk,islocked,isdata;




  // Assignments

  assign isdata=|(~wdata);

  assign clk= CLK36;    // if this gets synthed migh effect clk skew??

  assign {G,R,B}={done,busy,isdata};

  assign L3=count[21];


  assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};


  always @ ( posedge clk) begin
    if(!loadlookup&&count[8]) loadlookup<=1;
    rst<=1;
    count<=count+1;


    if(done&&!ramfull) adcen<=1;

    if(newdata) fdatholdoff<=0;

    wen_adc<=0;
    if(newdata&&!fdatholdoff) begin
      holdoff<=0;
      addr_adc<=addr_adc+1;
      wen_adc<=1;
    end
    if(addr_adc==16'hffff&&(!holdoff))begin
      holdoff<=1;
      ramfull<=1;
      adcen<=0;
    end


    lastdone<=done;
    if(!lastdone&&done) begin
      ramfull<=0;
      fdatholdoff<=1;
    end


  end


  serial_out SPI_not_really(
      clk,
      sSCLK,
      sMISO,
      addr_r,
      dout,
      done
    );




  Flash_to_SRAM F2SRAM(
      clk,
      rst,

      loadlookup,
      busy,

    // spi interface
      mosi,
      miso,
      ss,
      sck,

    // sram interface
      wen_w,
    	addr_w,
    	wdata

    );

    sram16x16 SRAM(
      clk,
      wen,
      addr,
      wdata,
      dout
    );



endmodule
