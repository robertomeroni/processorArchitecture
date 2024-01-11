`include "constants.v"

module dataMemory (
		   input clk, rst,
		   input WE,
		   input [`WORD_SIZE-1:0] A, WD,
		   output reg [`WORD_SIZE-1:0] RD
		   );

   reg [`WORD_SIZE-1:0] mem [`DATA_MEM_SIZE-1:0];

   always @(posedge clk or posedge rst) begin
      if (rst)
        RD <= 0; 
      else begin
         if (WE) begin
            mem[A] <= WD;
         end
         RD <= mem[A];
      end
   end
endmodule
