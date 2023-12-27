`include "constants.v"

module ALU (
    input [WORD_SIZE-1:0] a,
    input [WORD_SIZE-1:0] b,
    input [2:0] control,
    output reg [WORD_SIZE-1:0] out
);
// TODO: add Zero flag

   always_comb begin
      case (control)
        `ADD_OP: out = a + b;
        `SUB_OP: out = a - b;
        `MUL_OP: out = a * b;
        `AND_OP: out = a & b;
        `OR_OP:  out = a | b;
        default: out = '0;
      endcase
   end
endmodule


