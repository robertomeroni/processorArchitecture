`include "constants.v"

module PCAdder (a, b, out);

    input [`WORD_SIZE-1:0] a,b;
    output [`WORD_SIZE-1:0] out;

    assign out = a + b;
    
endmodule