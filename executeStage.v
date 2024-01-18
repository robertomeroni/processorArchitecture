`include "constants.v"
`ifndef INCLUDE_MUX
 `include "mux.v"
`endif
`ifndef INCLUDE_ADDER
 `include "adder.v"
`endif
`include "ALU.v"

module executeStage
  (
   input clk, rst,
   input [`WORD_SIZE-1:0] RD1E, RD2E, PCE,
   input [4:0] Rs1E, Rs2E, RdE,
   input [`WORD_SIZE-1:0] ImmExtE, PCPlus4E,
   input [`WORD_SIZE-1:0] ResultW,

   // Control ports.
   input RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE,
   input [1:0] ResultSrcE, ForwardAE, ForwardBE,
   input [2:0] ALUControlE,

   output [`WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE,
   output [4:0] RdM,
   
   output RegWriteM, MemWriteM,
   output PCSrcE, 
   output [1:0] ResultSrcM,

   //hazard outputs
   output [4:0] Rs1EH, Rs2EH, RdEH,
   output ResultSrcEH
   );

   // Internal wires and registers.
   wire [`WORD_SIZE-1:0] SrcAE, SrcBE, WriteDataE, ALUResultE;

   reg [`WORD_SIZE-1:0] ALUResultE_reg, WriteDataE_reg, PCPlus4E_reg;
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
      .out(WriteDataE)
      );

   // Mux 2 to 1 for source B.
   mux_2to1 SrcB_mux2 (
      .a(WriteDataE),
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
      .clk(clk),
      .rst(rst),
      .a(SrcAE),
      .b(SrcBE),
      .out(ALUResultE),
      .zeroE(ZeroE),
      .ALUControlE(ALUControlE)
      );

   // Behavior.
   always @(posedge clk or posedge rst) begin
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
         RdE_reg <= RdE;
         RegWriteE_reg <= RegWriteE;
         MemWriteE_reg <= MemWriteE;
         ResultSrcE_reg <= ResultSrcE;
      end
      #3;
      $display("--- EXECUTE STAGE ---");
      //$display("RD1E =       %32b\nResultW =    %32b\nALUResultM = %32b\nALUResultE = %32b\nSrcAE =      %32b\nSrcBE =      %32b\n", RD1E, ResultW, ALUResultM, ALUResultE, SrcAE, SrcBE);
      // $display("RD1E = %32b, RD2E = %32b, ImmExtE = %32b", RD1E, RD2E, ImmExtE);
      // $display("ForwardAE = %2b\nForwardBE = %2b", ForwardAE, ForwardBE);
      // $display("ALUSrcE = %1b", ALUSrcE);
      // // $display("ResultSrcM = %32b", ResultSrcM);
      // $display("ResultW = %32b", ResultW);
      // $display("--- ------- ----- ---");
      $display("MemWriteM = %1b", MemWriteM);
      $display("ALUResultM = %32b", ALUResultM);
      // $display("WriteDataM = %32b", WriteDataM);
   end

   // Outputs.
   assign Rs1EH = Rs1E;
   assign Rs2EH = Rs2E;
   assign RdEH = RdE;
   assign ResultSrcEH = ResultSrcE[0];
   assign ALUResultM = ALUResultE_reg;
   assign WriteDataM = WriteDataE_reg;
   assign RdM = RdE_reg;
   assign PCPlus4M = PCPlus4E_reg;
   assign RegWriteM = RegWriteE_reg;
   assign MemWriteM = MemWriteE_reg;
   assign ResultSrcM = ResultSrcE_reg;
   assign PCSrcE = (ZeroE & BranchE) | JumpE;
endmodule
