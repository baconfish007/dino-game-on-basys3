`timescale 1ns / 1ps
module dino_ctrl(
    input clk,
    input rst,
    input jump,
    input [1:0] game_state,
    input frame_disp_over,
    output reg [9:0] dino_ul_y
    );
    reg [1:0] cs;
    reg [1:0] ns;
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam RUNNING = 2'b00;
    localparam ASCENDING = 2'b01;
    localparam DESCENDING = 2'b10;
    localparam DINO_UL_Y_MAX = 10'd276;
    localparam DINO_UL_Y_MIN = 10'd148;
    localparam JUMP_V = 10'd8;
    
    reg jump2fdo;
    always @(posedge clk) begin
        if (rst) jump2fdo <= 1'd0;
        else if (game_state == RUN) begin
            if (frame_disp_over) jump2fdo <= 1'd0;
            else if (jump) jump2fdo <= 1'd1;
        end
    end

    always @(posedge clk) begin
        if (rst) cs <= RUNNING;
        else cs <= ns;
    end

    wire ascend_end = dino_ul_y == DINO_UL_Y_MIN + JUMP_V;
    wire descend_end = dino_ul_y == DINO_UL_Y_MAX - JUMP_V;

    always @(*) begin
        if (frame_disp_over) begin
            if (game_state == IDLE) ns = RUNNING;
            else if (game_state == RUN) begin
                case (cs)
                    RUNNING: begin
                        if (jump2fdo) ns = ASCENDING;
                        else ns = cs;
                    end
                    ASCENDING: begin
                        if (ascend_end) ns = DESCENDING;
                        else ns = cs;
                    end
                    DESCENDING: begin
                        if (descend_end) ns = RUNNING;
                        else ns = cs;
                    end
                    default: ns = cs; 
                endcase
            end
            else ns = cs;
        end
        else ns = cs;
    end

    always @(posedge clk) begin
        if (rst) dino_ul_y <= DINO_UL_Y_MAX;
        else if (frame_disp_over) begin
            if (game_state == IDLE) dino_ul_y <= DINO_UL_Y_MAX;
            else if (game_state == RUN) begin
                if (cs == ASCENDING) dino_ul_y <= dino_ul_y - JUMP_V;
                else if (cs == DESCENDING) dino_ul_y <= dino_ul_y + JUMP_V;
            end
        end
    end
endmodule
