`include "constants.v"

module dCache(
              input clk, rst,
              input [`WORD_SIZE-1:0] Address, WriteDataM,
	          input ReadEnable,
              input WriteEnable,
              input [`CACHE_LINE_SIZE-1:0] MemLine,
              input MemReady,
              input ByteAddress,
              output [`WORD_SIZE-1:0] Value,
              output [`CACHE_LINE_SIZE-1:0] WriteLine,
              output [`DTAG_SIZE+`INDEX_SIZE-1:0] AMem,
              output MemRead, MemWrite,
              output CacheStall             
);

    reg [`CACHE_LINE_SIZE-1:0] Data_reg [0:`CACHE_NUM_LINES-1];
    reg [`DTAG_SIZE-1:0] Tag_reg [0:`CACHE_NUM_LINES-1];
    reg [`WORD_SIZE-1:0] Value_reg ;
    reg Valid_reg [0:`CACHE_NUM_LINES-1];
    reg [1:0] State;
    reg MemRead_reg, MemWrite_reg;
    reg Stall;
    integer i;

    //Initialize valid bits to 0 
    initial begin
        State = 2'b00;
        Stall = 1'b0;
        MemRead_reg = 1'b0;
        MemWrite_reg = 1'b0;
        for (i = 0; i < `CACHE_NUM_LINES; i = i + 1) begin
            Valid_reg[i] = 1'b0;
            $display("dCache: Valid_reg[%d] = %b", i, Valid_reg[i]);
        end
        for (i = 0; i < `CACHE_NUM_LINES; i = i + 1) begin
            Data_reg[i] = 0;
        end 
        $display("dCache: Initialized");
    end


    always @ (Address or WriteDataM or ReadEnable or WriteEnable or MemReady) begin
        // $display("dCache: Address = %h", Address);
        // $display("dCache: Address[`DINDEX] = %h", Address[`DINDEX]);
        // $display("dCache: Address[`DTAG] = %h", Address[`DTAG]);
        // $display("dCache: Address[`DOFFSET] = %h", Address[`DOFFSET]);
        // $display("dCache: Valid_reg[Address[`DINDEX]] = %h", Valid_reg[Address[`DINDEX]]);
        // $display("dCache: Tag_reg[Address[`DINDEX]] = %h", Tag_reg[Address[`DINDEX]]);
        // $display("dCache: Data_reg[Address[`DINDEX]] = %h", Data_reg[Address[`DINDEX]]);
        // $display("dCache: MemLine = %h", MemLine);
        // $display("dCache: MemReady = %h", MemReady);
        // $display("dCache: Value_reg = %h", Value_reg);
        $display("dCache: State = %b", State);

        case (State)
        // idle 
        2'b00: begin
            if (ReadEnable == 1'b1) begin
                if  (Valid_reg[Address[`DINDEX]] && Tag_reg[Address[`DINDEX]] == Address[`DTAG]) begin // hit
                    if (ByteAddress) begin
                        Value_reg <= Data_reg[Address[`DINDEX]][Address[`DOFFSET] * 32 +: 8]; // TODO: make it work, maybe use an offset in the instruction when you need a byte, do not change address structure 
                    end else begin
                        Value_reg <= Data_reg[Address[`DINDEX]][Address[`DOFFSET] * 32 +: 32]; 
                    end
                end else begin // miss
                    Stall <= 1'b1;
                    MemRead_reg <= 1'b1;
                    State <= 2'b01;
                end
            end else if (WriteEnable == 1'b1) begin
                if  (!(Valid_reg[Address[`DINDEX]]) | Tag_reg[Address[`DINDEX]] == Address[`DTAG]) begin
                    $display("dCache: Writing to cache");
                    Data_reg [Address[`DINDEX]][Address[`DOFFSET] * 32 +: 32] <= WriteDataM;
                    Tag_reg [Address[`DINDEX]] <= Address[`DTAG];
                    Valid_reg [Address[`DINDEX]] <= 1'b1;
                    end else begin
                        $display("Valid_reg[Address[`DINDEX]] = %b", Valid_reg[Address[`DINDEX]]);
                        $display("Address[`DINDEX] = %b", Address[`DINDEX]);
                        $display("Address = %b", Address);
                        $display("dCache: Sending one line to memory");
                        $display("dCache: AMem = %h", AMem);
                        $display("dCache: WriteLine = %h", WriteLine);                        
                        Stall <= 1'b1;
                        MemWrite_reg <= 1'b1;
                        State <= 2'b10;
                    end
            end
        end
        // wait memory for read
        2'b01: begin
            if (MemReady) begin
                Data_reg[Address[`DINDEX]] <= MemLine;
                Tag_reg[Address[`DINDEX]] <= Address[`DTAG];
                Valid_reg[Address[`DINDEX]] <= 1'b1;

                Stall <= 1'b0;
                State <= 2'b00;
                MemRead_reg <= 1'b0;
            end
        end
        // wait memory for write
        2'b10: begin
            if (MemReady) begin
                MemWrite_reg <= 1'b0;
                Stall <= 1'b0;
                State <= 2'b00;
            end
        end
        endcase
   end

    assign Value = Value_reg;
    assign CacheStall = Stall == 1'b1;
    assign AMem[`DTAG_SIZE+`INDEX_SIZE-1:`INDEX_SIZE] = Tag_reg[Address[`DINDEX]];
    assign AMem[`INDEX_SIZE-1:0] = Address[`DINDEX];
    assign WriteLine = Data_reg[Address[`DINDEX]];
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;

endmodule

// TODO cache eviction
// TODO load byte and store byte