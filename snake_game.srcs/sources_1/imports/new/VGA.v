`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 23:18:46
// Design Name: 
// Module Name: VGA
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


module VGA(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [11:0] COLOUR_OUT,
    output reg VS,
    output reg HS,
    output reg [9:0] ADDX,
    output reg [8:0] ADDY
    );
    
        //vertical lines
    parameter VTimeToPulseWidthEnd  = 10'd2;
    parameter VTimeToBackPorchEnd   = 10'd31;
    parameter VTimeToDisplayTimeEnd = 10'd511;
    parameter VTImeToFrontPorchEnd  = 10'd521;
    
    //horizontal lines
    parameter HTimeToPulseWidthEnd  = 10'd96;
    parameter HTimeToBackPorchEnd   = 10'd144;
    parameter HTimeToDisplayTimeEnd = 10'd784;
    parameter HTimeToFrontPorchEnd  = 10'd800;
    
    wire trig799;
    wire clock25;
    wire [9:0] addx;
    wire [9:0] addy;
    
    //25Mhz down clock   
    generic_counter # (.width(2),
                       .max(3))
                       down25 (
                            .CLK(CLK),
                            .RESET(1'b0),
                            .ENABLE(1'b1),
                            .TRIG_OUT(clock25));
    
    //799 counter
    generic_counter # (.width(10),
                       .max(HTimeToFrontPorchEnd - 1))
                       horz (
                            .CLK(clock25),
                            .RESET(1'b0),
                            .ENABLE(1'b1),
                            .TRIG_OUT(trig799),
                            .COUNT(addx));
    
   //520 counter
   generic_counter # (.width(10),
                      .max(VTImeToFrontPorchEnd - 1))
                      vert (
                            .CLK(trig799),
                            .RESET(1'b0),
                            .ENABLE(1'b1),
                            .COUNT(addy));
                            
    always@(posedge CLK) begin
        if ((addx < HTimeToDisplayTimeEnd) && 
            (addx > HTimeToBackPorchEnd) &&
            (addy < VTimeToDisplayTimeEnd) &&
            (addy > VTimeToBackPorchEnd)) begin
            ADDY <= addy - VTimeToBackPorchEnd;
            ADDX <= addx - HTimeToBackPorchEnd;
        end
        else begin
            ADDY <= 0;
            ADDX <= 0;
        end
    end
           
    always@(posedge CLK) begin
        if (addx <= HTimeToPulseWidthEnd)
            HS <= 0;
        else 
            HS <= 1;
    end
    
    always@(posedge CLK) begin
        if (addy <= VTimeToPulseWidthEnd)
            VS <= 0;
        else
            VS <= 1;
    end
    
    always@(posedge CLK) begin
        if ((addx < HTimeToDisplayTimeEnd) && 
            (addx > HTimeToBackPorchEnd) &&
            (addy < VTimeToDisplayTimeEnd) &&
            (addy > VTimeToBackPorchEnd))
            COLOUR_OUT <= COLOUR_IN;
        else
            COLOUR_OUT <= 0;
    end
    
endmodule