`default_nettype none
module key_rotation_dec_top(
input wire [1:0] sel,
input wire [31:0] key_in, 
output wire [31:0] key_out 
);

wire [31:0] rotate1;
wire [31:0] rotate3;
wire [31:0] rotate6;
wire [31:0] rotate11;


key_rotation_dec u0(
	.key_in(key_in),
	.ror_1(rotate1),
	.ror_3(rotate3),
	.ror_6(rotate6),
	.ror_11(rotate11)
);

mux_4_1 u1(
	.sel(sel),
	.in0(rotate3),
	.in1(rotate1),
	.in2(rotate6),
	.in3(rotate11),
	.ot(key_out)
);

endmodule