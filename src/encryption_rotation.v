`default_nettype none
module encryption_rotation(
input wire [31:0] data_in,
output wire [31:0] ror3,
output wire [31:0] ror5,
output wire [31:0] rol9
);
assign ror3 = {data_in[2:0],data_in[31:3]};
assign ror5 = {data_in[4:0],data_in[31:5]};
assign rol9 = {data_in[22:0],data_in[31:23]};
endmodule
