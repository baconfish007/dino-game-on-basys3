`timescale 1ns / 1ps
module dino_jump(
    input clk,
    input rst_raw,
    input btn_raw,
    output h_sync,
    output v_sync,
    output [11:0] disp_RGB444,
    output [3:0] gating,
    output [7:0] num
    );
    wire clk_25m;
    wire clk_locked;
    wire rst;
    wire [15:0] rom_addr;
    wire [11:0] image_pixel;
    wire btn;
    wire [11:0] data_RGB444;
    wire [9:0] now_disp_pixel_x;
    wire [9:0] now_disp_pixel_y;
    wire [9:0] next_disp_pixel_x;
    wire [9:0] next_disp_pixel_y;
    wire [9:0] dino_ul_y;
    wire [9:0] cactus_ul_x;
    wire frame_disp_over;
    wire [1:0] game_state;
    wire collision;
    wire success_jump;
    wire [15:0] seven_seg_data;
    wire [3:0] dino_disp_state;

    clk_wiz u_clk_wiz(
        .clk_25m(clk_25m),
        .reset(rst_raw),
        .locked(clk_locked),
        .clk_in1(clk)
    );

    reset_sync u_reset_sync(
        .clk(clk_25m),
        .rst_raw(rst_raw),
        .clk_locked(clk_locked),
        .rst(rst)
    );
    
    image_rom u_image_rom(
        .clka(clk_25m),
        .addra(rom_addr),
        .douta(image_pixel)
    );

    press_detect u_press_detect(
        .clk(clk_25m),
        .rst(rst),
        .btn_raw(btn_raw),
        .btn_edge(btn)
    );

    vga u_vga(
        .clk(clk_25m),
        .rst(rst),
        .data_RGB444(data_RGB444),
        .now_disp_pixel_x(now_disp_pixel_x),
        .now_disp_pixel_y(now_disp_pixel_y),
        .next_disp_pixel_x(next_disp_pixel_x),
        .next_disp_pixel_y(next_disp_pixel_y),
        .frame_disp_over(frame_disp_over),
        .disp_RGB444(disp_RGB444),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );

    data_generator u_data_generator(
        .now_disp_pixel_x(now_disp_pixel_x),
        .now_disp_pixel_y(now_disp_pixel_y),
        .next_disp_pixel_x(next_disp_pixel_x),
        .next_disp_pixel_y(next_disp_pixel_y),
        .dino_ul_y(dino_ul_y),
        .cactus_ul_x(cactus_ul_x),
        .game_state(game_state),
        .dino_disp_state(dino_disp_state),
        .image_pixel(image_pixel),
        .rom_addr(rom_addr),
        .data_RGB444(data_RGB444)
    );

    game_ctrl u_game_ctrl(
        .clk(clk_25m),
        .rst(rst),
        .start(btn),
        .collision(collision),
        .frame_disp_over(frame_disp_over),
        .cs(game_state)
    );

    dino_ctrl u_dino_ctrl(
        .clk(clk_25m),
        .rst(rst),
        .jump(btn),
        .game_state(game_state),
        .frame_disp_over(frame_disp_over),
        .dino_ul_y(dino_ul_y)
    );

    dino_change u_dino_change(
        .clk(clk_25m),
        .rst(rst),
        .game_state(game_state),
        .frame_disp_over(frame_disp_over),
        .dino_disp_state(dino_disp_state)
    );

    cactus_ctrl u_cactus_ctrl(
        .clk(clk_25m),
        .rst(rst),
        .game_state(game_state),
        .frame_disp_over(frame_disp_over),
        .cactus_ul_x(cactus_ul_x),
        .success_jump(success_jump)
    );

    collision_detect u_collision_detect(
        .dino_ul_y(dino_ul_y),
        .cactus_ul_x(cactus_ul_x),
        .game_state(game_state),
        .collision(collision)
    );

    success_counter u_success_counter(
        .clk(clk_25m),
        .rst(rst),
        .success_jump(success_jump),
        .game_state(game_state),
        .seven_seg_data(seven_seg_data)
    );

    seven_segment_display u_seven_segment_display(
        .clk(clk_25m),
        .rst(rst),
        .data(seven_seg_data),
        .gating(gating),
        .num(num)
    );
endmodule
