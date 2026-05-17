`default_nettype none
module processed_data_storage(
    input wire clk,
    input wire reset,
    input wire [1:0] q,
    input wire enable_unit,
    input wire [31:0] data_in,
    input wire operational_mod,

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

  
    reg [31:0] data [0:3];
	wire [1:0] q_in;

    integer i;
	assign q_in = q - 1;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                data[i] <= 32'b0;
            end
        end else if (enable_unit) begin
            if (operational_mod) begin
                data[~(q_in)] <= data_in;  
            end else begin
                data[q_in] <= data_in;
            end
        end
    end


    assign data0  = data[0][7:0];
    assign data1  = data[0][15:8];
    assign data2  = data[0][23:16];
    assign data3  = data[0][31:24];

    assign data4  = data[1][7:0];
    assign data5  = data[1][15:8];
    assign data6  = data[1][23:16];
    assign data7  = data[1][31:24];

    assign data8  = data[2][7:0];
    assign data9  = data[2][15:8];
    assign data10 = data[2][23:16];
    assign data11 = data[2][31:24];

    assign data12 = data[3][7:0];
    assign data13 = data[3][15:8];
    assign data14 = data[3][23:16];
    assign data15 = data[3][31:24];

endmodule