
// 14 bit fibonacci m-seq gen for ditering


module fibonacci15 (
    input clk,
    output [14:0] fib=14'h0001
  );

  always @ ( posedge clk ) begin
    fib[14:1]<=fib[13:0];
    fib[0]<=fib[15] ^~ fib[14];
  end

endmodule // fibonacci
