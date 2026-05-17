`default_nettype none
module decryption_rotation(
input wire [31:0] data_in,
output wire [31:0] rol3,
output wire [31:0] rol5,
output wire [31:0] ror9
);
assign rol3 = {data_in[28:0],data_in[31:29]};
assign rol5 = {data_in[26:0],data_in[31:27]};
assign ror9 = {data_in[8:0],data_in[31:9]};
endmodule
