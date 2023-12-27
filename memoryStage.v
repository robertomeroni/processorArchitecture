module memoryStage (
    input clk, rst,
    input [WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M,
    input [4:0] RdM,
    output [WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W,
    output [4:0] RdW,

    // Control ports.
    input RegWriteM, MemWriteM,
    input [1:0] ResultSrcM,
    output RegWriteW,
    output [1:0] ResultSrcW
    );

    // Internal wires and registers.
    wire [WORD_SIZE-1:0] ReadDataM;

    reg [WORD_SIZE-1:0] ALUResultM_reg, ReadDataM_reg, PCPlus4M_reg;
    reg [4:0] RdM_reg;

    // Control signals and registers.
    reg RegWriteM_reg;
    reg [1:0] ResultSrcM_reg;

    // Modules.
    dataMemory Data_Memory (
        .clk(clk),
        .rst(rst),
        .WE(MemWriteM),
        .WD(WriteDataM),
        .A(ALUResultM),
        .RD(ReadDataM)
    );

    // Behavior.
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            ALUResultM_reg <= 0;
            ReadDataM_reg <= 0;
            PCPlus4M_reg <= 0;
            RdM_reg <= 0;
            RegWriteM_reg <= 0;
            ResultSrcM_reg <= 0;
        end else begin
            ALUResultM_reg <= ALUResultM;
            ReadDataM_reg <= ReadDataM;
            PCPlus4M_reg <= PCPlus4M;
            RdM_reg <= RdM;
            RegWriteM_reg <= RegWriteM;
            ResultSrcM_reg <= ResultSrcM;
        end
    end

    // Outputs.
    assign ALUResultW = ALUResultM_reg;
    assign ReadDataW = ReadDataM_reg;
    assign PCPlus4W = PCPlus4M_reg;
    assign RdW = RdM_reg;
    assign RegWriteW = RegWriteM_reg;
    assign ResultSrcW = ResultSrcM_reg;
endmodule
    
