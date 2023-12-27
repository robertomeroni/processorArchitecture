`include "constants.v"

module dataMemory (
    input clk, rst,
    input WE,
    input [WORD_SIZE-1:0] A, WD,
    output [WORD_SIZE-1:0] RD
);

    reg [WORD_SIZE-1:0] mem [MEM_SIZE-1:0];

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            mem <= 0; // TODO: is this the right way to reset the memory?
        end else begin
            if (WE) begin
                mem[A] <= WD;
            end
            RD <= mem[A];
        end
    end