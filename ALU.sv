typedef enum logic [2:0] {
      Add = 3'b000,
      Sub = 3'b001,
      And = 3'b010,
      Or = 3'b011,
      Mul  = 3'b100
      } e_ALUControl;

module ALU (
	    input [31:0] srcAE,
	    input [31:0] srcBE,
	    input [2:0] ALUControlE,
	    output reg [31:0] out
	    );


   always_comb begin
      case (ALUControlE)
	Add:             out = srcAE + srcBE;
	Sub:             out = srcAE - srcBE;
	Mul:             out = srcAE * srcBE;
	And:             out = srcAE & srcBE;
	Or:              out = srcAE | srcBE;
	default:         out = '0;
      endcase
   end
endmodule

module tb;

   reg [31:0] A;
   reg [31:0] B;
   e_ALUControl ALUControl;

   wire [31:0] out;

   ALU alu ( .srcAE (A),
	     .srcBE (B),
	     .ALUControlE (ALUControl),
	     .out (out)
	     );

   task test_Add();
      begin
	 A <= 32'b00000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= Add;
      end
   endtask // test_1

   task test_Mul();
      begin
	 A <= 32'b00000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= Mul;
      end
   endtask // test_1

   task test_Or();
      begin
	 A <= 32'b01000000000000000000000000000001;
	 B <= 32'b00000000000000000000000000000001;
	 ALUControl <= Mul;
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
