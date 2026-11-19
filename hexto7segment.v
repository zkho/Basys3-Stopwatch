`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 4bit value to 7 segments (active low)
// sseg={a,b,c,d,e,f,g}, 0 = segment lit
module hexto7segment(
    input [3:0] x,
    output reg [6:0] sseg
    );
    
    always @(*) begin
        case(x)
            4'h0: sseg = 7'b0000001;
            4'h1: sseg = 7'b1001111;
            4'h2: sseg = 7'b0010010;
            4'h3: sseg = 7'b0000110;
            4'h4: sseg = 7'b1001100;
            4'h5: sseg = 7'b0100100;
            4'h6: sseg = 7'b0100000;
            4'h7: sseg = 7'b0001111;
            4'h8: sseg = 7'b0000000;
            4'h9: sseg = 7'b0000100;
            4'hA: sseg = 7'b0001000;
            4'hB: sseg = 7'b1100000;
            4'hC: sseg = 7'b0110001;
            4'hD: sseg = 7'b1000010;
            4'hE: sseg = 7'b0110000;
            4'hF: sseg = 7'b0111000;
            default: sseg = 7'b1111111;
        endcase
      end
endmodule
