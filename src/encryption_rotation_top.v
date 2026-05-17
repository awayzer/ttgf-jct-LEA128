`default_nettype none
module encryption_rotation_top(
input wire [31:0] sum_in,
input wire [1:0]  sel_in,
output wire [31:0] sum_rot_out
);

wire [31:0] ror3_in_0;
wire [31:0] ror5_in_1;
wire [31:0] rol9_in_2;


mux_3_1 u1(
	.sel(sel_in),
	.in0(ror3_in_0), 
	.in1(ror5_in_1), 
	.in2(rol9_in_2),
	.ot(sum_rot_out)
);

encryption_rotation u2(
	.data_in(sum_in),
	.ror3(ror3_in_0),
	.ror5(ror5_in_1),
	.rol9(rol9_in_2)
);
endmodule