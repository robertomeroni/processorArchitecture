`include "constants.v"
`include "instructionMemory.v"

module tb_instructionMemory;

   reg                        rst    ;
   reg    [`WORD_SIZE-1:0]    PC     ;

   wire   [`WORD_SIZE-1:0] Instr;

   instructionMemory instructionMemory_dut (
					    .rst    (    rst    ),
					    .PC     (    PC     ),
					    .Instr (Instr)      
					    );

   initial begin
      $dumpfile("db_tb_instructionMemory.vcd");
      $dumpvars(0, tb_instructionMemory);
      $monitor("rst = %1b, PC = %32b, Instr = %32b", rst, PC, Instr);
      
      rst = 0;
      PC = 0;

      #10 if (Instr != 32'b00000000000100010000001000110011) begin
	 $display("erorr in instruction mem");
      end 

      PC = 1;
      #10 if (Instr != 32'b00000000001100010000001000110011) begin
	 $display("erorr in instruction mem");
      end

      rst = 1;
      #10 if (Instr != 0) begin
	 $display("erorr in instruction mem");
      end 
      
   end

endmodule
