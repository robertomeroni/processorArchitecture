`include "constants.v"

module storeBuffer (
    input clk,
    input rst,
    input [`STOREBUFFER_LINE_SIZE-1:0] Data_in,
    input [`STOREBUFFER_LINE_SIZE-1:0] Address_in,
    input Enable,
    input WriteOP,
    input ReadOP,
    input DataSize_in,
	input ByteAddress_in,

    output [`STOREBUFFER_LINE_SIZE-1:0] Data_out,
    output [`STOREBUFFER_LINE_SIZE-1:0] Address_out,
    output DataSize_out,
    output Stall,
    output ByteAddress_out,
    output CacheWrite
    );

    reg [`STOREBUFFER_LINE_SIZE-1:0] Data_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg [`STOREBUFFER_LINE_SIZE-1:0] Address_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg counter;
    reg Hit;

    initial begin
        NextLine <= 0;
        Hit <= 0;
        counter <= 0;
    end

    always @(posedge clk) begin
            if (Enable) begin
                Hit <= 0;
                counter <= 0;
                CacheWrite <= 0;
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
                if (ReadOp)
                    if (Hit == 1) begin
                        Data_out <= Data_reg[Counter]; 
                        Address_out <= Address_reg[counter]; 
                    end else begin
                        // TODO go to cache
                end
                // write operation.
                else if (WriteOp) begin
                    if (Hit == 1) begin
                        Data_reg[counter] <= Data_in;
                        Address_reg[counter] <= Address_in;
                    end else if (NextLine >= `STOREBUFFER_NUM_LINES) begin
                            Stall <= 1;
                            Data_out <= Data_reg[NextLine - 1];
                            Address_out <= Address_reg[NextLine - 1];
                            CacheWrite <= 1;
                            NextLine <= NextLine - 1;
                        end else begin
                        Data_reg[NextLine] <= Data_in;
                        Address_reg[NextLine] <= Address_in;
                        NextLine <= NextLine + 1;
                    end
                end
            end
    end

// TODO: add LoadByte and StoreByte support
          
                    