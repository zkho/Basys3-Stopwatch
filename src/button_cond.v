`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  fixes bouncy asynch button to a clean pulse
// 2-flop synch (button async to clk)
// debouncing via looking at button 1x/10ms tick, only accept
// new level after on the same one for 2 samples in a row
// also, pulse=1 -> edge detection for 1 clock when it goes from 0to1
module button_cond(
    input clk, rst, tick, btn,
    output pulse //one clock wide 1x per press
    );
    reg s1, s2; //synchronizer
    reg prev; //prev 10ms sample
    reg stable; //debounced lvl
    reg stable_d; //stable delayed 1 clock for edge detection
    
    always @(posedge clk) begin
        if (rst) begin
            s1 <= 1'b0;
            s2 <= 1'b0;
            prev <= 1'b0;
            stable <= 1'b0;
            stable_d <= 1'b0;
         end
         else begin
            s1 <= btn;
            s2 <= s1;
            if (tick) begin
                prev <= s2;
                if (prev & s2)
                    stable <= 1'b1; //1,1 means pressed
                    else if (~prev & ~s2)
                        stable <= 1'b0; //0,0 means released
                end
                stable_d <= stable;
              end
            end
            
       assign pulse = stable & ~stable_d;
endmodule
