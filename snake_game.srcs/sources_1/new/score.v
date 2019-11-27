`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 18:06:22
// Design Name: 
// Module Name: score
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


module score(
    input CLK,
    input RESET,
    input TRIGGER,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT,
    output [3:0] SCORE_OUT
    );
    
    wire trig17, trig0, trig1, trig2, trig_c;
    wire [1:0] strobe_c;
    
    wire [3:0] seg_0;
    wire [3:0] seg_1;
    wire [3:0] seg_2;
    wire [3:0] seg_3;
    
    wire [4:0] decAndDot0;
    wire [4:0] decAndDot1;
    wire [4:0] decAndDot2;
    wire [4:0] decAndDot3;
    
    wire [4:0] mux_out;
    
    //17-bit counter
    generic_counter # (.width(17),
                       .max(99999))
                       bit17 (
                            .CLK(CLK),
                            .RESET(1'b0),
                            .ENABLE(1'b1),
                            .TRIG_OUT(trig17));
    
    //strobe counter                        
    generic_counter # (.width(2),
                       .max(2'b11))
                       strobe (
                            .CLK(CLK),
                            .RESET(1'b0),
                            .ENABLE(trig17),
                            .COUNT(strobe_c));   
    
    //trigger for score                        
    generic_counter # (.width(2),
                       .max(1))
                       trigg (
                            .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE(TRIGGER),
                            .TRIG_OUT(trig_c));
                            
    //score                        
    generic_counter # (.width(4),
                       .max(9))
                       seg0 (
                            .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE(trig_c),
                            .TRIG_OUT(trig0),
                            .COUNT(seg_0));
                            
    generic_counter # (.width(4),
                       .max(9))
                       seg1 (
                            .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE(trig0),
                            .TRIG_OUT(trig1),
                            .COUNT(seg_1));
                            
    generic_counter # (.width(4),
                       .max(9))
                       seg2 (
                            .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE(trig1),
                            .TRIG_OUT(trig2),
                            .COUNT(seg_2));

    generic_counter # (.width(4),
                       .max(9))
                       seg3 (
                            .CLK(CLK),
                            .RESET(RESET),
                            .ENABLE(trig2),
                            .COUNT(seg_3));

    assign decAndDot0 = {1'b1, seg_0};
    assign decAndDot1 = {1'b1, seg_1};
    assign decAndDot2 = {1'b1, seg_2};
    assign decAndDot3 = {1'b1, seg_3};
    
    //calculate score
    assign SCORE_OUT = seg_0 + (seg_1*10) + (seg_2*100) + (seg_3 *1000);

    multiplexer mux (
        .CONTROL(strobe_c),
        .IN0(decAndDot0),
        .IN1(decAndDot1),
        .IN2(decAndDot2),
        .IN3(decAndDot3),
        .OUT(mux_out));
                                     
    DecodingWorld seg7 (
        .BIN_IN(mux_out[3:0]),
        .SEG_IN(strobe_c),
        .DOT_IN(mux_out[4]),
        .HEX_OUT(HEX_OUT),
        .SEG_OUT(SEG_SELECT)
        );
    
endmodule
