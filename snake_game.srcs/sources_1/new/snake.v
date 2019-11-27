`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 22:40:47
// Design Name: 
// Module Name: snake
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


module snake(
    input CLK,
    input RESET,
    input [1:0] MSM_STATE,
    input [2:0] NAVI_STATE,
    input [9:0] ADDX,
    input [8:0] ADDY,
    input [14:0] TARGET_IN,
    input [3:0] SCORE_IN,
    output [11:0] COLOUR_OUT,
    output TRIGGER
    );
    
    parameter maxX = 159;
    parameter maxY = 119;
    parameter length = 30;
    parameter speed = 30000000;
    
    parameter RED = 12'b000000001111;
    parameter BLUE = 12'b111100000000;
    parameter YELLOW = 12'b000011111111;
    parameter GREY = 12'b001100110011;
    
    reg [7:0] Xsnake [0:length - 1];
    reg [7:0] Ysnake [0:length - 1];
    reg trig;
    
    integer i, j, k;
    
    reg [11:0] colour;
    reg [25:0] count = 0;
    
    reg snakehead, snakebody, food;
                            
    always@(posedge CLK) begin
        if (RESET)
            count <= 0;
        else begin
            if (MSM_STATE == 2'b01) begin
                if (count >= speed)
                    count <= 0;
                else
                    count <= count + 6 + SCORE_IN;
            end
        end
    end
    
    //position shift
    genvar reps;
    generate
        for (reps = 0; reps < length - 1; reps = reps + 1)
        begin : SHIFT
            always@(posedge CLK) begin
                if (RESET) begin
                    Xsnake[reps+1] <= 80;
                    Ysnake[reps+1] <= 100;
                end
                
                else if (count == 0) begin
                    Xsnake[reps+1] <= Xsnake[reps];
                    Ysnake[reps+1] <= Ysnake[reps];
                end
            end
        end
    endgenerate
    
    always@(posedge CLK) begin
        if (RESET) begin                //initilisation of snake
            Xsnake[0] <= 80;
            Ysnake[0] <= 100;
        end
       
        else if (count == 0) begin
            case (NAVI_STATE)           //movement
                3'd1   :   begin                        //right
                    if (Xsnake[0] == maxX)     
                        Xsnake[0] <= 1;
                    else
                        Xsnake[0] <= (Xsnake[0] + 1);
                end
                
                3'd2   :   begin                        //up
                    if (Ysnake[0] == 1)
                        Ysnake[0] <= maxY;
                    else
                        Ysnake[0] <= (Ysnake[0] - 1);
                end
                3'd3   :   begin                        //left
                    if (Xsnake[0] == 1)
                        Xsnake[0] <= maxX;
                    else
                        Xsnake[0] <= (Xsnake[0] - 1);
                end
                
                3'd4   :   begin                        //down
                    if (Ysnake[0] == maxY)
                        Ysnake[0] <= 1;
                    else
                        Ysnake[0] <= (Ysnake[0] + 1);
                end
            endcase
        end
    end
    
    always@(posedge CLK) begin                  //snake head
        snakehead <= ((Xsnake[0] == (ADDX/4)) && (Ysnake[0] == (ADDY/4)));
    end
    
    always@(posedge CLK) begin                  //snake body
        snakebody = 0;
        for(k = 1; k <= SCORE_IN; k = k + 1) begin
            if (snakebody == 0)
                snakebody = ((Xsnake[k] == (ADDX/4)) && (Ysnake[k] == (ADDY/4)));
        end 
    end
    
    always@(posedge CLK) begin                  //food
        food <= ((TARGET_IN[14:7] == (ADDX/4)) && (TARGET_IN[6:0] == (ADDY/4)));
    end
        
    always@(posedge CLK) begin                  //collision trigger
        if (((TARGET_IN[14:7]) == (Xsnake[0])) && ((TARGET_IN[6:0]) == (Ysnake[0])))
            trig = 1;
        else
            trig = 0;
    end
    
    always@(posedge CLK) begin                  //colour set
        if (snakehead)
            colour <= GREY;
        
        else if (snakebody)
            colour <= YELLOW;
                
        else if (food)
            colour <= RED;
                
        else
            colour <= BLUE;
    end
    
    assign COLOUR_OUT = colour;
    assign TRIGGER = trig;
        
endmodule
