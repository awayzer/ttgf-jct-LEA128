`default_nettype none
module constant_generator
(
input wire clk,
input wire reset,
input wire unit_en,
input wire res_const,
input wire operation_mod,
input wire [1:0] q,
output wire [31:0] rot0,
output wire [31:0] rot1,
output wire [31:0] rot2,
output wire [31:0] rot3

);

localparam [31:0] delta0 = 32'hC3EFE9DB;
localparam [31:0] delta1 = 32'h44626B02;
localparam [31:0] delta2 = 32'h79E27C8A;
localparam [31:0] delta3 = 32'h78DF30EC;


reg [31:0] reg0 ;
reg [31:0] reg1 ;
reg [31:0] reg2 ;
reg [31:0] reg3 ;

always @(posedge clk )begin
	if (reset == 1'b1 || res_const == 1'b1)begin
		reg0 <= delta0;
		reg1 <= delta1;
		reg2 <= delta2;
		reg3 <= delta3;
	end else if (unit_en)begin
		if(q == 2'b11)begin
			if(operation_mod)begin
				reg0 <= {reg1[30:0],reg1[31]};
				reg1 <= {reg2[30:0],reg2[31]};
				reg2 <= {reg3[30:0],reg3[31]};
				reg3 <= {reg0[30:0],reg0[31]};
			end else begin
				reg0 <= {reg3[0],reg3[31:1]};
				reg3 <= {reg2[0],reg2[31:1]};
				reg2 <= {reg1[0],reg1[31:1]};
				reg1 <= {reg0[0],reg0[31:1]};
			end
		end
	end	
end				
				
				
				
assign rot0 = reg0;				
assign rot1 = {reg0[30:0],reg0[31]};					
assign rot2 = {reg0[29:0],reg0[31:30]};					
assign rot3 = {reg0[28:0],reg0[31:29]};	

endmodule				
				
				