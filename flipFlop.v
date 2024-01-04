module DFlipFlop(in,clk, out);
   input [`WORD_SIZE-1:0] in; 
   input clk; 
   output reg[`WORD_SIZE-1:0]  out;
   always @(posedge clk) 
     begin
	out <= in; 
     end 
endmodule 
