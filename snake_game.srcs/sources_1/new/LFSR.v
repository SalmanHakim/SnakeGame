`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2019 13:01:58
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input CLK,
    input RESET,
    output [7:0] XADDR_OUT,
    output [6:0] YADDR_OUT
    );
    
    reg [7:0] xpixel;
    reg [6:0] ypixel;
    
    wire xOut, yOut;
    
    assign xOut = (xpixel[7]) ^~ (xpixel[5]) ^~ (xpixel[4]) ^~ (xpixel[3]);
    assign yOut = (ypixel[6]) ^~ (ypixel[5]);
    
    always@(posedge CLK) begin
        if (RESET)
            xpixel <= 8'b00110011;
        else
            xpixel = {xpixel[6:0], xOut};
    end
    
    always@(posedge CLK) begin
        if (RESET)
            ypixel <= 7'b0101001;
        else
            ypixel = {ypixel[5:0], yOut};
    end
    
    assign XADDR_OUT = xpixel;
    assign YADDR_OUT = ypixel;
    
endmodule
