`timescale 1ns / 1ps
module cactus_ctrl(
    input clk,
    input rst,
    input [1:0] game_state,
    input frame_disp_over,
    output reg [9:0] cactus_ul_x,
    output success_jump
    );
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam CACTUS_W = 10'd64;
    localparam CACTUS_UL_X_MAX = 10'd576;
    localparam CACTUS_V = 10'd8;
    always @(posedge clk) begin
        if (rst) cactus_ul_x <= CACTUS_UL_X_MAX;
        else if (frame_disp_over) begin
            if (game_state == IDLE) cactus_ul_x <= CACTUS_UL_X_MAX;
            else if (game_state == RUN) begin
                if (cactus_ul_x == CACTUS_V) cactus_ul_x <= CACTUS_UL_X_MAX;
                else cactus_ul_x <= cactus_ul_x - CACTUS_V;
            end
        end
    end

    assign success_jump = game_state == RUN && frame_disp_over && cactus_ul_x == CACTUS_V;
endmodule
