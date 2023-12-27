`include "constants.v"

module ALU (
    input [WORD_SIZE-1:0] srcAE,
    input [WORD_SIZE-1:0] srcBE,
    input [2:0] ALUControlE,
    output reg [WORD_SIZE-1:0] out
);

   always_comb begin
      case (ALUControlE)
        `ADD_OP: out = srcAE + srcBE;
        `SUB_OP: out = srcAE - srcBE;
        `MUL_OP: out = srcAE * srcBE;
        `AND_OP: out = srcAE & srcBE;
        `OR_OP:  out = srcAE | srcBE;
        default: out = '0;
      endcase
   end
endmodule


