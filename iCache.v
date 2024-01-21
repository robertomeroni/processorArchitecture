`include "constants.v"

module iCache(
             input clk, rst,
             input [`WORD_SIZE-1:0] PCIn,
             input [`WORD_SIZE-1:0] PC,
             input [`ICACHE_LINE_SIZE-1:0] MemLine,
             input MemReady,
             output [`WORD_SIZE-1:0] Instr,
             output [`WORD_SIZE-1:0] PCMem,
             output MemRead,
             output CacheStall             
);

reg [`ICACHE_LINE_SIZE-1:0] Data_reg [0:`ICACHE_NUM_LINES-1];
reg [`TAG_SIZE-1:0] Tag_reg [0:`ICACHE_NUM_LINES-1];
reg [`WORD_SIZE-1:0] Instr_reg ;
reg Valid_reg [0:`ICACHE_NUM_LINES-1];
reg State;
reg MemRead_reg;

//Initialize valid bits to 0 
initial begin
    State = 1'b0;
    MemRead_reg = 1'b0;
end


always @ (PC or MemReady) begin
  
    case (State)
    // idle 
    1'b0: begin
        $display("Valid_reg = %h", Valid_reg[PCIn[`INDEX]]);
        if (Valid_reg[PCIn[`INDEX]] && Tag_reg[PCIn[`INDEX]] == PCIn[`TAG]) begin // hit
            $display("iCache HIT");
            Instr_reg = Data_reg[PCIn[`INDEX]][PCIn[`OFFSET] * 32 +: 32]; 
        end
        else begin // miss
        $display("iCache MISS");
            MemRead_reg <= 1'b1;
            State <= 1'b1;
            Instr_reg <= 0;
        end
    end
    // wait memory
    1'b1: begin
        if (MemReady) begin
            $display("MemLine = %h", MemLine);
            Data_reg[PCIn[`INDEX]] = MemLine;
            Tag_reg[PCIn[`INDEX]] = PCIn[`TAG];
            Valid_reg[PCIn[`INDEX]] = 1'b1;
            $display("iCache WRITE");
            MemRead_reg = 1'b0;
            State = 1'b0;
        end
    end
    endcase
end

assign PCIn = PC >> 2;
assign Instr = Instr_reg;
assign CacheStall = State == 1'b1;
assign PCMem = PC;
assign MemRead = MemRead_reg;
endmodule

