`include "constants.v"

module programCounter(clk, rst, PCNext, PC)

    input clk, rst;
    input [`WORD_SIZE-1:0] PCNext;
    output [`WORD_SIZE-1:0] PC;

    reg [`WORD_SIZE-1:0] PC_reg;

    always @(posedge clk)
    begin
        if (rst)
            PC_reg <= 0;
        else
            PC_reg <= PCNext;
    end

    assign PC = PC_reg;
    
endmodule