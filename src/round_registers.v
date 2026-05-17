`default_nettype none
module round_registers(
input wire clk,
input wire reset,
input wire unit_enable,
input wire operational_mod,
input wire [31:0] x0_unit_in,
input wire [31:0] x3_decryption_in,
output wire [31:0] x3,
output wire [31:0] x2,
output wire [31:0] x1,
output wire [31:0] x0
);

reg [31:0] register0;
reg [31:0] register1;
reg [31:0] register2;
reg [31:0] register3;

always @(posedge clk) begin
	if (reset) begin
		register0 <= 32'b0;
		register1 <= 32'b0;
		register2 <= 32'b0;
		register3 <= 32'b0;
	end else begin
		if (unit_enable) begin
			if (operational_mod) begin
				register3 <= register2;
				register2 <= register1;
				register1 <= register0;
				register0 <= x0_unit_in;
			end else begin
				register3 <= x3_decryption_in;
				register2 <= register3;
				register1 <= register2;
				register0 <= x0_unit_in;
			end
		end
	end		
end	

assign x3 = register3;
assign x2 = register2;
assign x1 = register1;
assign x0 = register0;

endmodule