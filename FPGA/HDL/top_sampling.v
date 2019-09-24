



module top_sampling (
  input CLK12,

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
  output B
  );
  parameter issimulation=0;   // sets clock to input clk for sim.


  reg[31:0] count=0;
  reg rst=0,loadlookup=0,ramfull=0,holdoff=1,lastdone=0,fdatholdoff=1;

  wire wen,wen_w,busy,adcen,newdata;
	wire[15:0] addr, wdata, addr_w, addr_r, dout, adcdata;
  reg [15:0] addr_adc=16'hffff;

  // PLL vars
  wire lock,clk,internalpllclk,islocked;


  // Assignments

  assign clk= issimulation?  CLK12 : internalpllclk;    // if this gets synthed migh effect clk skew??

  assign {R,G,B}=~{done,SCLK,ramfull};






  //assign {wen,addr}= busy ? {wen_w,addr_w} : {1'b0,addr_r};
  assign {wen,addr}= (!ramfull&&done) ? {wen_w,addr_adc} : {1'b0,addr_r};


  always @ ( posedge clk) begin
    if(!loadlookup&&count[8]) loadlookup<=1;
    rst<=1;
    count<=count+1;



    if(done&&!ramfull) adcen<=1;

    if(newdata) fdatholdoff<=0;

    wen_w<=0;
    if(newdata&&!fdatholdoff) begin
      holdoff<=0;
      addr_adc<=addr_adc+1;
      wen_w<=1;
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



  adc_host adc_host_hi(
    clk,
    adcen,
    CONVST,
    SCLK,
    SDO,
    adcdata,
    newdata
  );



  serial_out SPI_not_really(
      clk,
      sSCLK,
      sMISO,
      addr_r,
      dout,
      done
    );


  sram16x16 SRAM(
    clk,
    wen,
    addr,
    adcdata,
    dout
  );


  // Flash_to_SRAM F2SRAM(
  //     CLK12,
  //     rst,
  //
  //     loadlookup,
  //     busy,
  //
  //   // spi interface
  //     mosi,
  //     miso,
  //     ss,
  //     sck,
  //
  //   // sram interface
  //     wen_w,
  //   	addr_w,
  //   	wdata
  //
  //   );


    SB_PLL40_CORE #(
  		.FEEDBACK_PATH("SIMPLE"),
  		.PLLOUT_SELECT("GENCLK"),
  		.DIVR(4'b0000),
  		.DIVF(7'b0101111),
  		.DIVQ(3'b100),
  		.FILTER_RANGE(3'b001)
  	) PLL (
  		.LOCK(lock),
  		.RESETB(1'b1),
  		.BYPASS(1'b0),
  		.REFERENCECLK(CLK12),
  		.PLLOUTCORE(internalpllclk)
  	);



endmodule
