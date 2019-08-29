
// moves 65536 16 bit words from SPI flash to SRAM


module Flash_to_SRAM (
  input clk,
  input rst,

  input start,
  output reg busy=0,

// spi interface
  output mosi,
  input miso,
  output ss,
  output sck,

// sram interface
  output reg  wen=0,
	output reg [15:0] addr=0,
	output reg [15:0] wdata=0,

// debug
  output wire d

);

  parameter base_addr = 24'h100000;


// core vars
  reg[15:0] poscount=0;
  reg laststart=0, second=0;
  reg[7:0] f_byte;

// SPI vars
  reg[23:0] spi_addr=0;
  reg[16:0] spi_len=17'h1ffff;
  reg spi_go=0;
  wire spi_rdy;
  wire[7:0] spi_data;
  wire spi_valid;

  assign d=spi_valid;

  always @ (posedge clk) begin
    // resets are for loosers :p

    laststart<=start;
    spi_go<=0;
    wen<=0;

    if(start&&!laststart&&!busy)begin
      busy<=1;
      poscount<=0;
      spi_addr<=base_addr;
      spi_go<=1;
      addr<=16'hffff;   // set to -1 so it goes to 0 at first +1
    end


    if(busy)begin
      if(&poscount) busy<=0;// done
      if(spi_valid)begin    // if new data
        f_byte<=spi_data;   // if in first byte save byte
        second<=1;
        if(second)begin     //if in second byte send it to sram
          wen<=1;
          wdata<={spi_data,f_byte};
          //wdata<={poscount};
          addr<=addr+1;
          second<=0;
          poscount<=poscount+1;
        end
      end
    end

  end


  spi_flash_reader SPI_READER (
 // SPI interface
 .spi_mosi(mosi),
 .spi_miso(miso),
 .spi_cs_n(ss),
 .spi_clk(sck),

 // Command interface
 .addr(spi_addr),
 .len(spi_len),
 .go(spi_go),
 .rdy(spi_rdy),

 // Data interface
 .data(spi_data),
 .valid(spi_valid),

 // Clock / Reset
 .clk(clk),
 .rst(rst)
);


endmodule //Flash_to_SRAM
