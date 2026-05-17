`default_nettype none
module mux_4_1
(
  input  wire [1:0]  sel,
  input  wire [31:0] in0, in1, in2, in3,
  output reg  [31:0] ot
);

  always @(*)
    case (sel)
	  2'b00   : ot = in0;
	  2'b01   : ot = in1;
	  2'b10   : ot = in2;
	  2'b11   : ot = in3;
	  default : ot = 32'b0;
	endcase
endmodule
