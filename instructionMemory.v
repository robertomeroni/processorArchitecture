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
   reg [1:0] State, Ready_reg; // Initialize to idle state

   wire [`WORD_SIZE-3:0] PCLine;

   // Load instructions into memory.
   initial begin
      State = 2'b00;
      Ready_reg = 1'b0;
      F0 = 1'b0;
      F1 = 1'b0;
      F2 = 1'b0;
      F3 = 1'b0;
      F4 = 1'b0;
      $readmemh(`PROGRAM_FILENAME, Memory_reg);
   end

always @ ( negedge clk ) begin
   $display("InstructionMemory State = %b", State);
case (State)
   // idle
   2'b0: begin
      if (Read) begin
         Ready_reg <= 1'b0;
         State <= 2'b01;
      end
   end

   // go to memory
   2'b01: begin
      F0 <= 1'b1;
      F1 <= F0;
      F2 <= F1;
      F3 <= F2;
      if (F3) begin
         State <= 2'b10;
      end
   end

   2'b10: begin
      $display("I'm the InstructionMemory and I'm sending the line to the iCache");
      Line_reg <= {Memory_reg[PCLine + 3], Memory_reg[PCLine + 2], Memory_reg[PCLine + 1], Memory_reg[PCLine]};
      State <= 2'b11;
   end

   // take data back from memory
   2'b11: begin
      F0 <= 1'b0;
      F1 <= F0;
      F2 <= F1;
      F3 <= F2;

      if (!F3) begin
         Ready_reg <= 1'b1;
         State <= 2'b00;
      end
   end


endcase
end
assign PCLine = ((PC[`WORD_SIZE-1:2] >> 2) << 2);
assign Line = Line_reg;
assign Ready = Ready_reg;
endmodule


