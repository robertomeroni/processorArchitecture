`include "constants.v"

module instructionMemory(
			 input clk, rst,
			 input [`WORD_SIZE-1:0] PC,
          input Read,
          output Ready,
			 output [`ICACHE_LINE_SIZE-1:0] Line
			 );

   reg [`WORD_SIZE-1:0] Memory_reg [0:`INSTR_MEM_SIZE-1];
   reg [`ICACHE_LINE_SIZE-1:0] Line_reg;
   reg F0, F1, F2, F3, F4;
   reg State, Ready_reg; // Initialize to idle state

   wire [`WORD_SIZE-3:0] PCLine;

   // Load instructions into memory.
   initial begin
      // $readmemb("instructions.txt", memory_reg);
      $readmemh(`PROGRAM_FILENAME, memory_reg);
   end

always @ ( posedge clk ) begin
case (State)
   // idle
   1'b0: begin
      if (Read) begin
         Ready_reg <= 1'b0;
         F0 <= 1'b1;
         F1 <= F0;
         F2 <= F1;
         F3 <= F2;
         F4 <= F3;
         State <= F4;
      end
   end

   // loading
   1'b1: begin
      $display("I'm the InstructionMemory and I'm sending the line to the iCache");
      Line_reg = {Memory_reg[PCLine + 3], Memory_reg[PCLine + 2], Memory_reg[PCLine + 1], Memory_reg[PCLine]};
      Ready_reg = 1'b1;
      State = 1'b0;
   end
endcase
end
assign PCLine = ((PC[`WORD_SIZE-1:2] >> 2) << 2);
assign Line = Line_reg;
assign Ready = Ready_reg;
endmodule


