`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 4 BCD digits, up/down counting, init-value mux
// bcd = {d3, d2, d1, d0} = {sec tens, sec ones, 10ms tens, 10ms ones}
// mode[1]:0 means fixed start value, 1 means load from switches
// mode[0]:0 means count up, 1 means count down

module datapath(
    input clk, load, count_en,
    input [1:0] mode, //sw[9:8]
    input [7:0] preset, //sw[7:0] {seconds tens, seconds ones}
    output [15:0] bcd, // to display
    output at_end //to controlla
    );
    wire down = mode[0];
    
    //initial value mux code:
    reg [15:0] init_val;
    always @(*) begin
        case(mode)
            2'b00: init_val = 16'h0000; //mode0, 00.00
            2'b01: init_val = 16'h9999; //mode1, 99.99
            default: init_val = {preset, 8'h00}; //mode2,3: SS.00
        endcase
      end
      
    //4 BCD digit registers
    reg [3:0] d3, d2, d1, d0;
    assign bcd = {d3, d2, d1, d0}; 
    
    //up (carry) / down (borrow) chain
    wire c1 = (d0 == 4'd9);
    wire b1 = (d0 == 4'd0);
    
    wire c2 = c1 && (d1 == 4'd9);
    wire b2 = b1 && (d1 == 4'd0);
    
    wire c3 = c2 && (d2 == 4'd9);
    wire b3 = b2 && (d2 == 4'd0);
    
    //comparator to see if at end value
    
    assign at_end = down ? (bcd == 16'h0000) : (bcd == 16'h9999);
    
    always @(posedge clk) begin
        if (load) begin
            {d3, d2, d1, d0} <= init_val;
        end
        else if (count_en) begin
            if (!down) begin //count-up
                d0 <= c1 ? 4'd0 : d0 + 1'b1;
                if (c1) d1 <= (d1 == 4'd9) ? 4'd0 : d1 + 1'b1;
                if (c2) d2 <= (d2 == 4'd9) ? 4'd0 : d2 + 1'b1;
                if (c3) d3 <= (d3 == 4'd9) ? 4'd0 : d3 + 1'b1;
            end
            else begin
                d0 <= b1 ? 4'd9 : d0 - 1'b1;
                if (b1) d1 <= (d1 == 4'd0) ? 4'd9 : d1 - 1'b1;
                if (b2) d2 <= (d2 == 4'd0) ? 4'd9 : d2 - 1'b1;
                if (b3) d3 <= (d3 == 4'd0) ? 4'd9 : d3 - 1'b1;
               end
             end
           end
    
endmodule
