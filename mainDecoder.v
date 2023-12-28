module mainDecoder (
        input [6:0] Op,
        output Branch, Jump, MemWrite, ALUSrc, RegWrite, 
        output Op5,   
        output [1:0] ResultSrc, ImmSrc, ALUOp
    );

    // Main Decoder truth table.
    assign RegWrite = case (Op)
        LOAD_FUNCT7: 1'b1;
        RTYPE_FUNCT7: 1'b1;
        ITYPE_FUNCT7: 1'b1;
        JAL_FUNCT7: 1'b1;
        default: 1'b0;
    endcase

    assign ImmSrc = case (Op)
        STORE_FUNCT7: 2'b01;
        BEQ_FUNCT7: 2'b10;
        JAL_FUNCT7: 2'b11;
        default: 2'b00;
    endcase

    assign ALUSrc = case (Op)
        LOAD_FUNCT7: 1'b1;
        STORE_FUNCT7: 1'b1;
        ITYPE_FUNCT7: 1'b1;
        default: 1'b0;
    endcase

    assign MemWrite = case (Op)
        STORE_FUNCT7: 1'b1;
        default: 1'b0;
    endcase

    assign ResultSrc = case (Op)
        LOAD_FUNCT7: 2'b01;
        JAL_FUNCT7: 2'b10;
        default: 2'b00;
    endcase

    assign Branch = case (Op)
        BEQ_FUNCT7: 1'b1;
        default: 1'b0;
    endcase

    assign ALUOp = case (Op)
        RTYPE_FUNCT7: 2'b10;
        BEQ_FUNCT7: 2'b01;
        ITYPE_FUNCT7: 2'b10;
        default: 2'b00;
    endcase

    assign Jump = case (Op)
        JAL_FUNCT7: 1'b1;
        default: 1'b0;
    endcase
endmodule