`include "constants.v"

module dataMemory (
		   input clk, rst,
		   input WE,
		   input [`WORD_SIZE-1:0] A, WD,
		   output reg [`WORD_SIZE-1:0] RD
		   );

   reg [`WORD_SIZE-1:0] mem [0:`DATA_MEM_SIZE-1];

   initial begin
      $readmemb("memory.txt", mem);
   end

   always @(posedge clk or posedge rst) begin
      if (rst)
        RD <= 0; 
      else begin
         if (WE) begin
            mem[A] <= WD;
	    // $display("Wrote %32b to mem[%d]", WD, A);
         end
         RD <= mem[A];
	 // $display("read mem[%d] = %32b", A, RD);
      end
   end
endmodule
