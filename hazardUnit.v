module hazard_unit
  (
   input rst, 
   input RegWriteM, 
   input RegWriteW, 
   input [4:0] RdM, 
   input [4:0] RdW, 
   input [4:0] Rs1E, 
   input [4:0] Rs2E,
   input [4:0] Rs1D,
   input [4:0] Rs2D,
   input [4:0] RdE,
   input PCSrcE, 
   input ResultSrcE0,
   input Mul,
   input dCacheStall,
   input SBStall,
   input TakingBranch,
   input BranchHazard,
   input BranchTakenCorrectly,
   output [1:0] ForwardAE, 
   output [1:0] ForwardBE,
   output StallF, 
   output StallD,
   output StallE,
   output StallM,
   output FlushD,
   output FlushE,
   output FlushM,
   output wire resetBranch
   );

   wire lwStall;

   // forwarding to solve RAW hazard
   assign ForwardAE = (rst == 1'b1) ? 2'b00 : 
		      ((RegWriteM == 1'b1) & (RdM != 5'b00) & (RdM == Rs1E)) ? 2'b10 :
		      ((RegWriteW == 1'b1) & (RdW != 5'b00) & (RdW == Rs1E)) ? 2'b01 : 2'b00;
   
   assign ForwardBE = (rst == 1'b1) ? 2'b00 : 
		      ((RegWriteM == 1'b1) & (RdM != 5'b00) & (RdM == Rs2E)) ? 2'b10 :
		      ((RegWriteW == 1'b1) & (RdW != 5'b00) & (RdW == Rs2E)) ? 2'b01 : 2'b00;

   // stall to deal with data hazard
   assign lwStall = (rst == 1'b1) ? 1'b0 :  ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
   assign StallD  = (rst == 1'b1) ? 1'b0 : lwStall | Mul | dCacheStall | SBStall;
   assign StallF  = (rst == 1'b1) ? 1'b0 : lwStall | Mul | dCacheStall | SBStall;
   assign StallE  = (rst == 1'b1) ? 1'b0 : Mul | dCacheStall | SBStall;
   assign StallM = (rst == 1'b1) ? 1'b0 : dCacheStall | SBStall;
   assign FlushD = (rst == 1'b1) ? 1'b0 : PCSrcE | BranchHazard;
   assign FlushE  = (rst == 1'b1) ? 1'b0 : lwStall | PCSrcE | BranchHazard;
endmodule
