`include "constants.v"

module programCounter(
    input clk,
    input rst,
    input [`WORD_SIZE-1:0] PCNext,
    output [`WORD_SIZE-1:0] PC
    );

    reg [`WORD_SIZE-1:0] PC_reg;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            PC_reg <= 0;
        else
            PC_reg <= PCNext;
    end

    assign PC = PC_reg;   
endmodule