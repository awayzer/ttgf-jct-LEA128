`default_nettype none
module two_bit_counter(
input wire clk,
input wire reset,
input wire unit_enable,
output wire tc,
output reg [1:0] q
);

always @ (posedge clk) begin
	if (reset)
		q <= 2'b0;
	else if (unit_enable)
		q <= q + 1;
end

assign tc = (q == 2'b11)? 1'b1 : 1'b0;

endmodule