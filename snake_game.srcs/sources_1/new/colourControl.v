`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 00:00:43
// Design Name: 
// Module Name: colourControl
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


module colourControl(
    input CLK,
    input RESET,
    input [1:0] MSM_STATE,
    input [11:0] COLOUR_IN,
    input [9:0] addX,
    input [8:0] addY,
    output [11:0] COLOUR_OUT
    );
    
    reg [15:0] frameCount;
    reg [11:0] colour;
    
    always@(posedge CLK) begin
        if (addY == 479)
            frameCount <= frameCount + 1;
    end
    
    always@(MSM_STATE or COLOUR_IN or frameCount) begin
        case (MSM_STATE)
            
            2'b00   :                           //idle
                colour <= 12'b111100000000;
                
            2'b01   :                           //play
                colour <= COLOUR_IN;
            
            2'b10   :   begin                   //win
                if (addY > 240)begin
                    if (addX > 320)
                        colour <= frameCount[15:8] + addY[7:0] + addX[7:0] - 240 - 320;
                    else
                        colour <= frameCount[15:8] + addY[7:0] - addX[7:0] - 240 + 320;
                end
                else begin
                    if (addX > 320)
                        colour <= frameCount[15:8] - addY[7:0] + addX[7:0] + 240 - 320;
                    else
                        colour <= frameCount[15:8] - addY[7:0] - addX[7:0] + 240 + 320;
                end
            end
            
            2'b11   :                           //failed
                colour <= 12'b000000001111;
        endcase
    end
    
    assign COLOUR_OUT = colour;
    
endmodule
