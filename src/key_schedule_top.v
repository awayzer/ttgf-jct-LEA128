`default_nettype none
module key_schedule_top(
input wire clk,
input wire reset,
input wire operational_mod,
input wire [1:0] mux_sel,
input wire enable_const_unit,
input wire reset_const,
input wire enabel_key_reg_unit,
input wire [31:0] master_key,
input wire key_in_sel,
output wire [31:0] r1_enc,
output wire [31:0] r1_dec,
output wire [31:0] r_else_enc,
output wire [31:0] r_else_dec
);

wire [31:0] out_dec_in_sub_arg2;
wire [31:0] out_enc_in_add_arg2;
wire [31:0] t1_to_add_dec_rotation;
wire [31:0] rot_to_din_enc;
wire [31:0] rslt_sub_to_din_dec;
wire [31:0] rslt_add_to_rot;
wire [31:0] dec_rot_sub_arg1;
wire [31:0] o_mux_in1;



constant_generator_top u0(
	.clk(clk),
	.reset(reset),
	.unit_en(enable_const_unit),
	.operation_mod(operational_mod),
	.res_const(reset_const),
	.mux_sel(mux_sel),
	.ot_const_dec(out_dec_in_sub_arg2),
	.ot_const_enc(out_enc_in_add_arg2)
);

key_register_top u1(
	.clk(clk),
	.reset(reset),
	.unit_en(enabel_key_reg_unit),
	.operation_mod(operational_mod),
	.mux_sel(mux_sel),
	.data_in_enc(o_mux_in1),
	.data_in_dec(rslt_sub_to_din_dec),
	.t1_out(t1_to_add_dec_rotation),
	.ot_mux_enc(r1_enc),
	.ot_mux_dec(r1_dec)
);


modular_addition u2(
	.arg1(t1_to_add_dec_rotation),
	.arg2(out_enc_in_add_arg2),
	.rslt(rslt_add_to_rot)
);


modular_subtruction u3(
	.arg1(dec_rot_sub_arg1),
	.arg2(out_dec_in_sub_arg2),
	.rslt(rslt_sub_to_din_dec)
);

key_rotation_enc_top u4(
	.sel(mux_sel),
	.key_in(rslt_add_to_rot), 
	.key_out(rot_to_din_enc) 
);

key_rotation_dec_top u5(
	.sel(mux_sel),
	.key_in(t1_to_add_dec_rotation), 
	.key_out(dec_rot_sub_arg1) 
);

mux_2_1 u6(
	.sel(key_in_sel),
	.in0(master_key), 
	.in1(rot_to_din_enc), 
	.ot(o_mux_in1)
);

assign r_else_enc = rot_to_din_enc;
assign r_else_dec = rslt_sub_to_din_dec;

endmodule





