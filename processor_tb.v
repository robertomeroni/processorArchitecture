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
      clk = 0; #5;
      for (i = 0; i < 12; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
	 $display("");
      end
   end

   initial begin
      $dumpfile("db_tb_processor.vcd");
      $dumpvars(0, tb_processor);
      $monitor("clk = %1b", clk);

      rst = 1;
      #10;

      rst = 0;
      
   end

endmodule
