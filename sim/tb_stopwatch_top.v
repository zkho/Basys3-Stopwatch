`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//TICK_MAX = 10 (one 10ms tick every 10 clocks, 100ns
// RW = 4 means display digit changes every 4 clocks
// shorter testbench, to try other modes i can change
// the sw line; ex. for mode 1, use 10'b01_0000_0000
module tb_stopwatch_top;
reg clk = 0;
reg start_stop = 0;
reg reset_btn = 1;
reg [9:0] sw = 10'b00_0000_0000;
wire [6:0] sseg;
wire dp;
wire [3:0] an;

stopwatch_top #(.TICK_MAX(10), .RW(4)) dut(clk, start_stop, reset_btn,
sw, sseg, dp, an);

always #5 clk = ~clk;

initial begin
    #100 reset_btn = 0; //release reset
    #500 start_stop = 1; #600 start_stop = 0; //press start
    #5000 $display("running : %h", dut.bcd);
    start_stop = 1; #600 start_stop = 0; //press stop
    #1000 $display("stopped : %h", dut.bcd);
    #3000 $display("still : %h (same = paused)", dut.bcd);
    $finish;
  end

endmodule
