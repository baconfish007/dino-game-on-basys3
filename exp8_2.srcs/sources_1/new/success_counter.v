`timescale 1ns / 1ps
module success_counter(
    input clk,
    input rst,
    input success_jump,
    input [1:0] game_state,
    output [15:0] seven_seg_data
    );
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam [3:0] SUCCESS_CNT_MAX = 4'd9;
    
    reg [3:0] success_cnt_1;
    always @(posedge clk) begin
        if (rst) success_cnt_1 <= 4'd0;
        else if (game_state == IDLE) success_cnt_1 <= 4'd0;
        else if (game_state == RUN && success_jump) begin
            if (success_cnt_1 == SUCCESS_CNT_MAX) success_cnt_1 <= 4'd0;
            else success_cnt_1 <= success_cnt_1 + 4'd1;
        end
    end

    reg [3:0] success_cnt_10;
    always @(posedge clk) begin
        if (rst) success_cnt_10 <= 4'd0;
        else if (game_state == IDLE) success_cnt_10 <= 4'd0;
        else if (game_state == RUN && success_cnt_1 == SUCCESS_CNT_MAX && success_jump) begin
            if (success_cnt_10 == SUCCESS_CNT_MAX) success_cnt_10 <= 4'd0;
            else success_cnt_10 <= success_cnt_10 + 4'd1;
        end
    end

    reg [3:0] success_cnt_100;
    always @(posedge clk) begin
        if (rst) success_cnt_100 <= 4'd0;
        else if (game_state == IDLE) success_cnt_100 <= 4'd0;
        else if (game_state == RUN && success_cnt_10 == SUCCESS_CNT_MAX && success_jump) begin
            if (success_cnt_100 == SUCCESS_CNT_MAX) success_cnt_100 <= 4'd0;
            else success_cnt_100 <= success_cnt_100 + 4'd1;
        end
    end

    reg [3:0] success_cnt_1000;
    always @(posedge clk) begin
        if (rst) success_cnt_1000 <= 4'd0;
        else if (game_state == IDLE) success_cnt_1000 <= 4'd0;
        else if (game_state == RUN && success_cnt_100 == SUCCESS_CNT_MAX && success_jump) begin
            if (success_cnt_1000 == SUCCESS_CNT_MAX) success_cnt_1000 <= 4'd0;
            else success_cnt_1000 <= success_cnt_1000 + 4'd1;
        end
    end

    assign seven_seg_data = {success_cnt_1000, success_cnt_100, success_cnt_10, success_cnt_1};
endmodule
