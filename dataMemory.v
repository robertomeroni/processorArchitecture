`include "constants.v"

module dataMemory (
		   input clk, rst,
		   input [`WORD_SIZE-3:0] Address,
		   input [`CACHE_LINE_SIZE-1:0] Line_in,
		   input Read, Write,
		   output Ready,
		   output [`CACHE_LINE_SIZE-1:0] Line_out
		   );

   reg [`CACHE_LINE_SIZE-1:0] mem [0:`DATA_MEM_SIZE-1];
   reg [`CACHE_LINE_SIZE-1:0] Line_reg;
   reg F0, F1, F2, F3, F4, F5, F6, F7, F8;
   reg Ready_reg;

   wire [`WORD_SIZE-3:0] ILine;

   initial begin
      Ready_reg = 1'b0;
      F0 = 1'b0;
      F1 = 1'b0;
      F2 = 1'b0;
      F3 = 1'b0;
      F4 = 1'b0;
	  F5 = 1'b0;
	  F6 = 1'b0;
	  F7 = 1'b0;
	  F8 = 1'b0;
	  Line_reg = 0;
	  $readmemb("memory.txt", mem);
   end

always @ (Read or Write) begin
   if (Read | Write) begin
    Ready_reg <= 1'b0;
   end
   if (Read & Write) begin
	$display("Error: Read and Write cannot be asserted at the same time");
   end
end

always @ ( posedge clk ) begin
	$display("Ready_reg = %b", Ready_reg);
	$display("CHECK registers are %b, %b, %b, %b", F0, F1, F2, F3);
	if (Read) begin
		$display("MEM: Trying to read.. F0 = %b, F1 = %b, F2 = %b, F3 = %b, F4 = %b, F5 = %b, F6 = %b, F7 = %b, F8 = %b", F0, F1, F2, F3, F4, F5, F6, F7, F8);
		// go to memory
		F0 <= 1'b1;
		F1 <= F0;
		F2 <= F1;
		F3 <= F2;
		F4 <= F3;
		F5 <= F4;
		F6 <= F5;
		F7 <= F6;
		F8 <= F7;
		Ready_reg <= F8;
	end else if (Write) begin
		$display("MEM: Trying to write.. F0 = %b, F1 = %b, F2 = %b, F3 = %b, F4 = %b, F5 = %b, F6 = %b, F7 = %b, F8 = %b", F0, F1, F2, F3, F4, F5, F6, F7, F8);
		// go to memory
		F0 <= 1'b1;
		F1 <= F0;
		F2 <= F1;
		F3 <= F2;
		F4 <= F3;
		F5 <= F4;
		F6 <= F5;
		F7 <= F6;
		F8 <= F7;
		Ready_reg <= F8;
		if (F7) begin
			// write to memory
			mem[Address] <= Line_in;
			$display("Wrote line %h to mem[%d]", Line_in, Address);
		end
		else begin
			$display("Waiting to write line %h to mem[%d]", Line_in, Address);
		end
	end
	else begin
		F0 <= 1'b0;
		F1 <= 1'b0;
		F2 <= 1'b0;
		F3 <= 1'b0;
		F4 <= 1'b0;
		F5 <= 1'b0;
		F6 <= 1'b0;
		F7 <= 1'b0;
		F8 <= 1'b0;
		Ready_reg <= 1'b0;
	end
	end



assign ILine = Address[`WORD_SIZE-3:0] << 2;
assign Ready = Ready_reg;
assign Line_out = mem[Address];
endmodule
