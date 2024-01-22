`include "constants.v"

module storeBuffer (
    input clk,
    input rst,
    input [`STOREBUFFER_LINE_SIZE-1:0] Data_in,
    input [`STOREBUFFER_LINE_SIZE-1:0] Address_in,
    input Enable,
    input WriteOP,
    input ReadOP,
	input ByteAddress_in,

    output [`STOREBUFFER_LINE_SIZE-1:0] Data_out,
    output [`STOREBUFFER_LINE_SIZE-1:0] Address_out,
    output Stall,
    output ByteAddress_out,
    output CacheWrite,
    output StoreBufferMiss
    );

    reg [`STOREBUFFER_LINE_SIZE-1:0] Data_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg [`STOREBUFFER_LINE_SIZE-1:0] Address_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg counter;
    reg Hit;
    reg StoreBufferMiss;
    reg Stall;
    reg CacheWrite;
    integer NextLine;


    initial begin
        NextLine <= 0;
        Hit <= 0;
        counter <= 0;
        CacheWrite <= 0;
        StoreBufferMiss <= 0;
        Stall <= 0;
    end

    always @(posedge clk) begin
            if (Enable) begin
                Hit <= 0;
                counter <= 0;
                CacheWrite <= 0;
                StoreBufferMiss <= 0;
                Stall <= 0;
                // check if address is already in store buffer
                while (counter < NextLine) begin
                    while (Hit == 0) begin
                        if (Address_in == Address_reg[counter]) begin
                            Hit <= 1;
                            counter <= counter - 1;
                        end
                        counter <= counter + 1;
                    end
                end
                // read operation.
                if (ReadOP == 1)
                    if (Hit == 1) begin
                        StoreBufferMiss <= 0;
                    end else begin
                        StoreBufferMiss <= 1;
                end
                // write operation.
                else if (WriteOP) begin
                    if (!Hit) begin
                        Data_reg[NextLine] <= Data_in;
                        Address_reg[NextLine] <= Address_in;
                        NextLine <= NextLine + 1;
                    end else if (NextLine >= `STOREBUFFER_NUM_LINES) begin
                            Stall <= 1;
                            CacheWrite <= 1;
                            NextLine <= NextLine - 1;
                        end 
                    end
                end
            end
    
    assign Data_out = Stall ? Data_reg[NextLine - 1] : Data_reg[counter];
    assign Address_out = Stall ? Address_reg[NextLine - 1] : Address_reg[counter];
endmodule

// TODO: add LoadByte and StoreByte support
          
                    