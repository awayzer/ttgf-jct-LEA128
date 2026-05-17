`default_nettype none
module logical_unit_top(
input wire clk,
input wire reset,
input wire pb_enc,
input wire pb_dec,
output wire operational_mod,
output wire enable_store,
output wire enable_round_reg,
output wire sel_key_mux,
output wire enable_const_reg,
output wire reset_const,
output wire enable_key_reg,
output wire [1:0] sel_data_mux,
output wire [1:0] q
);

wire en2;
wire en5;
wire tc2;
wire tc5;
wire tc_p;
wire rq_5;
wire [1:0] q2;

state_machine u0(
	.clk(clk),
	.reset(reset),
	.tc2(tc2),
	.tc5(tc5),
	.tc_p1(tc_p),
	.pb_enc(pb_enc),
	.pb_dec(pb_dec),
	.q2(q2),
	.rq5(rq_5),
	.en2(en2),
	.en5(en5),
	.enable_store(enable_store),
	.operational_mod(operational_mod),
	.enable_round_reg(enable_round_reg),
	.sel_key_mux(sel_key_mux),
	.enable_const_reg(enable_const_reg),
	.reset_const(reset_const),
	.enable_key_reg(enable_key_reg),
	.sel_data_mux(sel_data_mux)
);

two_bit_counter u1(
	.clk(clk),
	.reset(reset),
	.unit_enable(en2),
	.tc(tc2),
	.q(q2)
);

counter_5_bit u2(
	.clk(clk),
	.reset(reset),
	.enable_unit(en5),
	.tc2(tc2),
	.rq(rq_5),
	.tc(tc5),
	.tc_plus_1(tc_p)
);

assign q = q2;

endmodule















