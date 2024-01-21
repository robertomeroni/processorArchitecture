`include "constants.v"
`include "processor.v"

module tb_processor;

   reg   clk    ;
   reg   rst    ;

   integer i;

   processor uut (
		  .clk    (    clk    ),
		  .rst    (    rst    )
		  );

   initial begin
      #20;
      clk = 0; #10;
      for (i = 1; i < 60; i = i + 1) begin
	 $display("");
	 clk = 1;
	 #10;
	 clk = 0; 
	 #10;
      end
   end

   initial begin
      $dumpfile("db_tb_processor.vcd");
      $dumpvars(0, tb_processor);
      $monitor("clk = %1b, i = %d", clk, i);

      rst = 1;
      #10;
      rst = 0;
      
   end

endmodule
