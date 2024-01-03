`include "constants.v"
`include "flipFlop.v"

module ALU (
	    input clk,
	    input rst,
	    input [`WORD_SIZE-1:0] a,
	    input [`WORD_SIZE-1:0] b,
	    input [2:0] ALUControlE,
	    output reg [`WORD_SIZE-1:0] out
	    );
   // TODO: add Zero flag
   
   reg [`WORD_SIZE-1:0] inputToF0;
   wire [`WORD_SIZE-1:0] F0toF1;
   wire [`WORD_SIZE-1:0] F1toF2;
   wire [`WORD_SIZE-1:0] F2toOutput;

   DFlipFlop f0 (.in(inputToF0), .clk(clk), .out(F0toF1));
   DFlipFlop f1 (.in(F0toF1), .clk(clk), .out(F1toF2));
   DFlipFlop f2 (.in(F1toF2), .clk(clk), .out(F2toOutput));

   always @(posedge clk or posedge rst) begin
      case (ALUControlE)
        `ADD_FUNCT3: out <= a + b;
        `SUB_FUNCT3: out <= a - b;
        `AND_FUNCT3: out <= a & b;
        `OR_FUNCT3:  out <= a | b;
	`MUL_FUNCT3: begin
	   inputToF0 <= a * b;
	   out <= F2toOutput;
	end
      endcase // case (ALUControlE)
   end 
endmodule

