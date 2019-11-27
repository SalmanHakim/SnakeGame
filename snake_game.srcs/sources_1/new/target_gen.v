`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 21:50:01
// Design Name: 
// Module Name: target_gen
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


module target_gen(
    input CLK,
    input RESET,
    input FOOD_EATEN,
    output [14:0] TARGET_OUT
    );
    
    wire [7:0] xpixel;
    wire [6:0] ypixel;
    
    reg [7:0] x;
    reg [6:0] y;
    
    LFSR random_xy (
        .CLK(CLK),
        .RESET(RESET),
        .XADDR_OUT(xpixel),
        .YADDR_OUT(ypixel)
        );
    
    always@(posedge CLK) begin
        if (FOOD_EATEN)
            if (xpixel >= 160)
                x <= 80;
            else if (xpixel <= 0)
                x <= 80;
            else
                x <= xpixel;
    end
    
    always@(posedge CLK) begin
        if (FOOD_EATEN)
            if (ypixel >= 120)
                y <= 60;
            else if (ypixel <= 0)
                y <= 60;
            else
                y <= ypixel;
    end
      
    assign TARGET_OUT = {x, y};
    
endmodule
