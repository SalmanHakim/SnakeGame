`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2019 18:17:17
// Design Name: 
// Module Name: generic_counter
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


module generic_counter(
        CLK,
        RESET,
        ENABLE,
        TRIG_OUT,
        COUNT
    );
    
    parameter width = 4;
    parameter max   = 9;
    
    input   CLK;
    input   RESET;
    input   ENABLE;
    output  TRIG_OUT;
    output [width-1:0]  COUNT;
    
    reg [width-1:0] count_value = 0;
    reg trigger_out = 0;
    
    always@(posedge CLK) begin
        if (RESET)
            count_value <= 0;
        else begin
            if (ENABLE) begin
                if (count_value == max)
                    count_value <= 0;
                else
                    count_value <= count_value + 1;
            end
        end
    end
    
    always@(posedge CLK) begin
        if (RESET)
            trigger_out <= 0;
        else begin
            if (ENABLE && (count_value == max))
                trigger_out <= 1;
            else 
                trigger_out <= 0;
        end
    end
    
    assign TRIG_OUT = trigger_out;
    assign COUNT    = count_value;
    
endmodule
