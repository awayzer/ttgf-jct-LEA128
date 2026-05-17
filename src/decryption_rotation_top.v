`default_nettype none
module decryption_rotation_top(
input wire [31:0] sum_in,
input wire [1:0]  sel_in,
output wire [31:0] rot_out
);

wire [31:0] rol3_in_2;
wire [31:0] rol5_in_1;
wire [31:0] ror9_in_0;


mux_3_1 u1(
	.sel(sel_in),
	.in0(ror9_in_0), 
	.in1(rol5_in_1), 
	.in2(rol3_in_2),
	.ot(rot_out)
);

decryption_rotation u2(
	.data_in(sum_in),
	.rol3(rol3_in_2),
	.rol5(rol5_in_1),
	.ror9(ror9_in_0)
);
endmodule