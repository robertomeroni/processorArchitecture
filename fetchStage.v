`include "instructionMemory.v"
`include "programCounter.v"
`include "mux.v"
`include "adder.v"
`include "iCache.v"


module fetchStage
  (
   input clk,
   input rst,
   input PCSrcE,
   input [`WORD_SIZE-1:0] PCTargetE,
   
   // hazard inputs
   input StallF,
   input StallD,
   input FlushD,
   
   // hazard outputs
   output [`WORD_SIZE-1:0] InstrD,
   output [`WORD_SIZE-1:0] PCD,
   output [`WORD_SIZE-1:0] PCPlus4D,
   output iCacheStall
   );

   // Internal signals.
   wire [`WORD_SIZE-1:0] PCNext, PCF, PCPlus4F;
   wire [`WORD_SIZE-1:0] InstrF;
   wire [`WORD_SIZE-1:0] PCMem;
   wire MemRead, MemReady;
   wire [`ICACHE_LINE_SIZE-1:0] MemLine;

   // Registers.
   reg [`WORD_SIZE-1:0] InstrF_reg;
   reg [`WORD_SIZE-1:0] PCF_reg, PCPlus4F_reg;

   // Modules.
   // PC multiplexer.
   mux_2to1 PC_mux (
		    .a(PCPlus4F),
		    .b(PCTargetE),
		    .sel(PCSrcE),
		    .out(PCNext)
		    );

   // PC.
   programCounter Program_Counter (
				   .clk(clk),
				   .rst(rst),
				   .PCNext(PCNext),
				   .StallF(StallF),
				   .PC(PCF)
				   );
   
   // Instruction Cache.
   iCache Instruction_Cache (
              .clk(clk),
              .rst(rst),
              .PC(PCF),
              .MemLine(MemLine),
              .MemReady(MemReady),
              .Instr(InstrF),
              .PCMem(PCMem),
              .MemRead(MemRead),
              .CacheStall(iCacheStall)
              );

   // Instruction memory.
   instructionMemory Instruction_Memory (
                .clk(clk),
                .rst(rst),
                .PC(PCMem),
                .Read(MemRead),
                .Line(MemLine),
                .Ready(MemReady)
                );

   // Go to next instruction.
   adder PC_Adder (
		   .a(PCF),
		   .b(32'b00000000000000000000000000000100),
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
         PCPlus4F_reg <= `PC_INITIAL + 4;
         InstrF_reg <= 0;
      end else if (FlushD) begin
	 // send a nop down the pipeline
         InstrF_reg <= `NOP;
      end else if (!StallD) begin
         InstrF_reg <= InstrF;
         PCF_reg <= PCF;
         PCPlus4F_reg <= PCPlus4F;
      end
      #1;
      $display("--- FETCH STAGE ---");
      $display("PCF = %h", PCF);
      // $display("PCSrcE = %32b", PCSrcE);
      $display("InstrD = %8h", InstrD);
   end

   // Trasmitting the values to the output ports.
   assign InstrD = InstrF_reg;
   assign PCD = PCF_reg;
   assign PCPlus4D = PCPlus4F_reg;
endmodule


