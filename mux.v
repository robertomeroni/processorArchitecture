`include "constants.v"

module mux_2to1(a, b, sel, out);

    input [`WORD_SIZE-1:0] a, b;
    input sel;
    output [`WORD_SIZE-1:0] out;

    case (sel)
        0: out = a;
        1: out = b;
    endcase
        
endmodule
