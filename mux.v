`include "constants.v"

`define INCLUDE_MUX

module mux_2to1(
		input [`WORD_SIZE-1:0] a,
		input [`WORD_SIZE-1:0] b,
		input sel,
		output reg [`WORD_SIZE-1:0] out
		);

   always @(a, b, sel) begin
      case (sel)
        0: out = a;
        1: out = b;
      endcase  
   end     
endmodule

module mux_3to1(
		input [`WORD_SIZE-1:0] a,
		input [`WORD_SIZE-1:0] b,
		input [`WORD_SIZE-1:0] c,
		input [1:0] sel,
		output reg [`WORD_SIZE-1:0] out
		);

   always @(a, b, c, sel) begin
      case (sel)
        0: out = a;
        1: out = b;
        2: out = c;
      endcase
   end
endmodule
