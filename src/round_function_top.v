`default_nettype none
module round_function_top(
input wire clk,
input wire reset,
input wire en_unit,
input wire operational_mod,
input wire [1:0] select_2_bits,
input wire [1:0] select_data_in_mux,
input wire [31:0] rk1_enc,
input wire [31:0] rk_else_enc,
input wire [31:0] rk1_dec,
input wire [31:0] rk_else_dec,
input wire [31:0] data_in,
output wire [31:0] data_out
);



wire [31:0] round_rotation_data_in_mux;
wire [31:0] data_in_mux_in_unit;
wire [31:0] xor_rk1_mod_add;
wire [31:0] xor_r_else_mod_add;
wire [31:0] mod_add_round_rotation;
wire [31:0] rot_out_mod_sub;
wire [31:0] xor_to_mod_sub;
wire [31:0] mod_sub_to_xor;
wire [31:0] xor_to_x3;
wire [31:0] reg_x0;
wire [31:0] reg_x1;
wire [31:0] reg_x2;
wire [31:0] reg_x3;

mux_3_1 u0(
	.sel(select_data_in_mux),
	.in0(reg_x1), 
	.in1(round_rotation_data_in_mux),
	.in2(data_in),
	.ot(data_in_mux_in_unit)
);

mux_2_1 u1(
	.sel(operational_mod),
	.in0(reg_x3), 
	.in1(reg_x0),
	.ot(data_out)
);

round_registers u2(
	.clk(clk),
	.reset(reset),
	.unit_enable(en_unit),
	.operational_mod(operational_mod),
	.x0_unit_in(data_in_mux_in_unit),
	.x3_decryption_in(xor_to_x3),
	.x3(reg_x3),
	.x2(reg_x2),
	.x1(reg_x1),
	.x0(reg_x0)
);

xor_op u3(
	.arg1(reg_x3),
	.arg2(rk1_enc),
	.rslt(xor_rk1_mod_add)
);

xor_op u4(
	.arg1(reg_x2),
	.arg2(rk_else_enc),
	.rslt(xor_r_else_mod_add)
);

modular_addition u5(
	.arg1(xor_rk1_mod_add),
	.arg2(xor_r_else_mod_add),
	.rslt(mod_add_round_rotation)
);

encryption_rotation_top u6(
	.sum_in(mod_add_round_rotation),
	.sel_in(select_2_bits),
	.sum_rot_out(round_rotation_data_in_mux)
);

decryption_rotation_top u7(
	.sum_in(reg_x0),
	.sel_in(select_2_bits),
	.rot_out(rot_out_mod_sub)
);

xor_op u8(
	.arg1(reg_x3),
	.arg2(rk_else_dec),
	.rslt(xor_to_mod_sub)
);

modular_subtruction u9(
	.arg1(rot_out_mod_sub),
	.arg2(xor_to_mod_sub),
	.rslt(mod_sub_to_xor)
);

xor_op u10(
	.arg1(mod_sub_to_xor),
	.arg2(rk1_dec),
	.rslt(xor_to_x3)
);

endmodule