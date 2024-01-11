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

   ALU alu_dut ( .clk (clk),
		 .rst (rst),
		 .a (A),
		 .b (B),
		 .ALUControlE (control),
		 .out (out),
		 .zeroE (zeroE)
		 );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 15; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end
   

   task test_Add;
      @(posedge clk) 
	begin
	   $display("testing add");
	   #1 A = 32'b00000000000000000000000000000001;
	   B = 32'b00000000000000000000000000000001;
	   control = `ADD_FUNCT3;
	 end
      @(negedge clk)
	begin
	   #10; // wait one clock
	   if (out != 32'b00000000000000000000000000000010) begin
	      $display("error in add");
	   end 
	end
   endtask // test_1

   task test_Mul;
      @(posedge clk) 
	begin
	   $display("testing mul");
	   #1 A = 32'b00000000000000000000000000000100;
	   B = 32'b00000000000000000000000000000010;
	   control = `MUL_FUNCT3;
	end
      @(negedge clk)
	begin
	   #50; // check output on falling edge after 5 cycles
	   if (out != 32'b00000000000000000000000000001000) begin
	      $display("error in mul");
	   end
	end
   endtask // test_1

   task test_Or;
      @(posedge clk) 
	begin
	   $display("testing or");
	   #1 A = 32'b01000000000000000000000000000001;
	   B = 32'b00000000000000000000000000000001;
	   control = `OR_FUNCT3;
	end
      @(negedge clk)
	begin
	   #10 // wait one clock
	   if (out != 32'b01000000000000000000000000000001) begin
	      $display("error in or");
	   end
	end
   endtask // test_1

   task test_ZeroE;
      @(posedge clk) 
	begin
	   $display("testing zero flag");
	   #1 A = 32'b00000000000000000000000000000001;
	   B = 32'b00000000000000000000000000000001;
	   control = `SUB_FUNCT3;
	end
      @(negedge clk)
	begin
	   #10; // wait one clock
	   if (zeroE != 1'b1) begin
	      $display("error in zero flag");
	   end
	end
   endtask // test_ZeroE
   

   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0, ALU_TB);
      // $monitor("A=  %32b\nB=  %32b\nout=%32b\nzeroE=%1b\n", A, B, out, zeroE);
      $monitor("clk = %1b\tout = %32b\tzeroE = %1b", clk, out, zeroE);
      #10 rst = 1'b0;
      test_Add();
      test_Or();
      test_Mul();
      test_ZeroE();
      #10 rst = 1'b1;
   end
endmodule // tb
