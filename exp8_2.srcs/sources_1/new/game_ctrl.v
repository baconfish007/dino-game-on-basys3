`timescale 1ns / 1ps
module game_ctrl(
    input clk,
    input rst,
    input start,
    input collision,
    input frame_disp_over,
    output reg [1:0] cs
    );
    reg [1:0] ns;
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    reg start2fdo;
    always @(posedge clk) begin
        if (rst) start2fdo <= 1'd0;
        else if (frame_disp_over) start2fdo <= 1'd0;
        else if (start) start2fdo <= 1'd1;
    end

    reg collision2fdo;
    always @(posedge clk) begin
        if (rst) collision2fdo <= 1'd0;
        else if (frame_disp_over) collision2fdo <= 1'd0;
        else if (collision) collision2fdo <= 1'd1;
    end

    always @(posedge clk) begin
        if (rst) cs <= IDLE;
        else cs <= ns;
    end

    always @(*) begin
        if (frame_disp_over) begin
            case (cs)
                IDLE: begin
                    if (start2fdo) ns = RUN;
                    else ns = cs;
                end
                RUN: begin
                    if (collision2fdo) ns = LOSE;
                    else ns = cs;
                end
                LOSE: begin
                    if (start2fdo) ns = IDLE;
                    else ns = cs;
                end
                default: ns = IDLE;
            endcase
        end
        else ns = cs;
    end
endmodule
