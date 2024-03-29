`include "constants.v"
`include "fetchStage.v"
`include "decodeStage.v"
`include "executeStage.v"
`include "memoryStage.v"
`include "writeBackStage.v"
`include "hazardUnit.v"


module processor (
		  input clk, rst
		  );

   // Connect pipeline stages.
   // Fetch inputs.
   wire PCSrcE;
   wire [`WORD_SIZE-1:0] PCTargetE;
   wire ZeroE;
   // hazard input
   wire StallF, StallD, FlushD;
   wire TakingBranch;

   // Decode inputs.
   wire [`WORD_SIZE-1:0] InstrD, PCPlus4D, PCD;
   wire [4:0] RdW;
   wire RegWriteW;
   wire [`WORD_SIZE-1:0] ResultW;
   // hazard input
   wire FlushE;
   wire StallE;
   // decode outputs to hazard unit
   wire [4:0] Rs1DH, Rs2DH;

   // Execute inputs.
   wire [`WORD_SIZE-1:0] RD1E, RD2E, PCE;
   wire [4:0] Rs1E, Rs2E, RdE;
   wire [`WORD_SIZE-1:0] ImmExtE, PCPlus4E;
   wire RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE, AluSrcE;
   wire [1:0] ResultSrcE;
   wire [2:0] ALUControlE;
   wire [`WORD_SIZE-1:0] PCEToBranchPredictor;
   wire ReadEnableE;
   wire TakingBranchE;
   // hazard inputs
   wire [1:0] ForwardAE, ForwardBE;
   wire StallM;
   wire FlushM;
   
   // hazard outputs
   wire   [4:0] RdEH, Rs1EH, Rs2EH;
   wire   ResultSrcEH;
   wire   MulH;
   wire   BranchHazard;
   wire   BranchTakenCorrectly;
   wire [`WORD_SIZE-1:0] SavedPC;
   
   // Memory inputs.
   wire [`WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M;
   wire [4:0] RdM;
   wire RegWriteM, MemWriteM;
   wire [1:0] ResultSrcM;
   wire SBStall;
   // memory hazard outputs
   wire [4:0] RdMH;
   wire  RegWriteMH, dCacheStall;
   wire BranchEToBranchPredictor;
   wire ReadEnableM;

   // Writeback inputs.
   wire [`WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W;
   wire [1:0] ResultSrcW;

   // writeback hazard outputs
   wire [4:0] RdWH;
   wire RegWriteWH;


   // Modules.
   // Fetch Stage.
   fetchStage Fetch (
		     // standard inputs
		     .clk(clk),
		     .rst(rst),
		     .PCSrcE(PCSrcE),
		     .PCTargetE(PCTargetE),
			 
		     // hazard inputs
		     .StallF(StallF),
		     .StallD(StallD),
		     .FlushD(FlushD),
			 .BranchE(BranchEToBranchPredictor),
			 .ZeroE(ZeroE),
			 .PCEToBranchPredictor(PCEToBranchPredictor),
		     .SavedPC(SavedPC),
			 .resetBranch(BranchHazard),

		     // standard outputs
		     .InstrD(InstrD),
		     .PCD(PCD),
		     .PCPlus4D(PCPlus4D),
			 .TakingBranchD(TakingBranch)
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
		       // hazard inputs
		       .StallE(StallE),
		       .FlushE(FlushE),
			   .TakingBranch(TakingBranch),
		       
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
		       .ALUControlE(ALUControlE),
		       .ByteAddressE(ByteAddressE),
		       .ReadEnableE(ReadEnableE),
			   .TakingBranchE(TakingBranchE),
		       // hazard outputs
		       .Rs1DH(Rs1DH),
		       .Rs2DH(Rs2DH)
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
			 // control inputs
			 .RegWriteE(RegWriteE),
			 .ALUSrcE(ALUSrcE),
			 .MemWriteE(MemWriteE),
			 .JumpE(JumpE),
			 .BranchE(BranchE),
			 .BranchEToBranchPredictor(BranchEToBranchPredictor),
			 .ResultSrcE(ResultSrcE),
			 .ALUControlE(ALUControlE),
			 .ByteAddressE(ByteAddressE),
			 .ReadEnableE(ReadEnableE),
			 .TakingBranchE(TakingBranchE),
			 //hazard inputs
			 .ForwardAE(ForwardAE),
			 .ForwardBE(ForwardBE),
			 .StallM(StallM),
			 .BranchHazard(BranchHazard),
			 .FlushM(FlushM),

			 // standard outputs
			 .ALUResultM(ALUResultM),
			 .WriteDataM(WriteDataM),
			 .PCPlus4M(PCPlus4M),
			 .PCTargetE(PCTargetE),
			 .RdM(RdM),
			 // control outputs
			 .RegWriteM(RegWriteM),
			 .MemWriteM(MemWriteM),
			 .ResultSrcM(ResultSrcM),
			 .PCSrcE(PCSrcE),
			 .ByteAddressM(ByteAddressM),
			 .ReadEnableM(ReadEnableM),
			 .ZeroE(ZeroE),
			 .PCEToBranchPredictor(PCEToBranchPredictor),
			 .SavedPC(SavedPC),
			 // hazard outputs
			 .RdEH(RdEH),
			 .Rs1EH(Rs1EH),
			 .Rs2EH(Rs2EH),
			 .ResultSrcEH(ResultSrcEH),
			 .MulH(MulH),
			 .BranchTakenCorrectly(BranchTakenCorrectly)
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
		       // control inputs
		       .RegWriteM(RegWriteM),
		       .MemWriteM(MemWriteM),
		       .ResultSrcM(ResultSrcM),
		       .ByteAddressM(ByteAddressM),
		       .ReadEnableM(ReadEnableM),
		       
		       // standard outputs
		       .ALUResultW(ALUResultW),
		       .ReadDataW(ReadDataW),
		       .PCPlus4W(PCPlus4W),
		       .RdW(RdW),
		       // control outputs
		       .RegWriteW(RegWriteW),
		       .ResultSrcW(ResultSrcW),
		       // hazard outputs
		       .RdMH(RdMH),
		       .RegWriteMH(RegWriteMH),
			   .CacheStall(dCacheStall),
			   .SBStall(SBStall)
		       );

   // Writeback Stage.
   writeBackStage Writeback (
			     // standard inputs
			     .clk(clk),
			     .rst(rst),
			     .ALUResultW(ALUResultW),
			     .ReadDataW(ReadDataW),
			     .PCPlus4W(PCPlus4W),
			     // control inputs
			     .ResultSrcW(ResultSrcW),
			     .RegWriteW(RegWriteW),
			     .RdW(RdW),
			     
			     // standard outputs
			     .ResultW(ResultW),
			     // hazard outputs
			     .RdWH(RdWH),
			     .RegWriteWH(RegWriteWH)
			     );

   // Hazard Detection Unit.
   hazard_unit Hazard(
		      // standard inputs
		      .rst(rst), 
		      .RegWriteM(RegWriteMH),
		      .RegWriteW(RegWriteWH),
		      .RdM(RdMH),
		      .RdW(RdWH),
		      .Rs1E(Rs1EH),
		      .Rs2E(Rs2EH),
		      .Rs1D(Rs1DH),
		      .Rs2D(Rs2DH),
		      .RdE(RdEH),
		      .PCSrcE(PCSrcE),
		      .ResultSrcE0(ResultSrcEH),
		      .Mul(MulH),
		      .dCacheStall(dCacheStall),
		      .SBStall(SBStall),
			  .TakingBranch(TakingBranch),
			  .BranchHazard(BranchHazard),
			  .BranchTakenCorrectly(BranchTakenCorrectly),
		      // standard outputs
		      .StallF(StallF), 
		      .StallD(StallD),
		      .StallE(StallE),
		      .StallM(StallM),
		      .FlushD(FlushD),
		      .FlushE(FlushE),
			  .FlushM(FlushM),
		      .ForwardAE(ForwardAE),
		      .ForwardBE(ForwardBE)
		      );

endmodule





