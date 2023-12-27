`include "constants.v"

module ALU_TB;

   reg [WORD_SIZE-1:0] A;
   reg [WORD_SIZE-1:0] B;
   e_ALUControl ALUControl;

   wire [WORD_SIZE-1:0] out;

   ALU alu ( .srcAE (A),
	     .srcBE (B),
	     .ALUControlE (ALUControl),
	     .out (out)
	     );

   task test_Add();
      begin
	 A <= 32'b00000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= ADD_OP;
      end
   endtask // test_1

   task test_Mul();
      begin
	 A <= 32'b00000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= MUL_OP;
      end
   endtask // test_1

   task test_Or();
      begin
	 A <= 32'b01000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= MUL_OP;
      end
   endtask // test_1

   initial begin
      $monitor("A=%32b, B=%32b\nout=%32b\n", A, B, out);
      #1 test_Add();
      #1 test_Mul();
      #1 test_Or();

      $dumpfile("test.vcd");
      $dumpvars(0,out);
   end
endmodule // tb