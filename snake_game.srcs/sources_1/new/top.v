`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2019 01:21:05
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK,
    input RESET,
    input BTNU,
    input BTNL,
    input BTND,
    input BTNR,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT
    );
    
    wire score_trig;
    wire [1:0] msm_state; 
    wire [2:0] navi_state;
    wire [11:0] colour;
    wire [3:0] score;
    wire [14:0] target_addr;
    wire [9:0] addX;
    wire [8:0] addY;
                                
    MSM master (
        .CLK(CLK),
        .RESET(RESET),
        .BTNU(BTNU),
        .BTNR(BTNR),
        .BTNL(BTNL),
        .BTND(BTND),
        .SCORE_IN(score),
        .STATE_OUT(msm_state)
        );
        
    score score_c (
        .CLK(CLK),
        .RESET(RESET),
        .TRIGGER(score_trig),
        .SEG_SELECT(SEG_SELECT),
        .HEX_OUT(HEX_OUT),
        .SCORE_OUT(score)
        );
        
    navigation navi (
        .CLK(CLK),
        .RESET(RESET),
        .BTNU(BTNU),
        .BTNR(BTNR),
        .BTNL(BTNL),
        .BTND(BTND),
        .STATE_OUT(navi_state)
        );
        
    vga_wrapper VGA (
        .CLK(CLK),
        .RESET(RESET),
        .MSM_STATE(msm_state),
        .COLOUR_IN(colour),
        .addX(addX),
        .addY(addY),
        .COLOUR_OUT(COLOUR_OUT),
        .HS(HS),
        .VS(VS)
        );
        
    target_gen target (
        .CLK(CLK),
        .RESET(RESET),
        .FOOD_EATEN(score_trig),
        .TARGET_OUT(target_addr)
        );
        
    snake snake_c (
        .CLK(CLK),
        .RESET(RESET),
        .MSM_STATE(msm_state),
        .NAVI_STATE(navi_state),
        .ADDX(addX),
        .ADDY(addY),
        .TARGET_IN(target_addr),
        .SCORE_IN(score),
        .COLOUR_OUT(colour),
        .TRIGGER(score_trig)
        );
    
endmodule
