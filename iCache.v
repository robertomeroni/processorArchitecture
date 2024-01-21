`include "constants.v"

module iCache(
             input clk, rst,
             input [`WORD_SIZE-1:0] PCIn,
             input [`WORD_SIZE-1:0] PC,
             input [`CACHE_LINE_SIZE-1:0] MemLine,
             input MemReady,
             output [`WORD_SIZE-1:0] Instr,
             output [`WORD_SIZE-1:0] PCMem,
             output MemRead,
             output CacheStall             
);

reg [`CACHE_LINE_SIZE-1:0] Data_reg [0:`CACHE_NUM_LINES-1];
reg [`ITAG_SIZE-1:0] Tag_reg [0:`CACHE_NUM_LINES-1];
reg [`WORD_SIZE-1:0] Instr_reg ;
reg [`WORD_SIZE-1:0] PCStall_reg;
reg Valid_reg [0:`CACHE_NUM_LINES-1];
reg State;
reg MemRead_reg;
reg Stall;

//Initialize valid bits to 0 
initial begin
    State = 1'b0;
    Stall = 1'b0;
    MemRead_reg = 1'b0;
end


always @ (*) begin
    case (State)
    // idle 
    1'b0: begin
        if (Valid_reg[PCIn[`IINDEX]] && Tag_reg[PCIn[`IINDEX]] == PCIn[`ITAG]) begin // hit
            Instr_reg <= Data_reg[PCIn[`IINDEX]][PCIn[`IOFFSET] * 32 +: 32]; 
        end
        else begin // miss
            Stall <= 1'b1;
            MemRead_reg <= 1'b1;
            State <= 1'b1;
            Instr_reg <= `NOP;
        end
    end
    // wait memory
    1'b1: begin
        if (MemReady) begin
            Data_reg[PCIn[`IINDEX]] <= MemLine;
            Tag_reg[PCIn[`IINDEX]] <= PCIn[`ITAG];
            Valid_reg[PCIn[`IINDEX]] <= 1'b1;
            State <= 1'b0;
            Stall <= 1'b0;
            MemRead_reg <= 1'b0;
        end
    end
    endcase
end

assign PCIn = PC >> 2;
assign Instr = Instr_reg;
assign CacheStall = Stall == 1'b1;
assign PCMem = PC;
assign MemRead = MemRead_reg;
endmodule

