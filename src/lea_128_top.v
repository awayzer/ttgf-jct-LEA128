`default_nettype none
module lea_128_top(
    input  wire clk,
    input  wire reset,
    input  wire pb_enc,
    input  wire pb_dec,

    input  wire [31:0] key_in0,
    input  wire [31:0] key_in1,
    input  wire [31:0] key_in2,
    input  wire [31:0] key_in3,

    input  wire [31:0] data_in0,
    input  wire [31:0] data_in1,
    input  wire [31:0] data_in2,
    input  wire [31:0] data_in3,

    output wire [7:0] data0,
    output wire [7:0] data1,
    output wire [7:0] data2,
    output wire [7:0] data3,
    output wire [7:0] data4,
    output wire [7:0] data5,
    output wire [7:0] data6,
    output wire [7:0] data7,
    output wire [7:0] data8,
    output wire [7:0] data9,
    output wire [7:0] data10,
    output wire [7:0] data11,
    output wire [7:0] data12,
    output wire [7:0] data13,
    output wire [7:0] data14,
    output wire [7:0] data15
);

wire [1:0] q;
wire operational_mod;
wire sel_key_mux;
wire en_round;
wire en_const;
wire reset_const;
wire en_key_reg;
wire en_store;
wire [1:0] sel_data_mux;
wire [31:0] data_out_comb_in_store;
wire [31:0] key_in_out_mux;
wire [31:0] data_in_out_mux;

lea_128_core_top u0(
	.clk(clk),
	.reset(reset),
	.sel_2_bit(q),
	.operation_mod(operational_mod),
	.data_in(data_in_out_mux),
	.sel_mux_data_in(sel_data_mux),
	.enable_round_rgisters(en_round),
	.master_key(key_in_out_mux),
	.sel_mux_key(sel_key_mux),
	.enable_const_registers(en_const),
	.reset_const(reset_const),
	.enable_key_registers(en_key_reg),
	.data_out(data_out_comb_in_store)
);

logical_unit_top u1(
	.clk(clk),
	.reset(reset),
	.pb_enc(pb_enc),
	.pb_dec(pb_dec),
	.operational_mod(operational_mod),
	.enable_store(en_store),
	.enable_round_reg(en_round),
	.sel_key_mux(sel_key_mux),
	.enable_const_reg(en_const),
	.reset_const(reset_const),
	.enable_key_reg(en_key_reg),
	.sel_data_mux(sel_data_mux),
	.q(q)
);

processed_data_storage u2(
	.clk(clk),
	.reset(reset),
	.q(q),
	.enable_unit(en_store),
	.data_in(data_out_comb_in_store),
	.operational_mod(operational_mod),
	.data0(data0),
	.data1(data1),
	.data2(data2),
	.data3(data3),
	.data4(data4),
	.data5(data5),
	.data6(data6),
	.data7(data7),
	.data8(data8),
	.data9(data9),
	.data10(data10),
	.data11(data11),
	.data12(data12),
	.data13(data13),
	.data14(data14),
	.data15(data15)
);


mux_4_1 u3(
	.sel(q),
	.in0(key_in0),
	.in1(key_in1),
	.in2(key_in2),
	.in3(key_in3),
	.ot(key_in_out_mux)
);

mux_4_1 u4(
	.sel(q),
	.in0(data_in0),
	.in1(data_in1),
	.in2(data_in2),
	.in3(data_in3),
	.ot(data_in_out_mux)
);

endmodule

















