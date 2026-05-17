`default_nettype none
module counter_5_bit(
input wire clk,
input wire reset,
input wire enable_unit,
input wire tc2,
input wire rq,
output wire tc,
output wire tc_plus_1
);

reg [4:0] q;
reg tp_in;

always @ (posedge clk) begin
	if ((reset == 1'b1) || (rq == 1'b1)) begin
		q <= 5'b0;
		tp_in <= 1'b0;
	end else begin
		if ((enable_unit == 1'b1) && (tc2 == 1'b1)) begin
			if (q < 5'b10111) begin
				q <= q + 1;
				tp_in <= 1'b0;
			end else begin
				q <= 5'b0;
				tp_in <= 1'b1;
			end
		end
	end
end

assign tc = (q == 5'b10111)	? 1'b1 : 1'b0;
assign tc_plus_1 = (tp_in)? 1'b1 : 1'b0;

endmodule