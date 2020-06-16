/* Machine-generated using Migen */
module RIIR(
	input signed [31:0] inp,
	output reg signed [31:0] outp,
	input [3:0] b,
	input tick,
	input sys_clk
);

reg signed [47:0] z = 48'sd0;
reg [3:0] preshift;
reg [3:0] postshift;
reg [4:0] b_reg = 5'd0;
reg p_step = 1'd0;
reg signed [47:0] p_reg = 48'sd0;
reg signed [47:0] z_shift_reg = 48'sd0;
reg signed [31:0] inp_shift_reg = 32'sd0;
reg tick_l = 1'd0;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on


// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	preshift <= 4'd0;
	postshift <= 4'd0;
	if ((b_reg >= 4'd15)) begin
		postshift <= 4'd15;
		preshift <= (b_reg - 4'd15);
	end else begin
		preshift <= 1'd0;
		postshift <= b_reg;
	end
end

always @(posedge sys_clk) begin
	b_reg <= (b + 4'd10);
	z_shift_reg <= (z >>> b_reg);
	inp_shift_reg <= (inp >>> preshift);
	if (((tick & (~tick_l)) & (~p_step))) begin
		p_step <= 1'd1;
		p_reg <= (z - z_shift_reg);
	end
	if (p_step) begin
		z <= (inp_shift_reg + p_reg);
		p_step <= 1'd0;
	end
	outp <= (z >>> postshift);

end

endmodule
