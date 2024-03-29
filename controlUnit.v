`include "constants.v"
`include "ALUDecoder.v"
`include "mainDecoder.v"

module controlUnit (
		    input [6:0] Op,
		    input [2:0] funct3,
		    input funct7,
		    output RegWrite, MemWrite, Jump, Branch, ALUSrc,
		    output [1:0] ResultSrc, ImmSrc,
		    output [2:0] ALUControl,
		    output Op5,
		    output ByteAddress,
		    output ReadEnable
		    );

   // Wires.
   wire [1:0] ALUOp;

   // Modules.
   mainDecoder Main_Decoder (
			     .Op(Op),
			     .Branch(Branch),
			     .Jump(Jump),
			     .MemWrite(MemWrite),
			     .ALUSrc(ALUSrc),
			     .RegWrite(RegWrite),
			     .ResultSrc(ResultSrc),
			     .ImmSrc(ImmSrc),
			     .ALUOp(ALUOp),
			     .Op5(Op5),
			     .ReadEnable(ReadEnable)
			     );

   ALUDecoder ALU_Decoder (
			   .ALUOp(ALUOp),
			   .funct3(funct3),
			   .funct7(funct7),
			   .Op5(Op[5]),
			   .ALUControl(ALUControl)
			   );

   assign ByteAddress = (((Op == `LOAD_FUNCT7) | (Op == `STORE_FUNCT7)) & (funct3 == 3'b000)) ? 1'b1 : 1'b0;
		     
endmodule



