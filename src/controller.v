`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// fsm half of the processor
// IDLE shows initial value, RUN waits for 10ms tick,
// STEP counts 1 step (up/down) then goes back to RUN
// PAUSE freezes it, DONE means you hit 99.99(up) or 00.00(down)
// once u hit a goal, stay frozen until reset

module controller(
    input clk, rst, ss, tick, at_end, //ss is start/stop pulse, tick is 10ms strobe
    output reg load, //Time := init value
    output reg count_en //Time := Time +/- 1
    );
    
    localparam IDLE=3'd0, RUN=3'd1, STEP=3'd2, PAUSE=3'd3, DONE=3'd4;
    reg [2:0] state, next_state;
    
    //state register code
    always @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
       end
       
    //next-state logic
    always @(*) begin
        next_state = state; //by default u stay
        case(state)
            IDLE: if (ss) next_state = RUN;
            RUN: if (ss) next_state = PAUSE;
                  else if (tick && at_end) next_state = DONE;
                  else if (tick) next_state = STEP;
            STEP: if (ss) next_state = PAUSE;
                   else next_state = RUN;
            PAUSE: if (ss) next_state = RUN;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
      end
     
     //output logic (moore)
     always @(*) begin
        load = 1'b0; // defaults -> no latches
        count_en = 1'b0;
        case (state)
            IDLE: load = 1'b1;
            STEP: count_en = 1'b1;
            default: ;
        endcase
       end  
            
endmodule
