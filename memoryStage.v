`include "constants.v"
`include "dataMemory.v"
`include "dCache.v"
`include "storeBuffer.v"

module memoryStage (
		    input clk, rst,
		    input [`WORD_SIZE-1:0] ALUResultM, WriteDataM, PCPlus4M,
		    input [4:0] RdM,
		    // Control ports.
		    input RegWriteM, MemWriteM,
		    input [1:0] ResultSrcM,
		    input ByteAddressM,
		    input ReadEnableM, 

		    // hazard output
		    output [4:0] RdMH,
		    output [0:0] RegWriteMH,
		    output [`WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W,
		    output [4:0] RdW,
		    output RegWriteW,
		    output [1:0] ResultSrcW,
		    output CacheStall,
          output SBStall
		    );

   // Internal wires and registers.
   wire [`WORD_SIZE-1:0] ReadDataM;
   wire Ready;
   wire [`CACHE_LINE_SIZE-1:0] ReadLineMemToCache;
   wire MemRead;
   wire CacheStall;
   wire [`WORD_SIZE-3:0] LineAddressCacheToMem;
   wire [`CACHE_LINE_SIZE-1:0] WriteLineCacheToMem;
   wire MemWrite;
   wire EnableSB;
   wire [`WORD_SIZE-1:0] AddressSBtoCache, StoreBufferData;
   wire StoreBufferMiss;
   wire CacheWriteEnable;
   wire EnableCacheRead;
   wire [`WORD_SIZE-1:0] CacheRead;
   wire dCacheReady;

   reg [`WORD_SIZE-1:0] ALUResultM_reg, ReadDataM_reg, PCPlus4M_reg;
   reg [4:0] RdM_reg;

   // Control signals and registers.
   reg RegWriteM_reg;
   reg [1:0] ResultSrcM_reg;

   // Modules.
   dataMemory Data_Memory (
			   .clk(clk),
			   .rst(rst),
			   .Address(LineAddressCacheToMem),
            .Line_in(WriteLineCacheToMem),
			   .Ready(Ready),
			   .Read(MemRead),
            .Write(MemWrite),
            .Line_out(ReadLineMemToCache)
			   );

   dCache Data_Cache (
		      .clk(clk),
		      .rst(rst),
		      .Address(AddressSBtoCache),
            .WriteDataM(StoreBufferData),
		      .ReadEnable(EnableCacheRead),
            .WriteEnable(CacheWriteEnable),
            .ByteAddress(ByteAddressM),
		      .AMem(LineAddressCacheToMem),
		      .MemLine(ReadLineMemToCache),
            .WriteLine(WriteLineCacheToMem),
		      .MemReady(Ready),
		      .MemRead(MemRead),
            .MemWrite(MemWrite),
		      .Value(CacheRead),
		      .CacheStall(CacheStall),
            .CacheReady(dCacheReady)
		      );

   storeBuffer Store_Buffer (
               .clk(clk),
               .rst(rst),
               .Data_in(WriteDataM),
               .Address_in(ALUResultM),
               .Enable(EnableSB),
               .WriteOP(MemWriteM),
               .ReadOP(ReadEnableM),
               .CacheReady(dCacheReady),
               .Data_out(StoreBufferData),
               .Address_out(AddressSBtoCache),
               .SBStall(SBStall),
               .CacheWrite(CacheWriteEnable),
               .StoreBufferMiss(StoreBufferMiss)
               );


   // Behavior.
   // TODO: make memory access take 5 clocks as per the project statement
   always @(posedge clk or posedge rst) begin
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
      #4;
      $display("--- MEMORY STAGE ---");
      $display("MemWriteM = %1b", MemWriteM);
      $display("ALUResultM = %32b", ALUResultM);
      $display("RegWriteM = %1b", RegWriteM);
      $display("--- ------ ----- ---");
      $display("ReadDataW = %32b", ReadDataW);
   end

   // Outputs.
   assign RdMH = RdM;
   assign RegWriteMH = RegWriteM;
   assign ALUResultW = ALUResultM_reg;
   assign ReadDataW = ReadDataM_reg;
   assign PCPlus4W = PCPlus4M_reg;
   assign RdW = RdM_reg;
   assign RegWriteW = RegWriteM_reg;
   assign ResultSrcW = ResultSrcM_reg;
   assign EnableSB = (MemWriteM | ReadEnableM) ? 1'b1 : 1'b0;
   assign ReadDataM = StoreBufferMiss ? CacheRead : StoreBufferData;
   assign EnableCacheRead = (ReadEnableM & StoreBufferMiss) ? 1'b1 : 1'b0;
endmodule

