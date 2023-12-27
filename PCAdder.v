`include "constants.v"

module PCAdder (
    input [`WORD_SIZE-1:0] a,
    input [`WORD_SIZE-1:0] b,
    output [`WORD_SIZE-1:0] out
    );

    assign out = a + b;
    
endmodule