module decodeStage (
    input clk, rst,
    input [WORD_SIZE-1:0] InstrD, PCD, PCPlus4D, ResultW,
    input RegWriteW,
    input [4:0] RdW,

    output [WORD_SIZE-1:0] RD1E, RD2E, PCE,
    output [4:0] Rs1E, Rs2E, RdE,
    output [WORD_SIZE-1:0] ImmExtE, PCPlus4E,

    // Control Unit ports.
    output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
    output [1:0] ResultSrcE,
    output [2:0] ALUControlE
    );

    // Internal wires and registers.
    wire [WORD_SIZE-1:0] RD1, RD2;
    wire [WORD_SIZE-1:0] ImmExtD;

    reg [WORD_SIZE-1:0] RD1D_reg, RD2D_reg;
    reg [WORD_SIZE-1:0] PCD_reg, PCPlus4D_reg;
    reg [4:0] Rs1D_reg, Rs2D_reg, RdD_reg;
    reg [WORD_SIZE-1:0] ImmExtD_reg;

    // Control Unit signals and registers.
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD; 

    reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg;
    reg [1:0] ResultSrcD_reg;
    reg [2:0] ALUControlD_reg;


    // Modules.
    // Register File.
    registerFile Register_File (
        .clk(clk),
        .rst(rst),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RdW),
        .RD1(RD1),
        .RD2(RD2),
        .WE3(RegWriteW),
        .WD3(ResultW)
    );

    // Sign Extension.
    extender Extender(
        .inp(InstrD[31:7]),
        .out(ImmExtD),
        .ImmSrc(ImmSrcD)
    );
    
    // Control Unit.
    controlUnit Control_Unit (
        .Op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[30]),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD),
        .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .ALUControl(ALUControlD)
        );

    // Behavior.
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            RD1D_reg <= 0;
            RD2D_reg <= 0;
            PCD_reg <= 0;
            PCPlus4D_reg <= 0;
            Rs1D_reg <= 0;
            Rs2D_reg <= 0;
            RdD_reg <= 0;
            ImmExtD_reg <= 0;
            RegWriteD_reg <= 0;
            MemWriteD_reg <= 0;
            JumpD_reg <= 0;
            BranchD_reg <= 0;
            ALUSrcD_reg <= 0;
            ResultSrcD_reg <= 0;
            ALUControlD_reg <= 0;
        end else begin
            RD1D_reg <= RD1;
            RD2D_reg <= RD2;
            PCD_reg <= PCD;
            PCPlus4D_reg <= PCPlus4D;
            Rs1D_reg <= InstrD[19:15];
            Rs2D_reg <= InstrD[24:20];
            RdD_reg <= RdW;
            ImmExtD_reg <= ImmExtD;
            RegWriteD_reg <= RegWriteD;
            MemWriteD_reg <= MemWriteD;
            JumpD_reg <= JumpD;
            BranchD_reg <= BranchD;
            ALUSrcD_reg <= ALUSrcD;
            ResultSrcD_reg <= ResultSrcD;
            ALUControlD_reg <= ALUControlD;
        end
    end

    // Outputs.
    assign RD1E = RD1D_reg;
    assign RD2E = RD2D_reg;
    assign PCE = PCD_reg;
    assign PCPlus4E = PCPlus4D_reg;
    assign Rs1E = Rs1D_reg;
    assign Rs2E = Rs2D_reg;
    assign RdE = RdD_reg;
    assign ImmExtE = ImmExtD_reg;
    assign RegWriteE = RegWriteD_reg;
    assign MemWriteE = MemWriteD_reg;
    assign JumpE = JumpD_reg;
    assign BranchE = BranchD_reg;
    assign ALUSrcE = ALUSrcD_reg;
    assign ResultSrcE = ResultSrcD_reg;
    assign ALUControlE = ALUControlD_reg;
endmodule

