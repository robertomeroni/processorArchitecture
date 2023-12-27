`include "constants.v"

module mux_2to1(
    input [`WORD_SIZE-1:0] a,
    input [`WORD_SIZE-1:0] b,
    input sel,
    output [`WORD_SIZE-1:0] out
    );

    case (sel)
        0: out = a;
        1: out = b;
    endcase
        
endmodule
