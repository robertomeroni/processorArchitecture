`include "constants.v"

module mainDecoder (
		    input [6:0] Op,
		    output reg Branch, Jump, MemWrite, ALUSrc, RegWrite, ReadEnable,
		    output Op5,   
		    output reg [1:0] ResultSrc, ImmSrc, ALUOp
		    );

   assign Op5 = Op[5];

   // Main Decoder truth table.
   always @(Op) begin
      case (Op)
        `LOAD_FUNCT7: RegWrite = 1'b1;
        `RTYPE_FUNCT7: RegWrite = 1'b1;
        `ITYPE_FUNCT7: RegWrite = 1'b1;
        `JAL_FUNCT7: RegWrite = 1'b1;
        default: RegWrite = 1'b0;
      endcase

      case (Op)
        `STORE_FUNCT7: ImmSrc = 2'b01;
        `BEQ_FUNCT7: ImmSrc = 2'b10;
        `JAL_FUNCT7: ImmSrc = 2'b11;
        default: ImmSrc = 2'b00;
      endcase

      case (Op)
        `LOAD_FUNCT7: ALUSrc = 1'b1;
        `STORE_FUNCT7: ALUSrc = 1'b1;
        `ITYPE_FUNCT7: ALUSrc = 1'b1;
        default: ALUSrc = 1'b0;
      endcase

      case (Op)
        `STORE_FUNCT7: MemWrite = 1'b1;
        default: MemWrite = 1'b0;
      endcase

      case (Op)
        `LOAD_FUNCT7: ResultSrc = 2'b01;
        `JAL_FUNCT7: ResultSrc = 2'b10;
        default: ResultSrc = 2'b00;
      endcase

      case (Op)
        `BEQ_FUNCT7: Branch = 1'b1;
        default: Branch = 1'b0;
      endcase

      case (Op)
        `RTYPE_FUNCT7: ALUOp = 2'b10;
        `BEQ_FUNCT7: ALUOp = 2'b01;
        `ITYPE_FUNCT7: ALUOp = 2'b10;
        default: ALUOp = 2'b00;
      endcase

      case (Op)
        `JAL_FUNCT7: Jump = 1'b1;
        default: Jump = 1'b0;
      endcase // case (Op)

      case (Op) 
	`LOAD_FUNCT7: ReadEnable = 1'b1;
	default: ReadEnable = 1'b0;
      endcase	  
   end

endmodule
