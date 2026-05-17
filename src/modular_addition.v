`default_nettype none
module modular_addition(
input wire [31:0] arg1,
input wire [31:0] arg2,
output wire [31:0] rslt
);

assign rslt = arg1 + arg2;
endmodule