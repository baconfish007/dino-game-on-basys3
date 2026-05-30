`timescale 1ns / 1ps
module vga(
    input clk,
    input rst,
    input [11:0] data_RGB444,
    output [9:0] now_disp_pixel_x,
    output [9:0] now_disp_pixel_y,
    output reg [9:0] next_disp_pixel_x,
    output reg [9:0] next_disp_pixel_y,
    output frame_disp_over,
    output [11:0] disp_RGB444,
    output h_sync,
    output v_sync
    );
    localparam H_SYNC_END = 10'd96;
    localparam H_BP_END = 10'd144;
    localparam H_ACTIVE_END = 10'd784;
    localparam H_FP_END = 10'd800;

    localparam V_SYNC_END = 10'd2;
    localparam V_BP_END = 10'd35;
    localparam V_ACTIVE_END = 10'd515;
    localparam V_FP_END = 10'd525;

    localparam SCREEN_W = H_ACTIVE_END - H_BP_END;
    localparam SCREEN_H = V_ACTIVE_END - V_BP_END;

    reg [9:0] h_cnt;
    wire h_cnt_over = (h_cnt == H_FP_END - 10'd1);
    always @(posedge clk) begin
        if (rst) h_cnt <= 10'd0;
        else begin
            if (h_cnt_over) h_cnt <= 10'd0;
            else h_cnt <= h_cnt + 10'd1;
        end
    end

    reg [9:0] v_cnt;
    wire v_cnt_over = (v_cnt == V_FP_END - 10'd1);
    always @(posedge clk) begin
        if (rst) v_cnt <= 10'd0;
        else if (h_cnt_over) begin
            if (v_cnt_over) v_cnt <= 10'd0;
            else v_cnt <= v_cnt + 10'd1;
        end
    end

    wire h_disp_active = ((h_cnt >= H_BP_END) && (h_cnt < H_ACTIVE_END));
    wire v_disp_active = ((v_cnt >= V_BP_END) && (v_cnt < V_ACTIVE_END));
    wire disp_active = h_disp_active && v_disp_active;
    
    assign now_disp_pixel_x =  (h_disp_active) ? h_cnt - H_BP_END : SCREEN_W;
    assign now_disp_pixel_y =  (v_disp_active) ? v_cnt - V_BP_END : SCREEN_H;

    // =================
    // 下一像素坐标的计算
    // =================
    always @(*) begin
        if (!h_disp_active) next_disp_pixel_x = 10'd0;
        else next_disp_pixel_x = now_disp_pixel_x + 1'd1;
    end

    always @(*) begin
        if (!v_disp_active) next_disp_pixel_y = 10'd0;
        else if (!h_disp_active) next_disp_pixel_y = now_disp_pixel_y + 1'd1;
        else next_disp_pixel_y = now_disp_pixel_y;
    end

    assign frame_disp_over = v_cnt_over && h_cnt_over; // 一帧的最后一拍

    assign h_sync = (h_cnt >= H_SYNC_END); // 行同步
    assign v_sync = (v_cnt >= V_SYNC_END); // 场同步
    
    assign disp_RGB444 = (disp_active) ? data_RGB444 : 12'h0; // 显示像素
endmodule
