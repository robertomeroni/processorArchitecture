`include "constants.v"

module instructionMemory(rst, PC, Instr);

    input rst;
    input [`WORD_SIZE-1:0] PC;
    output [`WORD_SIZE-1:0] Instr;

    reg [`WORD_SIZE-1:0] memory_reg [`INSTR_MEM_SIZE-1:0];

    // Load instructions into memory.
    initial begin
    $readmemh("instructions.txt", memory_reg);
    end

    assign Instr = memory_reg[PC];

endmodule

     
