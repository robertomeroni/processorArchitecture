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
reg [`WORD_SIZE-1:0] PCStall_reg;
reg Valid_reg [0:`ICACHE_NUM_LINES-1];
reg [1:0] State;
reg MemRead_reg;
reg Stall;

//Initialize valid bits to 0 
initial begin
    State = 2'b00;
    Stall = 1'b0;
    MemRead_reg = 1'b0;
end


always @ (posedge clk) begin
  $display("iCache State = %b", State);
            $display("PCStall_reg = %h", PCStall_reg);
    case (State)
    // idle 
    2'b00: begin
        $display("Valid_reg = %h", Valid_reg[PCIn[`INDEX]]);
        if (Valid_reg[PCIn[`INDEX]] && Tag_reg[PCIn[`INDEX]] == PCIn[`TAG]) begin // hit
            $display("iCache HIT");
            Instr_reg <= Data_reg[PCIn[`INDEX]][PCIn[`OFFSET] * 32 +: 32]; 
        end
        else begin // miss
        $display("iCache MISS");
            Stall <= 1'b1;
            MemRead_reg <= 1'b1;
            State <= 2'b01;
            Instr_reg <= `NOP;
            PCStall_reg <= PCIn;
        end
    end
    // wait memory
    2'b01: begin
        if (MemReady) begin
            $display("MemLine = %h", MemLine);
            Data_reg[PCIn[`INDEX]] <= MemLine;
            Tag_reg[PCIn[`INDEX]] <= PCIn[`TAG];
            Valid_reg[PCIn[`INDEX]] <= 1'b1;
            $display("iCache WRITE");
            State <= 2'b10;
        end
    end
    2'b10: begin
        Instr_reg <= Data_reg[PCStall_reg[`INDEX]][PCStall_reg[`OFFSET] * 32 +: 32]; 
        MemRead_reg <= 1'b0;
        State <= 2'b00;
        Stall <= 1'b0;
    end
    endcase
end

assign PCIn = PC >> 2;
assign Instr = Instr_reg;
assign CacheStall = Stall == 1'b1;
assign PCMem = PC;
assign MemRead = MemRead_reg;
endmodule

