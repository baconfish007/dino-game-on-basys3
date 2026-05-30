`timescale 1ns / 1ps
module dino_change(
    input clk,
    input rst,
    input [1:0] game_state,
    input frame_disp_over,
    output reg [3:0] dino_disp_state
    );
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam [3:0] DINO_CHANGE_CNT_MAX = 4'd15 - 4'd1;
    reg [3:0] dino_change_cnt;
    wire dino_change_cnt_over = dino_change_cnt == DINO_CHANGE_CNT_MAX;
    always @(posedge clk) begin
        if (rst) dino_change_cnt <= 4'd0;
        else if (game_state == IDLE) dino_change_cnt <= 4'd0;
        else if (game_state == RUN && frame_disp_over) begin
            if (dino_change_cnt_over) dino_change_cnt <= 4'd0;
            else dino_change_cnt <= dino_change_cnt + 4'd1;
        end
    end

    always @(posedge clk) begin
        if (rst) dino_disp_state <= 4'b0001;
        else if (game_state == IDLE) dino_disp_state <= 4'b0001;
        else if (game_state == RUN && dino_change_cnt_over && frame_disp_over) dino_disp_state <= {1'b0, dino_disp_state[1:0], dino_disp_state[2]};
        else if (game_state == LOSE) dino_disp_state <= {1'b1, dino_disp_state[2:0]};
    end
endmodule
