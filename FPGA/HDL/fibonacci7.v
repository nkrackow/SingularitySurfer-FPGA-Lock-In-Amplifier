
// 14 bit fibonacci m-seq gen for ditering


module fibonacci7 (
    input clk,
    output [6:0] fib=7'h0001
  );

  always @ ( posedge clk ) begin
    fib[6:1]<=fib[5:0];
    fib[0]<=fib[7] ^~ fib[6];
  end

endmodule // fibonacci
