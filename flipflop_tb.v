`include "flipFlop.v"
`include "constants.v"

module tb_DFlipFlop;

   reg     [`WORD_SIZE-1:0]    in     ;
   reg                         clk    ;
   wire    [`WORD_SIZE-1:0]    out    ;

   DFlipFlop DFlipFlop_dut (
			    .in     (    in     ),
			    .clk    (    clk    ),
			    .out    (    out    )
			    );

   integer i;

   initial begin
      clk = 0; #5;
      for (i = 0; i < 6; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_DFlipFlop.vcd");
      $dumpvars(0, tb_DFlipFlop);
      $monitor("clk = %1b, out = %32b", clk, out);

      #5;
      in = 32'b11111111111111111111111111111111;
      #20;
      in = 32'b00000000000000000000000000000000;
      
   end

endmodule
