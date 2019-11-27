`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2019 14:31:00
// Design Name: 
// Module Name: MSM
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


module MSM(
    input CLK,
    input RESET,
    input BTNU,
    input BTNR,
    input BTNL,
    input BTND,
    input [3:0] SCORE_IN,
    output [1:0] STATE_OUT
    );
    
    reg [1:0] curr_state;
    reg [1:0] next_state;
    
    //sequential part
    always@(posedge CLK) begin
        if (RESET)
            curr_state <= 2'b00;
        else
            curr_state <= next_state;
    end
    
    //combinational part
    always@(BTNU or BTND or BTNL or BTNR or curr_state or SCORE_IN) begin
        case (curr_state)
            
            2'b00   :   begin                       //idle
                if (BTNU || BTND || BTNR || BTNL)
                    next_state <= 2'b01;
                else
                    next_state <= curr_state;
            end
            
            2'b01   :   begin                       //play
                if (SCORE_IN == 4'd10)
                    next_state <= 2'b10;
                else
                    next_state <= curr_state;
            end
            
            2'b10   :                               //win
                next_state <= curr_state;
        endcase
    end
    
    assign STATE_OUT = curr_state;
endmodule
