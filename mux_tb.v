`include "mux.v"

module mux_tb;

   reg [`WORD_SIZE-1:0] a0;
   reg [`WORD_SIZE-1:0] b0;
   reg sel0;
   wire [`WORD_SIZE-1:0] out0;

   reg [`WORD_SIZE-1:0] a1;
   reg [`WORD_SIZE-1:0] b1;
   reg [`WORD_SIZE-1:0] c1;
   reg   [1:0] sel1;
   wire [`WORD_SIZE-1:0] out1;

   // make separate wires for testing the two muxes

   mux_2to1 mux_2to1_dut (.a (a0),
			  .b (b0),
			  .sel(sel0),
			  .out(out0));

   mux_3to1 mux_3to1_dut (.a (a1),
			  .b (b1),
			  .c (c1),
			  .sel(sel1),
			  .out(out1));

   task test_2to1;
      begin
	 $display("testing 2 to 1 multiplexer");
	 a0 = 32'b00000000000000000000000000000000;
	 b0 = 32'b11111111111111111111111111111111;
	 sel0 = 0;
	 #10 sel0 = 1;
      end
   endtask // test_2to1

   task test_3to1;
      begin
	 $display("testing 3 to 1 multiplexer");
	 a1 = 32'b00000000000000000000000000000000;
	 b1 = 32'b11111111111111111111111111111111;
	 c1 = 32'b01010101010101010101010101010101;
	 sel1 = 2'b00;
	 #10 sel1 = 2'b01;
	 #10 sel1 = 2'b10;
      end
   endtask // test_2to1

   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0, mux_tb);
      $monitor("a=  %32b\nb=  %32b\nsel=%1b\nout=%32b\n", a0, b0, sel0, out0);
      #10 test_2to1();
      #10 $monitor("a=  %32b\nb=  %32b\nc=  %32b\nsel=%2b\nout=%32b\n", a1, b1, c1, sel1, out1);
      #10 test_3to1();
   end
endmodule // mux_tb
