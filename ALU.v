`include "constants.v"

module ALU (
   input clk,
   input rst,
   input [`WORD_SIZE-1:0] a,
   input [`WORD_SIZE-1:0] b,
   input [2:0] ALUControlE,
   output reg [`WORD_SIZE-1:0] out
);
   // TODO: add Zero flag

   always @(posedge clk or negedge rst) begin
      case (ALUControlE)
         `ADD_FUNCT3: out <= a + b;
         `SUB_FUNCT3: out <= a - b;
         `MUL_FUNCT3: out <= a * b;
         `AND_FUNCT3: out <= a & b;
         `OR_FUNCT3:  out <= a | b;
         default: out = '0;
      endcase
   end
endmodule

