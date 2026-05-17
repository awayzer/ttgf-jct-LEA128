`default_nettype none
module lea_128_core_top(
input wire clk,
input wire reset,
input wire [1:0] sel_2_bit,
input wire operation_mod,
input wire [31:0] data_in,
input wire [1:0] sel_mux_data_in,
input wire enable_round_rgisters,
input wire [31:0] master_key,
input wire sel_mux_key,
input wire enable_const_registers,
input wire reset_const,
input wire enable_key_registers,
output wire [31:0] data_out
);

wire [31:0] r1_enc;
wire [31:0] r1_dec;
wire [31:0] r_else_enc;
wire [31:0] r_else_dec;

key_schedule_top u0(
	.clk(clk),
	.reset(reset),
	.operational_mod(operation_mod),
	.mux_sel(sel_2_bit),
	.enable_const_unit(enable_const_registers),
	.reset_const(reset_const),
	.enabel_key_reg_unit(enable_key_registers),
	.master_key(master_key),
	.key_in_sel(sel_mux_key),
	.r1_enc(r1_enc),
	.r1_dec(r1_dec),
	.r_else_enc(r_else_enc),
	.r_else_dec(r_else_dec)
);

round_function_top u1(
	.clk(clk),
	.reset(reset),
	.en_unit(enable_round_rgisters),
	.operational_mod(operation_mod),
	.select_2_bits(sel_2_bit),
	.select_data_in_mux(sel_mux_data_in),
	.rk1_enc(r1_enc),
	.rk_else_enc(r_else_enc),
	.rk1_dec(r1_dec),
	.rk_else_dec(r_else_dec),
	.data_in(data_in),
	.data_out(data_out)
);
endmodule