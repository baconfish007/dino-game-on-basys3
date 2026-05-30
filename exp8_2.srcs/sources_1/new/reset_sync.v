`timescale 1ns / 1ps
module reset_sync(
    input clk,
    input rst_raw,
    input clk_locked,
    output rst
    );
    reg [1:0] rst_ff;
    wire force_rst = rst_raw || ~clk_locked;
    always @(posedge clk, posedge force_rst) begin
        if (force_rst) rst_ff <= 2'b11;
        else rst_ff <= {rst_ff[0], 1'b0};
    end
    assign rst = rst_ff[1];
endmodule
