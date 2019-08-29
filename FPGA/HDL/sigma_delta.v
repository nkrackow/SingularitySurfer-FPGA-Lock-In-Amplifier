

// SingularitySurfers delta-sigma accomulator modulator modul :)

module sigma_delta (
  input clk,
  input[precision-1:0] dac_val,
  output pulse_out
  );

  parameter precision = 16;

  reg[precision:0] acc=0;

  assign pulse_out=acc[precision];

  always @ ( posedge clk ) begin
    acc<=acc[precision-1:0]+dac_val;
  end

endmodule // sigma_delta
