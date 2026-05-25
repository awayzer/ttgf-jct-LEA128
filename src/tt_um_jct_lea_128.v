

`default_nettype none

module tt_um_jct_lea (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


    
wire   in_res;

assign in_res = ~rst_n;

reg sync_ff1;
reg sync_ff2;
wire rst_sync;

always @(posedge clk or posedge in_res) begin
    if (in_res) begin
        sync_ff1 <= 1'b1;
        sync_ff2 <= 1'b1;
    end
    else begin
        sync_ff1 <= 1'b0;
        sync_ff2 <= sync_ff1;
    end
end

assign rst_sync = sync_ff2;

wire [31:0] d0, d1, d2, d3;   
wire [31:0] k0, k1, k2, k3;

wire [7:0] p0;  wire [7:0] p1;
wire [7:0] p2;  wire [7:0] p3;
wire [7:0] p4;  wire [7:0] p5;
wire [7:0] p6;  wire [7:0] p7;
wire [7:0] p8;  wire [7:0] p9;
wire [7:0] p10; wire [7:0] p11;
wire [7:0] p12; wire [7:0] p13;
wire [7:0] p14; wire [7:0] p15;  

reg enc_d;
reg dec_d;
wire rising_edge_enc;
wire rising_edge_dec;

assign uio_oe  = 8'hc0;
assign uio_out[5:0]  = 6'b0; 

always @(posedge clk) begin
    if (rst_sync)begin
		enc_d <= 1'b0;
		dec_d <= 1'b0;
    end else begin 
        enc_d <= uio_in[3];
		dec_d <= uio_in[4];
    end	

end

assign rising_edge_enc  =  uio_in[3] & ~ enc_d;
assign rising_edge_dec  =  uio_in[4] & ~ dec_d;



input_handshake u0(
    .clk(clk),
    .rst(rst_sync),
    .req_rx(uio_in[0]),
    .data_in(ui_in),
    .ack_rx(uio_out[7]),
    .data0(d0),
    .data1(d1),
    .data2(d2),
    .data3(d3),
    .master_key0(k0),
    .master_key1(k1),
    .master_key2(k2),
    .master_key3(k3)
);


lea_128_top u1(
	.clk(clk),
	.reset(rst_sync),
	.pb_enc(rising_edge_enc),
	.pb_dec(rising_edge_dec),
	.key_in0(k1),
	.key_in1(k3),
	.key_in2(k2),
	.key_in3(k0),
	.data_in0(d3),
	.data_in1(d2),
	.data_in2(d1),
	.data_in3(d0),
	.data0(p0),
	.data1(p1),
	.data2(p2),
	.data3(p3),
	.data4(p4),
	.data5(p5),
	.data6(p6),
	.data7(p7),
	.data8(p8),
	.data9(p9),
	.data10(p10),
	.data11(p11),
	.data12(p12),
	.data13(p13),
	.data14(p14),
	.data15(p15)
);



output_handshake u2(
	.clk(clk),
	.rst(rst_sync),
	.req(uio_in[1]),
	.ack(uio_in[2]),
	.valid(uio_out[6]),
	.data(uo_out),
	.data0(p0),
	.data1(p1),
	.data2(p2),
	.data3(p3),
	.data4(p4),
	.data5(p5),
	.data6(p6),
	.data7(p7),
	.data8(p8),
	.data9(p9),
	.data10(p10),
	.data11(p11),
	.data12(p12),
	.data13(p13),
	.data14(p14),	
	.data15(p15)
);









  // avoid linter warning about unused pins:
    wire _unused_pins = &{ena, uio_in[5], uio_in[6], uio_in[7]};

endmodule  
