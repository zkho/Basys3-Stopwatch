`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// sw[9:8] is the mode, 00 from 00.00, 01 down from 99.99
//                      10 up from preset, 11 down from preset
//sw[7:4] = preset second tens, sw[3:0] = preset seconds ones
// start_stop = start/stop/resume
module stopwatch_top #(parameter TICK_MAX = 1_000_000, parameter RW = 18)(
input clk, start_stop, reset_btn,
input [9:0] sw,
output [6:0] sseg,
output dp,
output [3:0] an
);

wire tick;
wire ss_pulse;
wire load, count_en, at_end;
wire [15:0] bcd;

//reset button, needs synch
reg r1, r2;
always @(posedge clk) begin
    r1 <= reset_btn;
    r2 <= r1;
   end
wire rst = r2;

tick_gen #(.TICK_MAX(TICK_MAX)) u_tick (
    .clk(clk), .rst(rst), .tick(tick));
    
button_cond u_ss (.clk(clk), .rst(rst), .tick(tick), .btn(start_stop),
    .pulse(ss_pulse));
    
controller u_ctrl (.clk(clk), .rst(rst), .ss(ss_pulse), .tick(tick),
    .at_end(at_end), .load(load), .count_en(count_en));
    
datapath u_dp(.clk(clk), .load(load), .count_en(count_en),
    .mode(sw[9:8]), .preset(sw[7:0]), .bcd(bcd), .at_end(at_end));
    
display_mux #(.RW(RW)) u_disp (.clk(clk), .rst(rst), .bcd(bcd),
    .sseg(sseg), .an(an), .dp(dp));

endmodule
