`default_nettype none
module input_handshake (
    input  wire clk,
    input  wire rst,


    input  wire        req_rx,
    input  wire [7:0]  data_in,
    output reg         ack_rx,


    output wire [31:0] data0,
    output wire [31:0] data1,
    output wire [31:0] data2,
    output wire [31:0] data3,

    output wire [31:0] master_key0,
    output wire [31:0] master_key1,
    output wire [31:0] master_key2,
    output wire [31:0] master_key3
);


    reg req_rx_d1, req_rx_d2;

    always @(posedge clk) begin
        req_rx_d1 <= req_rx;
        req_rx_d2 <= req_rx_d1;
    end

    wire req_rx_sync = req_rx_d2;


    localparam IDLE  = 1'b0;
    localparam WAIT0 = 1'b1;

    reg state;


    reg [4:0] byte_cnt; 
    wire [3:0] idx;
    assign idx = byte_cnt[3:0];

    reg [7:0] key_mem  [0:15];
    reg [7:0] data_mem [0:15];

    integer i;


    always @(posedge clk) begin
        if (rst) begin
            state    <= IDLE;
            ack_rx      <= 0;
            byte_cnt <= 0;

            for (i = 0; i < 16; i = i + 1) begin
                key_mem[i]  <= 0;
                data_mem[i] <= 0;
            end

        end else begin
            case (state)
                IDLE: begin
                    if (req_rx_sync) begin
                        
                        if (byte_cnt < 16)
                            key_mem[idx] <= data_in;
                        else
                            data_mem[idx] <= data_in;

                        ack_rx   <= 1;
                        state <= WAIT0;
                    end
                end

                WAIT0: begin
                    if (!req_rx_sync) begin
                        ack_rx   <= 0;
                        state <= IDLE;

                        
                        if (byte_cnt == 31)
                            byte_cnt <= 0;
                        else
                            byte_cnt <= byte_cnt + 1;
                    end
                end
            endcase
        end
    end


    assign data0 = {data_mem[3], data_mem[2], data_mem[1], data_mem[0]};
    assign data1 = {data_mem[7], data_mem[6], data_mem[5], data_mem[4]};
    assign data2 = {data_mem[11], data_mem[10], data_mem[9], data_mem[8]};
    assign data3 = {data_mem[15], data_mem[14], data_mem[13], data_mem[12]};

    assign master_key0 = {key_mem[3], key_mem[2], key_mem[1], key_mem[0]};
    assign master_key1 = {key_mem[7], key_mem[6], key_mem[5], key_mem[4]};
    assign master_key2 = {key_mem[11], key_mem[10], key_mem[9], key_mem[8]};
    assign master_key3 = {key_mem[15], key_mem[14], key_mem[13], key_mem[12]};

endmodule
