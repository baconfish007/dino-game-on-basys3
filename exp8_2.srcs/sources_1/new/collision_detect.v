`timescale 1ns / 1ps
module collision_detect(
    input [9:0] dino_ul_y,
    input [9:0] cactus_ul_x,
    input [1:0] game_state,
    output collision
    );
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam LOSE = 2'b10;

    localparam DINO_W = 10'd64;
    localparam DINO_H = 10'd64;
    localparam CACTUS_W = 10'd64;
    localparam CACTUS_H = 10'd64;
    
    localparam DINO_UL_X = 10'd80;
    localparam CACTUS_UL_Y = 10'd276;
    
    localparam COLLISION_OFFSET = 10'd4;

    localparam DINO_LEFT = DINO_UL_X + COLLISION_OFFSET;
    localparam DINO_RIGHT = DINO_UL_X + DINO_W - 10'd1 - COLLISION_OFFSET;
    wire [9:0] dino_bottom = dino_ul_y + DINO_H - 10'd1 - COLLISION_OFFSET;

    localparam CACTUS_TOP = CACTUS_UL_Y + COLLISION_OFFSET;
    wire [9:0] cactus_left = cactus_ul_x + COLLISION_OFFSET;
    wire [9:0] cactus_right = cactus_ul_x + CACTUS_W - 10'd1 - COLLISION_OFFSET;

    assign collision = game_state == RUN && !(DINO_RIGHT < cactus_left || DINO_LEFT > cactus_right || dino_bottom < CACTUS_TOP);
endmodule
