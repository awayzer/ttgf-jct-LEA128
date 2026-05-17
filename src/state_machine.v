`default_nettype none
module state_machine(
input wire clk,
input wire reset,
input wire tc2,
input wire tc5,
input wire tc_p1,
input wire pb_enc,
input wire pb_dec,
input wire [1:0] q2,
output reg rq5,
output reg en2,
output reg en5,
output reg enable_store,
output reg operational_mod,
output reg enable_round_reg,
output reg sel_key_mux,
output reg enable_const_reg,
output reg reset_const,
output reg enable_key_reg,
output reg [1:0] sel_data_mux
);

localparam
	WIDTH = 3,
    IDLE = 3'b000,
    DATA_KEY_IN = 3'b001,
    ENC_RUN = 3'b010,
    DEC_KEY_PREP = 3'b011,
    COLLAB = 3'b100,
    DEC_RUN = 3'b101,
    DONE = 3'b110;
reg [WIDTH-1 : 0] current_state, next_state;

localparam 
    MOD_ENC = 1'b0,
	MOD_DEC = 1'b1;
reg mod;


always @ (posedge clk) begin
	if (reset) begin
		current_state <= IDLE;
		mod <= MOD_ENC;
	end else begin
		current_state <= next_state;
		if (current_state == IDLE) begin
			if (pb_enc)
				mod <= MOD_ENC;
			else if (pb_dec)
				mod <= MOD_DEC;
		end
	end
end

always @ (*) begin
	en2 = 1'b0;
	en5 = 1'b0;
	rq5 = 1'b0;
	operational_mod = 1'b0;
	enable_round_reg = 1'b0;
	sel_key_mux = 1'b0;
	enable_const_reg = 1'b0;
	reset_const = 1'b0;
	enable_key_reg = 1'b0;
	enable_store = 1'b0;
	sel_data_mux = 2'b00;
	next_state = current_state;
	
	case(current_state)
		IDLE: begin
			if ((pb_enc == 1'b1) || (pb_dec == 1'b1))
				next_state = DATA_KEY_IN;
		end

		DATA_KEY_IN: begin
			en2 = 1'b1;
			operational_mod = 1'b1;
			enable_round_reg = 1'b1;
			enable_key_reg = 1'b1;
			sel_data_mux = 2'b11;
			if (tc2) begin
				if(mod == MOD_ENC)
					next_state = ENC_RUN;
				else
					next_state = DEC_KEY_PREP;
			end
		end

		ENC_RUN: begin
			if (!tc_p1) begin
				en2 = 1'b1;
			end	
			en5 = 1'b1;
			operational_mod = 1'b1;
			sel_key_mux = 1'b1;
			enable_const_reg = 1'b1;
			enable_key_reg = 1'b1;
			sel_data_mux = 2'b10;
			
			if (q2 != 2'b00) begin
				enable_round_reg = 1'b1;
			end
			
			if (((tc5 == 1'b1) && (q2 != 2'b0)) || (tc_p1)) begin
				enable_store = 1'b1;
			end
			
			if (tc_p1) begin
				next_state = DONE;
			end
		end

		DEC_KEY_PREP: begin
			en2 = 1'b1;
			en5 = 1'b1;
			operational_mod = 1'b1;
			sel_key_mux = 1'b1;
			enable_key_reg = 1'b1;
			
			if (!tc_p1) begin
				enable_const_reg = 1'b1;
			end
			
			if (tc_p1 == 1'b1 && q2 == 2'b11) begin
				next_state = COLLAB;
			end
		end
		
		COLLAB: begin
	 	   rq5 = 1'b1;
		   next_state = DEC_RUN;
		end
		
		DEC_RUN: begin
		
		  if (!tc_p1) begin
			  en2 = 1'b1;
		  end
		
		  en5 = 1'b1;
		  sel_key_mux = 1'b1;
		  enable_const_reg = 1'b1;
		  enable_key_reg = 1'b1;
		  sel_data_mux = 2'b01;
		  
		  if (q2 != 2'b00) begin
			enable_round_reg = 1'b1;
		  end
		
		  if (((tc5 == 1'b1) && (q2 != 2'b0)) || (tc_p1)) begin
				 enable_store = 1'b1;
		  end
			
		  if (tc_p1) begin
			  next_state = DONE;
		  end
	  end
	
	  DONE: begin
		  rq5 = 1'b1;
		  reset_const = 1'b1;
	 	  next_state = IDLE;	
	  end  	
	 	default: next_state = IDLE;
  endcase
end
endmodule