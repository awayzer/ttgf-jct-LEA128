`default_nettype none
module key_rotation_enc(
input wire [31:0] key_in,
output wire [31:0] rol_1,
output wire [31:0] rol_3,
output wire [31:0] rol_6,
output wire [31:0] rol_11
);

assign rol_1 = {key_in[30:0], key_in[31]};
assign rol_3 = {key_in[28:0], key_in[31:29]};
assign rol_6 = {key_in[25:0], key_in[31:26]};
assign rol_11 = {key_in[20:0], key_in[31:21]};

endmodule