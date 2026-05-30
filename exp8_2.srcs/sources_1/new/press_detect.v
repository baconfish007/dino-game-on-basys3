`timescale 1ns / 1ps
module press_detect(
    input clk, // 时钟
    input rst, // 复位
    input btn_raw, // 输入按键信号
    output btn_edge
    );

    // 同步
    reg btn_ff0;
    always @(posedge clk) begin
        if (rst) btn_ff0 <= 1'b0;
        else btn_ff0 <= btn_raw;
    end

    reg btn_ff1;
    always @(posedge clk) begin
        if (rst) btn_ff1 <= 1'b0;
        else btn_ff1 <= btn_ff0;
    end

    // 去抖
    reg btn_stable;
    reg [17:0] db_cnt;
    localparam DB_CNT_MAX = 18'd250000 - 18'b1;
    always @(posedge clk) begin
        if (rst) db_cnt <= 18'b0;
        else if (btn_ff1 != btn_stable) begin
                if (db_cnt == DB_CNT_MAX) db_cnt <= 18'b0;
                else db_cnt <= db_cnt + 18'b1;
        end
        else db_cnt <= 18'b0;
    end

    always @(posedge clk) begin
        if (rst) btn_stable <= 1'b0;
        else if(db_cnt == DB_CNT_MAX) btn_stable <= btn_ff1;
    end

    reg btn_stable_d;
    always @(posedge clk) begin
        if (rst) btn_stable_d <= 1'b0;
        else btn_stable_d <= btn_stable;
    end

    // 上升沿检测
    assign btn_edge = (btn_stable & ~btn_stable_d);
endmodule
