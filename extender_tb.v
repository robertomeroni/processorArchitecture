`include "extender.v"

module tb_extender;

   reg    [1:0]  ImmSrc;
   reg    [24:0] inp;
   wire   [31:0] out;

   extender extender_dut (
			  .ImmSrc    (    ImmSrc    ),
			  .inp       (    inp       ),
			  .out       (    out       )
			  );

   initial begin
      $dumpfile("db_tb_extender.vcd");
      $dumpvars(0, tb_extender);
      $monitor("out = %32b", out);

      inp = 32'b00000000000000000000101010101010;
      ImmSrc = 2'b00; #10;
      if (out != 32'b11111111111111111111101010101010) begin
	 $display("error in lw case");
      end 

      inp = 32'b00000001111111000000000000001010;
      ImmSrc = 2'b01; #10;
      if (out != 32'b11111111111111111111111111101010) begin
	 #10 $display("error in sw case");
      end 
      
   end

endmodule
