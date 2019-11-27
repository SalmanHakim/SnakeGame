`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 11:47:45
// Design Name: 
// Module Name: vga_wrapper
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


module vga_wrapper(
    input CLK,
    input RESET,
    input [1:0] MSM_STATE,
    input [11:0] COLOUR_IN,
    output [9:0] addX,
    output [8:0] addY,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS
    );
    
    wire [11:0] colour;
    wire [9:0] xpixel;
    wire [8:0] ypixel;
    
    VGA v_interface (
        .CLK(CLK),
        .COLOUR_IN(colour),
        .COLOUR_OUT(COLOUR_OUT),
        .VS(VS),
        .HS(HS),
        .ADDX(xpixel),
        .ADDY(ypixel)
        );
        
    colourControl cc (
        .CLK(CLK),
        .RESET(RESET),
        .MSM_STATE(MSM_STATE),
        .COLOUR_IN(COLOUR_IN),
        .addX(xpixel),
        .addY(ypixel),
        .COLOUR_OUT(colour)
        );
        
    assign addX = xpixel;
    assign addY = ypixel;
   
endmodule
