`include "constants.v"

module instructionMemory(
			 input clk, rst,
			 input [`WORD_SIZE-1:0] PC,
          input Read,
          output Ready,
			 output [`CACHE_LINE_SIZE-1:0] Line
			 );

   reg [`WORD_SIZE-1:0] Memory_reg [0:`INSTR_MEM_SIZE-1];
   reg [`CACHE_LINE_SIZE-1:0] Line_reg;
   reg F0, F1, F2, F3, F4;
   reg Ready_reg; 

   wire [`WORD_SIZE-3:0] PCLine;

   // Load instructions into memory.
   initial begin
      Ready_reg = 1'b0;
      F0 = 1'b0;
      F1 = 1'b0;
      F2 = 1'b0;
      F3 = 1'b0;
      F4 = 1'b0;
      $readmemh(`PROGRAM_FILENAME, Memory_reg);
   end

always @ (Read) begin
   if (Read) begin
      Ready_reg <= 1'b0;
   end
end

always @ ( posedge clk ) begin
if (Read) begin
   // go to memory
      F0 <= 1'b1;
      F1 <= F0;
      F2 <= F1;
      F3 <= F2;
      Ready_reg <= F3;
   end
   else begin
      F0 <= 1'b0;
      F1 <= 1'b0;
      F2 <= 1'b0;
      F3 <= 1'b0;
      Ready_reg <= 1'b0;
   end
end

assign PCLine = ((PC[`WORD_SIZE-1:2] >> 2) << 2);
assign Ready = Ready_reg;
assign Line = {Memory_reg[PCLine + 3], Memory_reg[PCLine + 2], Memory_reg[PCLine + 1], Memory_reg[PCLine]};
endmodule


