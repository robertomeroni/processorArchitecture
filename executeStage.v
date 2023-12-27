`include "constants.v"

module executeStage (
    input clk, rst,
    input [WORD_SIZE-1:0] RD1E, RD2E, PCE,
    input [4:0] Rs1E, Rs2E, RDE,
    input [WORD_SIZE-1:0] ImmExtE, PCPlus4E,
    input [WORD_SIZE-1:0] ResultW,
    output [WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE,
    output [4:0] RdM,

    // Control ports.
    input RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE, AluSrcE, 
    input [1:0] ResultSrcE,
    input [2:0] ALUControlE,
    output RegWriteM, MemWriteM,
    output PCSrcE, 
    output [1:0] ResultSrcM
    );

    // Internal wires and registers.
    wire [WORD_SIZE-1:0] SrcAE, SrcBE, SrcBE_mux, ALUResultE;

    reg [WORD_SIZE-1:0] ALUResultE_reg, WriteDataE_reg, PCPlus4E_reg;
    reg [4:0] RdE_reg;

    // Control signals and registers.
    wire ZeroE;

    reg RegWriteE_reg, MemWriteE_reg;
    reg [1:0] ResultSrcE_reg;

    // Modules.
    // Mux 3 to 1 for source A.
    mux_3to1 SrcA_mux (
        .a(RD1E),
        .b(ResultW),
        .c(ALUResultM),
        .sel(ForwardAE),
        .out(SrcAE)
    );

    // Mux 3 to 1 for source B.
    mux_3to1 SrcB_mux (
        .a(RD2E),
        .b(ResultW),
        .c(ALUResultM),
        .sel(ForwardBE),
        .out(SrcBE_mux)
    );

    // Mux 2 to 1 for source B.
    mux_2to1 SrcB_mux2 (
        .a(SrcBE_mux),
        .b(ImmExtE),
        .sel(ALUSrcE),
        .out(SrcBE)
    );

    // Adder.
    adder Adder (
        .a(PCE),
        .b(ImmExtE),
        .out(PCTargetE)
    );

    // ALU.
    ALU ALU_Unit (
        .a(SrcAE),
        .b(SrcBE),
        .out(ALUResultE),
        .zero(ZeroE),
        .control(ALUControlE)
    );

    // Behavior.
    always @(posedge clk or negedge rst) begin
        if(rst) begin
            ALUResultE_reg <= 0;
            WriteDataE_reg <= 0;
            PCPlus4E_reg <= 0;
            RdE_reg <= 0;
            RegWriteE_reg <= 0;
            MemWriteE_reg <= 0;
            ResultSrcE_reg <= 0;
        end else begin
            ALUResultE_reg <= ALUResultE;
            WriteDataE_reg <= WriteDataE;
            PCPlus4E_reg <= PCPlus4E;
            RdE_reg <= RDE;
            RegWriteE_reg <= RegWriteE;
            MemWriteE_reg <= MemWriteE;
            ResultSrcE_reg <= ResultSrcE;
        end
    end

    // Outputs.
    assign ALUResultM = ALUResultE_reg;
    assign WriteDataM = WriteDataE_reg;
    assign RdM = RdE_reg;
    assign PCPlus4M = PCPlus4E_reg;
    assign RegWriteM = RegWriteE_reg;
    assign MemWriteM = MemWriteE_reg;
    assign ResultSrcM = ResultSrcE_reg;
    assign PCSrcE = (ZeroE & BranchE) | JumpE;
endmodule