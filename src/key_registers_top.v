`default_nettype none
module key_register_top(
input wire clk,
input wire reset,
input wire unit_en,
input wire operation_mod,
input wire [1:0] mux_sel ,
input wire [31:0] data_in_enc,
input wire [31:0] data_in_dec,
output wire [31:0] t1_out,
output wire [31:0] ot_mux_enc,
output wire [31:0] ot_mux_dec
);

wire [31:0] t0;
wire [31:0] t2;
wire [31:0] t3;

key_registers u0(
	.clk(clk),
	.reset(reset),
	.unit_en(unit_en),
	.operation_mod(operation_mod),
	.data_in_enc(data_in_enc),
	.data_in_dec(data_in_dec),
	.t0(t0),
	.t1(t1_out),
	.t2(t2),
	.t3(t3)
);

mux_3_1 u1(
	.sel(mux_sel),
	.ot(ot_mux_enc),
	.in0(t0),
	.in1(t2),
	.in2(t3)
);

mux_3_1 u2(
	.sel(mux_sel),
	.ot(ot_mux_dec),
	.in0(t3),
	.in1(t2),
	.in2(t0)
);


endmodule