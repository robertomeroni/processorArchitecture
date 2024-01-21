`include "constants.v"

module dataMemory (
		   input clk, rst,
		   input WE,
		   input [`WORD_SIZE-1:0] A, WD,
		   input ByteAddress,
		   input Read,
		//    output [`WORD_SIZE-1:0] RD,
		   output Ready,
		   output [`CACHE_LINE_SIZE-1:0] Line
		   );

   reg [`WORD_SIZE-1:0] mem [0:`DATA_MEM_SIZE-1];
   reg [`CACHE_LINE_SIZE-1:0] Line_reg;
   reg F0, F1, F2, F3, F4;
   reg Ready_reg;

   wire [`WORD_SIZE-3:0] ILine;

   initial begin
      Ready_reg = 1'b0;
      F0 = 1'b0;
      F1 = 1'b0;
      F2 = 1'b0;
      F3 = 1'b0;
      F4 = 1'b0;
	  $readmemb("memory.txt", mem);
   end

always @ (Read) begin
   if (Read) begin
      Ready_reg <= 1'b0;
   end
end

always @ ( posedge clk ) begin
if (Read) begin
   // go to memory
      F0 <= 1'b1;
      F1 <= F0;
      F2 <= F1;
      F3 <= F2;
      Ready_reg <= F3;
   end
   else begin
      F0 <= 1'b0;
      F1 <= 1'b0;
      F2 <= 1'b0;
      F3 <= 1'b0;
      Ready_reg <= 1'b0;
   end
end

   always @(posedge clk or posedge rst) begin
      // $display("mem[8] = %32b", mem[8]);
      if (WE) begin
	 if (ByteAddress) begin
	    mem[A][31:23] <= WD[7:0];
	    $display("Wrote %d to mem[%d]", WD[7:0], A);
	 end else begin
            mem[A] <= WD;
	    $display("Wrote %d to mem[%d]", WD, A);
	 end
      end
   end

//    assign RD = rst ? {32{1'b0}} :
// 	       ByteAddress ? {{24{mem[A][31]}}, mem[A][31:24]} :
// 	       mem[A];

assign ILine = ((A[`WORD_SIZE-1:0] >> 4) << 4);
assign Ready = Ready_reg;
assign Line = {mem[ILine + 3], mem[ILine + 2], mem[ILine + 1], mem[ILine]};
endmodule
