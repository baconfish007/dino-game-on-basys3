`timescale 1ns / 1ps
module seven_segment_display(
    input clk, // 时钟
    input rst, // 复位
    input [15:0] data, // 数据
    output reg [3:0] gating, // 数码管选通
    output reg [7:0] num // 数字
    );
    localparam GATING_CNT_MAX = 17'd125000 - 17'b1;
    reg [16:0] gating_cnt;
    always @(posedge clk) begin
        if (rst) gating_cnt <= 17'b0;
        else if (gating_cnt == GATING_CNT_MAX) gating_cnt <= 17'b0;
        else gating_cnt <= gating_cnt + 17'b1;
    end
    wire gating_f50hz = (gating_cnt == GATING_CNT_MAX);

    reg [3:0] gating_scan;
    always @(posedge clk) begin
        if (rst) gating_scan <= 4'b1110;
        else if (gating_f50hz) gating_scan <= {gating_scan[2:0], gating_scan[3]};
    end

    always @(*) begin
        if (data[15:4] == 12'd0) gating = {3'b111, gating_scan[0]};
        else if (data[15:8] == 8'd0) gating = {2'b11, gating_scan[1:0]};
        else if (data[15:12] == 4'd0) gating = {1'b1, gating_scan[2:0]};
        else gating = gating_scan;
    end

    reg [3:0] data_seg;
    always @(*) begin
        if (gating[0] == 1'b0) data_seg = data[3:0];
        else if (gating[1] == 1'b0) data_seg = data[7:4];
        else if (gating[2] == 1'b0) data_seg = data[11:8];
        else if (gating[3] == 1'b0) data_seg = data[15:12];
        else data_seg = 4'hf;
    end

    always @(*) begin
        case (data_seg)
            4'h0: num = 8'hc0;
            4'h1: num = 8'hf9;
            4'h2: num = 8'ha4;
            4'h3: num = 8'hb0;
            4'h4: num = 8'h99;
            4'h5: num = 8'h92;
            4'h6: num = 8'h82;
            4'h7: num = 8'hf8;
            4'h8: num = 8'h80;
            4'h9: num = 8'h90;
            default: num = 8'hff;
        endcase
    end
endmodule
