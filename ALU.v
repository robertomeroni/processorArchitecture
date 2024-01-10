`include "constants.v"

module ALU (
	    input clk,
	    input rst,
	    input [`WORD_SIZE-1:0] a,
	    input [`WORD_SIZE-1:0] b,
	    input [2:0] ALUControlE,
	    output reg [`WORD_SIZE-1:0] out,
	    output reg zeroE
	    );
   
   reg   [`WORD_SIZE-1:0] F0, F1, F2, F3;

   always @(posedge clk or posedge rst) begin
      case (ALUControlE)
        `ADD_FUNCT3: out = a + b;
        `SUB_FUNCT3: out = a - b;
        `AND_FUNCT3: out = a & b;
        `OR_FUNCT3:  out = a | b;
	`MUL_FUNCT3: begin
	   F0 <= a * b;
	   F1 <= F0;
	   F2 <= F1;
	   F3 <= F2;
	   out <= F3;
	end
      endcase // case (ALUControlE)
      if (out==32'b00000000000000000000000000000000) begin
	 zeroE = 1;
      end else begin
	 zeroE = 0;
      end
   end 
endmodule

