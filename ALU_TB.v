`include "constants.v"
`include "ALU.v"

module ALU_TB;

   reg [`WORD_SIZE-1:0] A;
   reg [`WORD_SIZE-1:0] B;
   reg [2:0] control;

   reg   clk;
   reg   rst;

   wire [`WORD_SIZE-1:0] out;
   wire   zeroE;

   integer i;

   ALU alu ( .clk (clk),
	     .rst (rst),
	     .a (A),
	     .b (B),
	     .ALUControlE (control),
	     .out (out),
	     .zeroE (zeroE)
	     );

   task test_Add();
      begin
	 clk = 1'b0;
	 A = 32'b00000000000000000000000000000001;
	 B = 32'b00000000000000000000000000000001;
	 control = `ADD_FUNCT3;
	 clk = 1'b1;
      end
   endtask // test_1

   task test_Mul();
      begin
	 clk = 1'b0;
	 A = 32'b00000000000000000000000000000100;
	 B = 32'b00000000000000000000000000000010;
	 control = `MUL_FUNCT3;
	 for (i = 0; i < 10; i = i+1) begin
	    #10 clk = ~clk;
	 end
	 // clk = 1'b1;
      end
   endtask // test_1

   task test_Or();
      begin
	 clk = 1'b0;
	 A = 32'b01000000000000000000000000000001;
	 B = 32'b00000000000000000000000000000001;
	 control = `OR_FUNCT3;
	 clk = 1'b1;
      end
   endtask // test_1

   task test_ZeroE();
      begin
	 A = 32'b00000000000000000000000000000000;
	 B = 32'b00000000000000000000000000000000;
	 control = `MUL_FUNCT3;
	 for (i = 0; i < 10; i = i+1) begin
	    #10 clk = ~clk;
	 end

	 clk = 1'b0;
	 A = 32'b00000000000000000000000000000001;
	 B = 32'b00000000000000000000000000000001;
	 control = `SUB_FUNCT3;
	 clk = 1'b1;
      end
   endtask // test_ZeroE
   

   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0, ALU_TB);
      $monitor("out=%32b\nzeroE=%32b\n", out, zeroE);
      #1 rst = 1'b0;
      #1 test_Add();
      #1 test_Or();
      #1 test_Mul();
      #1 test_ZeroE();
      #1 rst = 1'b1;
   end
endmodule // tb
