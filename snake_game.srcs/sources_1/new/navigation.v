`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2019 19:38:32
// Design Name: 
// Module Name: navigation
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


module navigation(
    input CLK,
    input RESET,
    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    output [2:0] STATE_OUT
    );
    
    reg [2:0] curr_state;
    reg [2:0] next_state;
    
    //sequential part
    always@(posedge CLK) begin
        if (RESET)
            curr_state <= 3'd0;
        else
            curr_state <= next_state;
    end
    
    //combinational part
    always@(BTNU or BTND or BTNL or BTNR or curr_state) begin
        case (curr_state)
            
            3'd0   :   begin
                if (BTNU || BTND || BTNR || BTNL)
                    next_state <= 3'd1;
                else
                    next_state <= curr_state;
            end
            
            
            3'd1   :   begin                   //right
                if (BTNU)
                    next_state <= 3'd2;
                else if (BTND)
                    next_state <= 3'd4;
                else
                    next_state <= curr_state;
            end
            
            3'd2   :   begin                   //up
                if (BTNR)
                    next_state <= 3'd1;
                else if (BTNL)
                    next_state <= 3'd3;
                else
                    next_state <= curr_state;
            end
            
            3'd3   :   begin                   //left
                if (BTNU)
                    next_state <= 3'd2;
                else if (BTND)
                    next_state <= 3'd4;
                else
                    next_state <= curr_state;
            end
            
            3'd4   :   begin                   //down
                if (BTNR)
                    next_state <= 3'd1;
                else if (BTNL)
                    next_state <= 3'd3;
                else
                    next_state <= curr_state;
            end
        endcase
    end
    
    assign STATE_OUT = curr_state;
endmodule
