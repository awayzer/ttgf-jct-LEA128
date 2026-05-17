`default_nettype none
module mux_2_1
(
  input  wire  sel,
  input  wire [31:0] in0, in1,
  output reg  [31:0] ot
);

  always @(*)
    case (sel)
	  1'b0   : ot = in0;
	  1'b1   : ot = in1;
	  default : ot = 32'b0;
	endcase
endmodule
