module ALUDecoder (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7, Op5,
    output [2:0] ALUControl
);

    // ALU Decoder truth table.
    assign ALUControl = case (ALUOp)
        2'b00: ADD_FUNCT3
        2'b01: SUB_FUNCT3
        2'b10: case (funct3)
            3'b000: case ({Op5, funct7})
                2'b11: SUB_FUNCT3
                default: ADD_FUNCT3
            3'b010: SLT_FUNCT3
            3'b110: OR_FUNCT3
            3'b111: AND_FUNCT3
            default: ADD_FUNCT3
            endcase
        default: ADD_FUNCT3
        endcase
    endcase
endmodule

        