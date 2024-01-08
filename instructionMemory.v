`include "constants.v"

module instructionMemory(
    input rst,
    input [`WORD_SIZE-1:0] PC,
    output [`WORD_SIZE-1:0] Instr
    );

    reg [`WORD_SIZE-1:0] memory_reg [0:`INSTR_MEM_SIZE-1];

    // Load instructions into memory.
    initial begin
    $readmemb("instructions.txt", memory_reg);
    end

    assign Instr = (rst) ? 0 : memory_reg[PC];
endmodule

     
