`default_nettype none
module constant_generator_top
(
input wire clk,
input wire reset,
input wire unit_en,
input wire operation_mod,
input wire res_const,
input wire [1:0] mux_sel,
output wire [31:0] ot_const_dec,
output wire [31:0] ot_const_enc
);

wire [31:0] rotate0;
wire [31:0] rotate1;
wire [31:0] rotate2;
wire [31:0] rotate3;

constant_generator u1(
    .clk(clk),
	.q(mux_sel),
    .reset(reset),
    .unit_en(unit_en),
	.res_const(res_const),
	.operation_mod(operation_mod),
	.rot0(rotate0),
	.rot1(rotate1),
	.rot2(rotate2),
	.rot3(rotate3)
);


mux_4_1 u2(
	.sel(mux_sel),
	.ot(ot_const_enc),
	.in0(rotate1),
	.in1(rotate3),
	.in2(rotate2),
	.in3(rotate0)
);


mux_4_1 u3(
	.sel(mux_sel),
	.ot(ot_const_dec),
	.in0(rotate1),
	.in1(rotate0),
	.in2(rotate2),
	.in3(rotate3)
);

endmodule

