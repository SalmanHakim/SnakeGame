`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2019 13:23:55
// Design Name: 
// Module Name: DecodingWorld
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


module DecodingWorld(
    input [3:0] BIN_IN,
    input [1:0] SEG_IN,
    input DOT_IN,
    output reg [7:0] HEX_OUT,
    output reg [3:0] SEG_OUT
    );
    
    always@(SEG_IN) begin
    case(SEG_IN)
        2'b00 : SEG_OUT <= 4'b1110;
        2'b01 : SEG_OUT <= 4'b1101;
        2'b10 : SEG_OUT <= 4'b1011;
        2'b11 : SEG_OUT <= 4'b0111;
        default : SEG_OUT <= 4'b1111;
    endcase
    end
    
    always@(BIN_IN or DOT_IN) begin
    case(BIN_IN)
        4'h0 : HEX_OUT[6:0] <= 7'b1000000;
        4'h1 : HEX_OUT[6:0] <= 7'b1111001;
        4'h2 : HEX_OUT[6:0] <= 7'b0100100;
        4'h3 : HEX_OUT[6:0] <= 7'b0110000;
        
        4'h4 : HEX_OUT[6:0] <= 7'b0011001;
        4'h5 : HEX_OUT[6:0] <= 7'b0010010;
        4'h6 : HEX_OUT[6:0] <= 7'b0000010;
        4'h7 : HEX_OUT[6:0] <= 7'b1111000;
        
        4'h8 : HEX_OUT[6:0] <= 7'b0000000;
        4'h9 : HEX_OUT[6:0] <= 7'b0011000;
        4'hA : HEX_OUT[6:0] <= 7'b0001000;
        4'hB : HEX_OUT[6:0] <= 7'b0000011;
        
        4'hC : HEX_OUT[6:0] <= 7'b1000110;
        4'hD : HEX_OUT[6:0] <= 7'b0100001;
        4'hE : HEX_OUT[6:0] <= 7'b0000110;
        4'hF : HEX_OUT[6:0] <= 7'b0001110;
        
        default : HEX_OUT <= 7'b1111111;
    endcase
    
        HEX_OUT[7] <= DOT_IN;
    end
    
endmodule
