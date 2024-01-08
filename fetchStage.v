`include "constants.v"
`include "instructionMemory.v"
`include "programCounter.v"
`include "mux.v"
`include "adder.v"

module fetchStage(
    input clk,
    input rst,
    input PCSrcE,
    input [`WORD_SIZE-1:0] PCTargetE,
    output [`WORD_SIZE-1:0] InstrD,
    output [`WORD_SIZE-1:0] PCD,
    output [`WORD_SIZE-1:0] PCPlus4D
    );

    // Internal signals.
    wire [`WORD_SIZE-1:0] PCNext, PCF, PCPlus4F;
    wire [`WORD_SIZE-1:0] InstrF;

    // Registers.
    reg [`WORD_SIZE-1:0] InstrF_reg;
    reg [`WORD_SIZE-1:0] PCF_reg, PCPlus4F_reg;

    // Modules.
    // PC multiplexer.
    mux_2to1 PC_mux (.a(PCPlus4F),
                    .b(PCTargetE),
                    .sel(PCSrcE),
                    .out(PCNext)
                    );

    // PC.
    programCounter Program_Counter (
                    .clk(clk),
                    .rst(rst),
                    .PC(PCF),
                    .PCNext(PCNext)
                    );

    // Instruction memory.
    instructionMemory Instruction_Memory (
                    .rst(rst),
                    .PC(PCF),
                    .Instr(InstrF)
                    );

    // Go to next instruction.
    adder PC_Adder (
                    .a(PCF),
                    .b(32'h00000004),
                    .out(PCPlus4F)
                    );

    // Assigning initial PC value. 
    initial begin
        PCF_reg <= `PC_INITIAL;
    end

    // Behavior.
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            PCF_reg <= `PC_INITIAL;
            PCPlus4F_reg <= 0;
            InstrF_reg <= 0;
        end else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Trasmitting the values to the output ports.
    assign InstrD = InstrF_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;
endmodule


