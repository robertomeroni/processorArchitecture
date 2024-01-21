`include "constants.v"

module programCounter(
		      input clk,
		      input rst,
		      input [`WORD_SIZE-1:0] PCNext,
		      input StallF,
		      output [`WORD_SIZE-1:0] PC
		      );

   reg [`WORD_SIZE-1:0] PC_reg;

   always @(posedge clk or posedge rst)
     begin
        if (rst) begin
          PC_reg <= `PC_INITIAL;
        end 
	else if (!StallF) begin
          PC_reg <= PCNext;
  end
      end
   assign PC = PC_reg;   



endmodule
