`include "constants.v"
`include "mux.v"
`include "programCounter.v"
`include "instructionMemory.v"
`include "PCAdder.v"

module fetchStage(clk, rst, InstrD, PCD, PCPlus4D, PCTargetE, PCSrcE);

    // Input and output ports.
    input clk, rst;
    input [WORD_SIZE-1:0] InstrD;
    input [WORD_SIZE-1:0] PCD;
    input [WORD_SIZE-1:0] PCPlus4D;
    output [WORD_SIZE-1:0] PCTargetE;
    output PCSrcE;

    // Internal signals.
    wire [WORD_SIZE-1:0] PCNext, PCF, PCPlus4F;
    wire [WORD_SIZE-1:0] InstrF;

    // Registers.
    reg [`WORD_SIZE-1:0] InstrF_reg;
    reg [`WORD_SIZE-1:0] PCF_reg, PCPlus4F_reg;

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
    PCAdder PC_Adder (
                    .a(PCF),
                    .b(32'h00000004),
                    .out(PCPlus4F)
                    );

    initial begin
        assign PCF <= `PC_INITIAL;
    end


    // Behavior.
    always @(posedge clk or negedge rst) begin
        if(rst) begin
            assign PCF <= `PC_INITIAL;
        end else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Trasmitting the values to the output ports.
    assign InstrD = (rst) ? 0 : InstrF_reg;
    assign PCD = (rst) ? 0 : PCF_reg;
    assign PCPlus4D = (rst) ? 0 : PCPlus4F_reg;

endmodule


