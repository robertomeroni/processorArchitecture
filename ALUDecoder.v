`include "constants.v"

module ALUDecoder (
		   input [1:0] ALUOp,
		   input [2:0] funct3,
		   input funct7, Op5,
		   output reg [2:0] ALUControl
		   );

   always @(ALUOp, funct3, Op5, funct7) begin
      // ALU Decoder truth table.
    case (ALUOp)
        2'b00: ALUControl = `ADD_FUNCT3;
        2'b01: case (funct3)
		    3'b100: ALUControl = `SGT_FUNCT3;
		default: ALUControl = `SUB_FUNCT3;
	       endcase
        2'b10: case (funct3)
        3'b000: case ({Op5, funct7})
			  2'b11: ALUControl = `SUB_FUNCT3;
		default: ALUControl = `ADD_FUNCT3;
			 endcase
        3'b010: ALUControl = `SLT_FUNCT3;
        3'b110: ALUControl = `OR_FUNCT3;
        3'b111: ALUControl = `AND_FUNCT3;
		    3'b100: ALUControl = `MUL_FUNCT3;
		    3'b001: ALUControl = `SLL_FUNCT3;
        default: ALUControl = `ADD_FUNCT3;
        endcase
        default: ALUControl = `ADD_FUNCT3;
      endcase
   end
endmodule
