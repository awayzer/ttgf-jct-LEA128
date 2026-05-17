`default_nettype none

module output_handshake (
    input  wire        clk,
    input  wire        rst,

    input  wire        req,
    input  wire        ack,

    output reg         valid,
    output reg  [7:0]  data,

    input  wire [7:0] data0,
    input  wire [7:0] data1,
    input  wire [7:0] data2,
    input  wire [7:0] data3,
    input  wire [7:0] data4,
    input  wire [7:0] data5,
    input  wire [7:0] data6,
    input  wire [7:0] data7,
    input  wire [7:0] data8,
    input  wire [7:0] data9,
    input  wire [7:0] data10,
    input  wire [7:0] data11,
    input  wire [7:0] data12,
    input  wire [7:0] data13,
    input  wire [7:0] data14,
    input  wire [7:0] data15
);


    localparam IDLE          = 3'd0;
    localparam SEND_VALID    = 3'd1;
    localparam WAIT_ACK_H    = 3'd2;
    localparam WAIT_ACK_L    = 3'd3;
    localparam DONE          = 3'd4;

    reg [2:0] state;
    reg [3:0] index;


    reg req_d1, req_d2;
    reg ack_d1, ack_d2;

    wire req_sync = req_d2;
    wire ack_sync = ack_d2;


    always @(posedge clk) begin
        req_d1 <= req;
        req_d2 <= req_d1;

        ack_d1 <= ack;
        ack_d2 <= ack_d1;
    end


    always @(*) begin
        case (index)
            4'd0:  data = data0;
            4'd1:  data = data1;
            4'd2:  data = data2;
            4'd3:  data = data3;
            4'd4:  data = data4;
            4'd5:  data = data5;
            4'd6:  data = data6;
            4'd7:  data = data7;
            4'd8:  data = data8;
            4'd9:  data = data9;
            4'd10: data = data10;
            4'd11: data = data11;
            4'd12: data = data12;
            4'd13: data = data13;
            4'd14: data = data14;
            4'd15: data = data15;
            default: data = 8'b0;
        endcase
    end


    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            index <= 4'd0;
            valid <= 1'b0;
        end else begin
            case (state)

                IDLE: begin
                    valid <= 1'b0;
                    if (req_sync)
                        state <= SEND_VALID;
                end

                SEND_VALID: begin
                    valid <= 1'b1;
                    state <= WAIT_ACK_H;
                end

                WAIT_ACK_H: begin
                    if (ack_sync) begin
                        valid <= 1'b0;
                        state <= WAIT_ACK_L;
                    end
                end

                WAIT_ACK_L: begin
                    if (!ack_sync) begin
                        if (index == 4'd15) begin
                            state <= DONE;
                        end else begin
                            index <= index + 1'b1;
                            state <= SEND_VALID;
                        end
                    end
                end

                DONE: begin
                    valid <= 1'b0;
                    if (!req_sync)
                        state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
