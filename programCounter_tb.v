`include "constants.v"
`include "programCounter.v"

module tb_programCounter;

   reg                        clk       ;
   reg                        rst       ;
   reg    [`WORD_SIZE-1:0]    PCNext    ;
   wire   [`WORD_SIZE-1:0]    PC;

   integer i;

   programCounter programCounter_dut (
				      .clk       (    clk       ),
				      .rst       (    rst       ),
				      .PCNext    (    PCNext    ),
				      .PC (PC)
				      );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 15; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_programCounter.vcd");
      $dumpvars(0, tb_programCounter);
      $monitor("PC = %32b", PC);

      rst = 0;
      PCNext = 32'b00000000000000000000000000000000;
      
      #10 PCNext = 32'b11111111111111111111111111111111;

      #10 rst = 1;
      
   end

endmodule
