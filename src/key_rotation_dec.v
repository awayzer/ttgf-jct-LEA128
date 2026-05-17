`default_nettype none
module key_rotation_dec(
input wire [31:0] key_in,
output wire [31:0] ror_1,
output wire [31:0] ror_3,
output wire [31:0] ror_6,
output wire [31:0] ror_11
);

assign ror_1 = {key_in[0], key_in[31:1]};
assign ror_3 = {key_in[2:0], key_in[31:3]};
assign ror_6 = {key_in[5:0], key_in[31:6]};
assign ror_11 = {key_in[10:0], key_in[31:11]};

endmodule