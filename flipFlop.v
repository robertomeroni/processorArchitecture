// FPGA projects using Verilog/ VHDL 
// fpga4student.com
// Verilog code for D Flip FLop
// Verilog code for rising edge D flip flop 
module DFlipFlop(in,clk, out);
   input [`WORD_SIZE-1:0] in; // Data input 
   input clk; // clock input 
   output reg[`WORD_SIZE-1:0]  out; // output Q 
   always @(posedge clk) 
     begin
	out <= in; 
     end 
endmodule 
