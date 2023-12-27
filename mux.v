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

module mux_3to1(
    input [`WORD_SIZE-1:0] a,
    input [`WORD_SIZE-1:0] b,
    input [`WORD_SIZE-1:0] c,
    input [1:0] sel,
    output [`WORD_SIZE-1:0] out
    );

    case (sel)
        0: out = a;
        1: out = b;
        2: out = c;
    endcase
endmodule