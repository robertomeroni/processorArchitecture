`include "constants.v"

module dCache(
             input clk, rst,
             input [`WORD_SIZE-1:0] A,
             input [`CACHE_LINE_SIZE-1:0] MemLine,
             input MemReady,
             output [`WORD_SIZE-1:0] Value,
             output [`WORD_SIZE-1:0] AMem,
             output MemRead,
             output CacheStall             
);

reg [`CACHE_LINE_SIZE-1:0] Data_reg [0:`CACHE_NUM_LINES-1];
reg [`DTAG_SIZE-1:0] Tag_reg [0:`CACHE_NUM_LINES-1];
reg [`WORD_SIZE-1:0] Value_reg ;
reg [`WORD_SIZE-1:0] Instr_reg ;
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
        if (Valid_reg[A[`DINDEX]] && Tag_reg[A[`DINDEX]] == A[`DTAG]) begin // hit
            Value_reg <= Data_reg[A[`DINDEX]][A[`DOFFSET] * 32 +: 32]; 
        end
        else begin // miss
            Stall <= 1'b1;
            MemRead_reg <= 1'b1;
            State <= 1'b1;
        end
    end
    // wait memory
    1'b1: begin
        if (MemReady) begin
            Data_reg[A[`DINDEX]] <= MemLine;
            Tag_reg[A[`DINDEX]] <= A[`DTAG];
            Valid_reg[A[`DINDEX]] <= 1'b1;
            State <= 1'b0;
            Stall <= 1'b0;
            MemRead_reg <= 1'b0;
        end
    end
    endcase
end

assign Value = Value_reg;
assign CacheStall = Stall == 1'b1;
assign AMem = A;
assign MemRead = MemRead_reg;
endmodule

