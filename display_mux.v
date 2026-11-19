`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// time-multiplexes the 4 Basys3 display digits
// free running counter's top 2 bits pick which digit's on
// RW=18--> each digit's on for 2^16 clocks
// whole refresh=~380Hz(no visible flicker)
module display_mux #(parameter RW=18) (
    input clk, rst,
    input [15:0] bcd, //{d3,d2,d1,d0}
    output [6:0] sseg, //{a,b,c,d,e,f,g} active low
    output reg [3:0] an, //digit enables active low
    output dp //decimal point active low
    );
    
    reg [RW-1:0] refresh;
    wire [1:0] sel = refresh[RW-1:RW-2];
    reg [3:0] digit;
    
    always @(posedge clk) begin
        if (rst) refresh <= {RW{1'b0}};
        else refresh <= refresh + 1'b1;
       end
       
    //put mux to pick digit AND enable only its anode
    always @(*) begin
        case(sel)
            2'b00: begin digit = bcd[3:0]; an=4'b1110; end // rightmost
            2'b01: begin digit = bcd[7:4]; an=4'b1101; end
            2'b10: begin digit = bcd[11:8]; an=4'b1011; end
            default: begin digit = bcd[15:12]; an=4'b0111; end //leftmost
        endcase
      end
      
     hexto7segment dec(.x(digit), .sseg(sseg));
     assign dp = (sel==2'b10) ? 1'b0 : 1'b1; //lit only with digit 2
    
endmodule
