`include "constants.v"

module dCache(
              input clk, rst,
              input [`WORD_SIZE-1:0] Address, WriteDataM,
	          input ReadEnable,
              input WriteEnable,
              input [`CACHE_LINE_SIZE-1:0] MemLine,
              input MemReady,
              input ByteAddress,
              input [`WORD_SIZE-1:0] CacheReadAddress,
              output [`WORD_SIZE-1:0] Value,
              output [`CACHE_LINE_SIZE-1:0] WriteLine,
              output [`WORD_SIZE-3:0] AMem,
              output MemRead, MemWrite,
              output CacheStall,
              output wire CacheReady            
);

    reg [`CACHE_LINE_SIZE-1:0] Data_reg [0:`CACHE_NUM_LINES-1];
    reg [`DTAG_SIZE-1:0] Tag_reg [0:`CACHE_NUM_LINES-1];
    reg [`WORD_SIZE-1:0] Value_reg ;
    reg Valid_reg [0:`CACHE_NUM_LINES-1];
    reg [1:0] State;
    reg MemRead_reg, MemWrite_reg;
    reg Stall;
    reg Ready_reg;
    integer i;

    //Initialize valid bits to 0 
    initial begin
        State = 2'b00;
        Stall = 1'b0;
        MemRead_reg = 1'b0;
        MemWrite_reg = 1'b0;
        Ready_reg = 1'b0;
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
        $display("dCache: State = %b", State);
        case (State)
        // idle 
        2'b00: begin
            Ready_reg <= 1'b0;
            if (ReadEnable == 1'b1) begin
                if  ((!Valid_reg[CacheReadAddress[`DINDEX]]) | Tag_reg[CacheReadAddress[`DINDEX]] != CacheReadAddress[`DTAG]) begin 
                    // miss
                    $display("dCache: Miss");
                    $display("dCache: CacheReadAddress[`DTAG] = %h", CacheReadAddress[`DTAG]);
                    $display("dCache: Tag_reg[%d] = %h", CacheReadAddress[`DINDEX], Tag_reg[CacheReadAddress[`DINDEX]]);
                    $display("dCache: Valid_reg[%d] = %h", CacheReadAddress[`DINDEX], Valid_reg[CacheReadAddress[`DINDEX]]);
                    Stall <= 1'b1;
                    MemRead_reg <= 1'b1;
                    State <= 2'b01;
                end
            end else if (WriteEnable == 1'b1) begin
                if  (!(Valid_reg[Address[`DINDEX]]) | Tag_reg[Address[`DINDEX]] == Address[`DTAG]) begin
                    Data_reg [Address[`DINDEX]][Address[`DOFFSET] * 32 +: 32] <= WriteDataM;
                    Tag_reg [Address[`DINDEX]] <= Address[`DTAG];
                    Valid_reg [Address[`DINDEX]] <= 1'b1;
                    $display("dCache: Wrote WriteDataM = %h into the cache", WriteDataM);
                    Ready_reg <= 1'b1;
                end else begin
                    Stall <= 1'b1;
                    MemWrite_reg <= 1'b1;
                    State <= 2'b10;
                end
            end
        end
        // wait memory for read
        2'b01: begin
            if (MemReady) begin
                Data_reg[CacheReadAddress[`DINDEX]] <= MemLine;
                Tag_reg[CacheReadAddress[`DINDEX]] <= CacheReadAddress[`DTAG];
                Valid_reg[CacheReadAddress[`DINDEX]] <= 1'b1;

                Stall <= 1'b0;
                State <= 2'b00;
                MemRead_reg <= 1'b0;
            end
        end
        // wait memory for write
        2'b10: begin
            if (MemReady) begin
                MemWrite_reg <= 1'b0;
                Valid_reg[Address[`DINDEX]] <= 1'b0;
                Stall <= 1'b0;
                State <= 2'b00;
            end
        end
        endcase
        $display("Data_reg[0] = %h", Data_reg[0]);
        $display("Data_reg[1] = %h", Data_reg[1]);
        $display("Data_reg[2] = %h", Data_reg[2]);
        $display("Data_reg[3] = %h", Data_reg[3]);

        $display("Tag_reg[0] = %h", Tag_reg[0]);
        $display("Tag_reg[1] = %h", Tag_reg[1]);
        $display("Tag_reg[2] = %h", Tag_reg[2]);
        $display("Tag_reg[3] = %h", Tag_reg[3]);

        $display("Valid_reg[0] = %h", Valid_reg[0]);
        $display("Valid_reg[1] = %h", Valid_reg[1]);
        $display("Valid_reg[2] = %h", Valid_reg[2]);
        $display("Valid_reg[3] = %h", Valid_reg[3]);
   end

    
    assign Value = Data_reg[CacheReadAddress[`DINDEX]][CacheReadAddress[`DOFFSET] * 32 +: 32];
    assign CacheStall = Stall == 1'b1;
    assign AMem[`DTAG_SIZE+`INDEX_SIZE-1:`INDEX_SIZE] = ReadEnable ? Tag_reg[CacheReadAddress[`DINDEX]]: Address[`DTAG];
    assign AMem[`INDEX_SIZE-1:0] = ReadEnable ? CacheReadAddress[`DINDEX] : Address[`DINDEX];
    assign WriteLine = Data_reg[Address[`DINDEX]];
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;
    assign CacheReady = Ready_reg;

endmodule

