`include "constants.v"

module ALU (
	    input clk,
	    input rst,
	    input [`WORD_SIZE-1:0] a,
	    input [`WORD_SIZE-1:0] b,
	    input [2:0] ALUControlE,
	    output [`WORD_SIZE-1:0] out,
	    output zeroE
	    );
   
   reg   [`WORD_SIZE-1:0] F0, F1, F2, F3;

   always @ ( posedge clk ) begin
      if (ALUControlE == `MUL_FUNCT3) begin
	 F0 <= a * b;
	 F1 <= F0;
	 F2 <= F1;
	 F3 <= F2;
      end
   end

   
   assign out = (ALUControlE == `ADD_FUNCT3) ? a + b :
		(ALUControlE == `SUB_FUNCT3) ? a - b :
		(ALUControlE == `AND_FUNCT3) ? a & b :
		(ALUControlE == `OR_FUNCT3)  ? a | b :
		(ALUControlE == `SLT_FUNCT3) ? a < b :
		(ALUControlE == `SLL_FUNCT3) ? a << b :
		(ALUControlE == `SGT_FUNCT3) ? a > b :
		(ALUControlE == `MUL_FUNCT3) ? F3 : {32{1'b0}};

   assign zeroE = (out == {32{1'b0}}) ? 1'b1 : 1'b0;
endmodule

