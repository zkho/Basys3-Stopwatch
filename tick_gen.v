`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// makes one-clock-wide tick pulse every 10ms
//100MHz clock means 10 ms = 1000000 clock cycles
module tick_gen #(parameter TICK_MAX = 1_000_000) (
    input clk,
    input rst, //synch rst (level)
    output reg tick //1 per clock every TICK_MAX clocks
    );
    reg [19:0] cnt; //2^20 since no other min. > # than 1000000 if 2^x
    
    always @(posedge clk) begin
        if (rst) begin
            cnt <= 20'd0;
            tick <= 1'b0;
        end
        else if (cnt == TICK_MAX - 1) begin
            cnt <= 20'd0;
            tick <= 1'b1;
        end
        else begin
            cnt <= cnt + 1'b1;
            tick <= 1'b0;
          end
        end
   
endmodule
