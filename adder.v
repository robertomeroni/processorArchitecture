`include "constants.v"

module adder (
    input [`WORD_SIZE-1:0] a,
    input [`WORD_SIZE-1:0] b,
    output [`WORD_SIZE-1:0] out
    );

    assign out = a + b;   
endmodule