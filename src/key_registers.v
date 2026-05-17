`default_nettype none
module key_registers(
input wire clk,
input wire reset,
input wire unit_en,
input wire operation_mod,
input wire [31:0] data_in_enc,
input wire [31:0] data_in_dec,
output wire [31:0] t0,
output wire [31:0] t1,
output wire [31:0] t2,
output wire [31:0] t3
);


reg [31:0] register0;
reg [31:0] register1;
reg [31:0] register2;
reg [31:0] register3;

always @ (posedge clk) begin
	if (reset) begin
		register0 <= 32'b0;
		register1 <= 32'b0;
		register2 <= 32'b0;
		register3 <= 32'b0;
	end else begin 
		if (unit_en) begin
			if (operation_mod) begin
				register1 <= register3;
				register3 <= register2;
				register2 <= register0;
				register0 <= data_in_enc;
			end else begin
				register1 <= register0;
				register0 <= register2;
				register2 <= register3;
				register3 <= data_in_dec;
			end	
		end	
	end	
end	



assign t0 = register0;
assign t1 = register1;
assign t2 = register2;
assign t3 = register3;

endmodule