`include "constants.v"
`include "controlUnit.v"
`include "extender.v"
`include "registerFile.v"

module decodeStage
  (
   input clk, rst,
   input [`WORD_SIZE-1:0] InstrD, PCD, PCPlus4D, ResultW,
   input RegWriteW,
   input [4:0] RdW,

   // hazard input
   input  FlushE,
   input  StallE,
   input TakingBranch,

   output [`WORD_SIZE-1:0] RD1E, RD2E, PCE,
   output [4:0] Rs1E, Rs2E, RdE,
   output [`WORD_SIZE-1:0] ImmExtE, PCPlus4E,

   // Control Unit ports.
   output RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
   output [1:0] ResultSrcE,
   output [2:0] ALUControlE,
   output TakingBranchE,

   output ByteAddressE, ReadEnableE,
   
// hazard outputs
   output [4:0] Rs1DH, Rs2DH
   );

   // Internal wires and registers.
   wire [`WORD_SIZE-1:0] RD1, RD2;
   wire [`WORD_SIZE-1:0] ImmExtD;

   reg [`WORD_SIZE-1:0] RD1D_reg, RD2D_reg;
   reg [`WORD_SIZE-1:0] PCD_reg, PCPlus4D_reg;
   reg [4:0] Rs1D_reg, Rs2D_reg, RdD_reg;
   reg [`WORD_SIZE-1:0] ImmExtD_reg;

   // Control Unit signals and registers.
   wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
   wire [1:0] ResultSrcD, ImmSrcD;
   wire [2:0] ALUControlD; 

   reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg;
   reg [1:0] ResultSrcD_reg;
   reg [2:0] ALUControlD_reg;
   reg TakingBranch_reg;

   wire ByteAddress;
   reg ByteAddressD_reg;
   reg ReadEnableD_reg;

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
   extender Extender (
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
			     .ResultSrc(ResultSrcD),
			     .MemWrite(MemWriteD),
			     .Jump(JumpD),
			     .Branch(BranchD),
			     .ALUControl(ALUControlD),
			     .ALUSrc(ALUSrcD),
			     .ImmSrc(ImmSrcD),
			     .ByteAddress(ByteAddress),
			     .ReadEnable(ReadEnable)
			     );

   // Behavior.
   always @(posedge clk or posedge rst) begin
      if (rst | FlushE) begin
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
	      ByteAddressD_reg <= 0;
	      ReadEnableD_reg <= 0;
         TakingBranch_reg <= 0;
      end else if (!StallE) begin
         RD1D_reg <= RD1;
         RD2D_reg <= RD2;
         PCD_reg <= PCD;
         PCPlus4D_reg <= PCPlus4D;
         Rs1D_reg <= InstrD[19:15];
         Rs2D_reg <= InstrD[24:20];
         RdD_reg <= InstrD[11:7];
         ImmExtD_reg <= ImmExtD;
         RegWriteD_reg <= RegWriteD;
         MemWriteD_reg <= MemWriteD;
         JumpD_reg <= JumpD;
         BranchD_reg <= BranchD;
         ALUSrcD_reg <= ALUSrcD;
         ResultSrcD_reg <= ResultSrcD;
         ALUControlD_reg <= ALUControlD;
	      ByteAddressD_reg <= ByteAddress;
	      ReadEnableD_reg <= ReadEnable;
         TakingBranch_reg <= TakingBranch;
      end
      #2;
      $display("--- DECODE STAGE ---");
      $display("PCD = %h", PCD);
      // $display("RegWriteW = %1b", RegWriteW);
      // $display("RdW = %5b", RdW);
      // $display("ResultW = %32b", ResultW);
      // $display("--- ------ ----- ---");
      // $display("JumpE = %1b, BranchE = %1b, ZeroE = %1b, PCSrcE = %1b", JumpE, BranchE, ZeroE, PCSrcE);
      // $display("ALUControlE = %3b", ALUControlE);
      // $display("ALUSrcE = %1b", ALUSrcE);
      $display("RD1E = %32b", RD1E);
      $display("RD2E = %32b", RD2E);
      $display("ImmExtE = %32b", ImmExtE);
      // $display("InstrD = %32b", InstrD);
      // $display("MemWriteE = %32b", MemWriteE);
      // $display("ByteAddressE = %32b", ByteAddressE);
   end

   // Outputs.
   assign Rs1DH = InstrD[19:15];
   assign Rs2DH = InstrD[24:20];
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
   assign ByteAddressE = ByteAddressD_reg;
   assign ReadEnableE = ReadEnableD_reg;
   assign TakingBranchE = TakingBranch_reg;
endmodule

