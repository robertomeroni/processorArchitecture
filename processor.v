`include "constants.v"
`include "fetchStage.v"
`include "decodeStage.v"
`include "executeStage.v"
`include "memoryStage.v"
`include "writeBackStage.v"

module processor (
		  input clk, rst
		  );

   // Connect pipeline stages.
   // Fetch inputs.
   wire PCSrcE;
   wire [`WORD_SIZE-1:0] PCTargetE;

   // Decode inputs.
   wire [`WORD_SIZE-1:0] InstrD, PCPlus4D, PCD;
   wire [4:0] RdW;
   wire RegWriteW;
   wire [`WORD_SIZE-1:0] ResultW;

   // Execute inputs.
   wire [`WORD_SIZE-1:0] RD1E, RD2E, PCE;
   wire [4:0] Rs1E, Rs2E, RdE;
   wire [`WORD_SIZE-1:0] ImmExtE, PCPlus4E;
   wire RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE, AluSrcE;
   wire [1:0] ResultSrcE;
   wire [2:0] ALUControlE;

   // Memory inputs.
   wire [`WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M;
   wire [4:0] RdM;
   wire RegWriteM, MemWriteM;
   wire [1:0] ResultSrcM;

   // Writeback inputs.
   wire [`WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W;
   wire [1:0] ResultSrcW;


   // Modules.
   // Fetch Stage.
   fetchStage Fetch (
		     // standard inputs
		     .clk(clk),
		     .rst(rst),
		     .PCSrcE(PCSrcE),
		     .PCTargetE(PCTargetE),
		     // standard outputs
		     .InstrD(InstrD),
		     .PCD(PCD),
		     .PCPlus4D(PCPlus4D)
		     );

   // Decode Stage.
   decodeStage Decode (
		       // standard inputs
		       .clk(clk),
		       .rst(rst),
		       .InstrD(InstrD),
		       .PCD(PCD),
		       .PCPlus4D(PCPlus4D),
		       .ResultW(ResultW),
		       .RegWriteW(RegWriteW),
		       .RdW(RdW),
		       // standard outputs
		       .RD1E(RD1E),
		       .RD2E(RD2E),
		       .PCE(PCE),
		       .Rs1E(Rs1E),
		       .Rs2E(Rs2E),
		       .RdE(RdE),
		       .ImmExtE(ImmExtE),
		       .PCPlus4E(PCPlus4E),

		       // control outputs
		       .RegWriteE(RegWriteE),
		       .MemWriteE(MemWriteE),
		       .JumpE(JumpE),
		       .BranchE(BranchE),
		       .ALUSrcE(ALUSrcE),
		       .ResultSrcE(ResultSrcE),
		       .ALUControlE(ALUControlE)
		       );

   // Execute Stage.
   executeStage Execute (
			 // standard inputs
			 .clk(clk),
			 .rst(rst),
			 .RD1E(RD1E),
			 .RD2E(RD2E),
			 .PCE(PCE),
			 .Rs1E(Rs1E),
			 .Rs2E(Rs2E),
			 .RdE(RdE),
			 .ImmExtE(ImmExtE),
			 .PCPlus4E(PCPlus4E),
			 .ResultW(ResultW),
			 // standard outputs
			 .ALUResultM(ALUResultM),
			 .WriteDataM(WriteDataM),
			 .PCPlus4M(PCPlus4M),
			 .PCTargetE(PCTargetE),
			 .RdM(RdM),

			 // control inputs
			 .RegWriteE(RegWriteE),
			 .ALUSrcE(ALUSrcE),
			 .MemWriteE(MemWriteE),
			 .JumpE(JumpE),
			 .BranchE(BranchE),
			 .ResultSrcE(ResultSrcE),
			 .ALUControlE(ALUControlE),
			 // control outputs
			 .RegWriteM(RegWriteM),
			 .MemWriteM(MemWriteM),
			 .ResultSrcM(ResultSrcM),
			 .PCSrcE(PCSrcE)
			 );

   // Memory Stage.
   memoryStage Memory (
		       // standard inputs
		       .clk(clk),
		       .rst(rst),
		       .ALUResultM(ALUResultM),
		       .WriteDataM(WriteDataM),
		       .PCPlus4M(PCPlus4M),
		       .RdM(RdM),
		       // standard outputs
		       .ALUResultW(ALUResultW),
		       .ReadDataW(ReadDataW),
		       .PCPlus4W(PCPlus4W),
		       .RdW(RdW),

		       // control inputs
		       .RegWriteM(RegWriteM),
		       .MemWriteM(MemWriteM),
		       .ResultSrcM(ResultSrcM),
		       // control outputs
		       .RegWriteW(RegWriteW),
		       .ResultSrcW(ResultSrcW)
		       );

   // Writeback Stage.
   writeBackStage Writeback (
			     // standard inputs
			     .clk(clk),
			     .rst(rst),
			     .ALUResultW(ALUResultW),
			     .ReadDataW(ReadDataW),
			     .PCPlus4W(PCPlus4W),
			     // standard outputs
			     .ResultW(ResultW),
      
			     // control inputs
			     .ResultSrcW(ResultSrcW)
			     );

   // TODO: Hazard Detection Unit.

endmodule






