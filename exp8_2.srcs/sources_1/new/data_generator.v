`timescale 1ns / 1ps
module data_generator(
    input [9:0] now_disp_pixel_x, // 当前像素x坐标（显示坐标系）
    input [9:0] now_disp_pixel_y, // 当前像素y坐标（显示坐标系）
    input [9:0] next_disp_pixel_x, // 下一像素x坐标（显示坐标系）
    input [9:0] next_disp_pixel_y, // 下一像素y坐标（显示坐标系）
    input [9:0] dino_ul_y,
    input [9:0] cactus_ul_x,
    input [1:0] game_state,
    input [3:0] dino_disp_state,
    input [11:0] image_pixel, // 盒子内显示的图像
    output reg [15:0] rom_addr,
    output reg [11:0] data_RGB444
    );
    localparam DINO_W = 10'd64;
    localparam DINO_H = 10'd64;
    localparam DINO_UL_X = 10'd80;
    wire now_in_dino = (now_disp_pixel_x >= DINO_UL_X && now_disp_pixel_x < DINO_UL_X + DINO_W) && (now_disp_pixel_y >= dino_ul_y && now_disp_pixel_y < dino_ul_y + DINO_H);
    wire next_in_dino = (next_disp_pixel_x >= DINO_UL_X && next_disp_pixel_x < DINO_UL_X + DINO_W) && (next_disp_pixel_y >= dino_ul_y && next_disp_pixel_y < dino_ul_y + DINO_H);

    localparam CACTUS_W = 10'd64;
    localparam CACTUS_H = 10'd64;
    localparam CACTUS_UL_Y = 10'd276;
    wire now_in_cactus = (now_disp_pixel_x >= cactus_ul_x && now_disp_pixel_x < cactus_ul_x + CACTUS_W) && (now_disp_pixel_y >= CACTUS_UL_Y && now_disp_pixel_y < CACTUS_UL_Y + CACTUS_H);
    wire next_in_cactus = (next_disp_pixel_x >= cactus_ul_x && next_disp_pixel_x < cactus_ul_x + CACTUS_W) && (next_disp_pixel_y >= CACTUS_UL_Y && next_disp_pixel_y < CACTUS_UL_Y + CACTUS_H);

    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam [9:0] GAMEOVER_W = 10'd64;
    localparam [9:0] GAMEOVER_H = 10'd64;
    localparam [9:0] GAMEOVER_Y = 10'd96;
    localparam [9:0] GAMEOVER_G_X  = 10'd8;
    wire now_in_g = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_G_X && now_disp_pixel_x < GAMEOVER_G_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_g = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_G_X && next_disp_pixel_x < GAMEOVER_G_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    localparam [9:0] GAMEOVER_A_X  = 10'd88;
    wire now_in_a = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_A_X && now_disp_pixel_x < GAMEOVER_A_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_a = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_A_X && next_disp_pixel_x < GAMEOVER_A_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    localparam [9:0] GAMEOVER_M_X  = 10'd168;
    wire now_in_m = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_M_X && now_disp_pixel_x < GAMEOVER_M_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_m = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_M_X && next_disp_pixel_x < GAMEOVER_M_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    
    localparam [9:0] GAMEOVER_E1_X = 10'd248;
    wire now_in_e1 = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_E1_X && now_disp_pixel_x < GAMEOVER_E1_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_e1 = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_E1_X && next_disp_pixel_x < GAMEOVER_E1_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    localparam [9:0] GAMEOVER_O_X  = 10'd328;
    wire now_in_o = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_O_X && now_disp_pixel_x < GAMEOVER_O_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_o = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_O_X && next_disp_pixel_x < GAMEOVER_O_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    
    localparam [9:0] GAMEOVER_V_X  = 10'd408;
    wire now_in_v = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_V_X && now_disp_pixel_x < GAMEOVER_V_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_v = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_V_X && next_disp_pixel_x < GAMEOVER_V_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    localparam [9:0] GAMEOVER_E2_X = 10'd488;
    wire now_in_e2 = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_E2_X && now_disp_pixel_x < GAMEOVER_E2_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_e2 = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_E2_X && next_disp_pixel_x < GAMEOVER_E2_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    localparam [9:0] GAMEOVER_R_X  = 10'd568;
    wire now_in_r = game_state == LOSE && (now_disp_pixel_x >= GAMEOVER_R_X && now_disp_pixel_x < GAMEOVER_R_X + GAMEOVER_W) && (now_disp_pixel_y >= GAMEOVER_Y && now_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);
    wire next_in_r = game_state == LOSE && (next_disp_pixel_x >= GAMEOVER_R_X && next_disp_pixel_x < GAMEOVER_R_X + GAMEOVER_W) && (next_disp_pixel_y >= GAMEOVER_Y && next_disp_pixel_y < GAMEOVER_Y + GAMEOVER_H);

    reg [9:0] rom_addr_x;
    always @(*) begin
        if (next_in_dino) rom_addr_x = next_disp_pixel_x - DINO_UL_X;
        else if (next_in_cactus) rom_addr_x = next_disp_pixel_x - cactus_ul_x;
        else if (next_in_g) rom_addr_x = next_disp_pixel_x - GAMEOVER_G_X;
        else if (next_in_a) rom_addr_x = next_disp_pixel_x - GAMEOVER_A_X;
        else if (next_in_m) rom_addr_x = next_disp_pixel_x - GAMEOVER_M_X;
        else if (next_in_e1) rom_addr_x = next_disp_pixel_x - GAMEOVER_E1_X;
        else if (next_in_o) rom_addr_x = next_disp_pixel_x - GAMEOVER_O_X;
        else if (next_in_v) rom_addr_x = next_disp_pixel_x - GAMEOVER_V_X;
        else if (next_in_e2) rom_addr_x = next_disp_pixel_x - GAMEOVER_E2_X;
        else if (next_in_r) rom_addr_x = next_disp_pixel_x - GAMEOVER_R_X;
        else rom_addr_x = 10'd0;
    end

    reg [9:0] rom_addr_y;
    always @(*) begin
        if (next_in_dino) rom_addr_y = next_disp_pixel_y - dino_ul_y;
        else if (next_in_cactus) rom_addr_y = next_disp_pixel_y - CACTUS_UL_Y;
        else if (next_in_g || next_in_a || next_in_m || next_in_e1 || next_in_o || next_in_v || next_in_e2 || next_in_r) rom_addr_y = next_disp_pixel_y - GAMEOVER_Y;
        else rom_addr_y = 10'd0;
    end

    // 寻址结构：{image_ID(4'), rom_addr_y(6')[5:0], rom_addr_x(6')[5:0]}(16')
    // image_ID     Name
    // 0            恐龙 - 双爪着地
    // 1            恐龙 - 抬前爪
    // 2            恐龙 - 抬后爪
    // 3            恐龙 - 瞪眼（输）
    // 4            仙人掌
    // 5            A
    // 6            E
    // 7            G
    // 8            M
    // 9            O
    // 10           R
    // 11           V
    localparam DINO_RUN_0 = 4'b0001;
    localparam DINO_RUN_1 = 4'b0010;
    localparam DINO_RUN_2 = 4'b0100;
    always @(*) begin
        if (next_in_dino) begin
            if (dino_disp_state[3] == 1'b1) rom_addr = {4'd3, rom_addr_y[5:0], rom_addr_x[5:0]};
            else
                case (dino_disp_state)
                    DINO_RUN_0: rom_addr = {4'd0, rom_addr_y[5:0], rom_addr_x[5:0]};
                    DINO_RUN_1: rom_addr = {4'd1, rom_addr_y[5:0], rom_addr_x[5:0]};
                    DINO_RUN_2: rom_addr = {4'd2, rom_addr_y[5:0], rom_addr_x[5:0]};
                    default: rom_addr = {4'd0, rom_addr_y[5:0], rom_addr_x[5:0]};
                endcase
        end
        else if (next_in_cactus) rom_addr = {4'd4, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_g) rom_addr = {4'd7, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_a) rom_addr = {4'd5, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_m) rom_addr = {4'd8, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_e1) rom_addr = {4'd6, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_o) rom_addr = {4'd9, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_v) rom_addr = {4'd11, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_e2) rom_addr = {4'd6, rom_addr_y[5:0], rom_addr_x[5:0]};
        else if (next_in_r) rom_addr = {4'd10, rom_addr_y[5:0], rom_addr_x[5:0]};
        else rom_addr = 16'd0;
    end

    localparam [9:0] SKY_END = 10'd339;
    localparam [9:0] GRASS_END = 10'd379;
    localparam [11:0] SKY_COLOR = 12'h7cf;
    localparam [11:0] GRASS_COLOR = 12'h3a2;
    localparam [11:0] DIRT_COLOR  = 12'h963;
    wire now_in_sky = now_disp_pixel_y <= SKY_END;
    wire now_in_grass = now_disp_pixel_y > SKY_END && now_disp_pixel_y <= GRASS_END;

    always @(*) begin
        if (now_in_dino || now_in_cactus || now_in_g || now_in_a || now_in_m || now_in_e1 || now_in_o || now_in_v || now_in_e2 || now_in_r) data_RGB444 = image_pixel;
        else if (now_in_sky) data_RGB444 = SKY_COLOR;
        else if (now_in_grass) data_RGB444 = GRASS_COLOR; 
        else data_RGB444 = DIRT_COLOR;
    end
endmodule
