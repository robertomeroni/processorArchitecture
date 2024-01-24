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
    input CacheReady,

    output [`STOREBUFFER_LINE_SIZE-1:0] Data_out,
    output [`STOREBUFFER_LINE_SIZE-1:0] Address_out,
    output SBStall,
    output ByteAddress_out,
    output wire CacheWrite,
    output StoreBufferMiss
    );

    reg [`STOREBUFFER_LINE_SIZE-1:0] Data_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg [`STOREBUFFER_LINE_SIZE-1:0] Address_reg [0:`STOREBUFFER_NUM_LINES-1];
    integer HitAddress;
    reg Hit;
    reg StoreBufferMiss;
    reg Stall;
    reg CacheWrite_reg;
    reg [`STOREBUFFER_NUM_LINES-1:0] Valid_reg;
    reg F0;

    initial begin
        F0 <= 0;
        Hit <= 0;
        HitAddress <= `STOREBUFFER_NUM_LINES;
        CacheWrite_reg <= 0;
        StoreBufferMiss <= 0;
        Stall <= 0;

        Valid_reg[0] = 0;
        Valid_reg[1] = 0;
        Valid_reg[2] = 0;
        Valid_reg[3] = 0;

        Data_reg[0] = 0;
        Data_reg[1] = 0;
        Data_reg[2] = 0;
        Data_reg[3] = 0;

        Address_reg[0] = 0;
        Address_reg[1] = 0;
        Address_reg[2] = 0;
        Address_reg[3] = 0;
    end

  


    always @(posedge clk) begin
            if (Enable) begin
                // write operation.
                if (WriteOP) begin
                    if (Hit == 1) begin
                        Data_reg[HitAddress] <= Data_in;
                        Address_reg[HitAddress] <= Address_in;
                        Valid_reg[HitAddress] <= 1;
                    end else if (Valid_reg[0] == 0) begin
                            Data_reg[0] <= Data_in;
                            Address_reg[0] <= Address_in;
                            Valid_reg[0] <= 1;
                    end else if (Valid_reg[1] == 0) begin
                            Data_reg[1] <= Data_in;
                            Address_reg[1] <= Address_in;
                            Valid_reg[1] <= 1;
                        end else if (Valid_reg[2] == 0) begin
                            Data_reg[2] <= Data_in;
                            Address_reg[2] <= Address_in;
                            Valid_reg[2] <= 1;
                        end else if (Valid_reg[3] == 0) begin
                            Data_reg[3] <= Data_in;
                            Address_reg[3] <= Address_in;
                            Valid_reg[3] <= 1;
                        end
                    end
                end
                $display ("StoreBuffer: Data_in = %h", Data_in);
                $display ("StoreBuffer: Address_in = %h", Address_in);
                $display ("......................................");
                $display("StoreBuffer[0]: data = %h", Data_reg[0]);
                $display("StoreBuffer[1]: data = %h", Data_reg[1]);
                $display("StoreBuffer[2]: data = %h", Data_reg[2]);
                $display("StoreBuffer[3]: data = %h", Data_reg[3]);
                $display("StoreBuffer[0]: address = %h", Address_reg[0]);
                $display("StoreBuffer[1]: address = %h", Address_reg[1]);
                $display("StoreBuffer[2]: address = %h", Address_reg[2]);
                $display("StoreBuffer[3]: address = %h", Address_reg[3]);
                $display ("......................................");
      end

      always @(posedge clk) begin
        if (FullSB) begin
            $display("StoreBuffer full"); 
        end if (CacheReady) begin
            Valid_reg[3] <= 0;
            Stall <= 0;
            CacheWrite_reg <= 0;
        end
      end
   
   always @(*) begin
    Hit=0;
    if (Address_in == Address_reg[0]) begin
                // check if address is already in store buffer
                    Hit = 1;
                    HitAddress = 0;
                end else if (Address_in == Address_reg[1]) begin
                    Hit = 1;
                    HitAddress = 1;
                end else if (Address_in == Address_reg[2]) begin
                    Hit = 1;
                    HitAddress = 2;
                end else if (Address_in == Address_reg[3]) begin
                    Hit = 1;
                    HitAddress = 3;
                end
                // read operation.
                if (ReadOP == 1)
                    if (Hit == 1) begin
                        $display("StoreBuffer: Read hit, Address = %h", Address_in);
                        StoreBufferMiss = 0;
                    end else begin
                        $display("StoreBuffer: Read miss, Address = %h", Address_in);
                        StoreBufferMiss = 1;
                end
   end
    
    always @(*) begin
        if (FullSB & (~ReadOP)) begin
            Stall = 1;
            CacheWrite_reg = 1;
        end
    end


                           
      
    
    assign Data_out = Stall ? Data_reg[3] : Data_reg[HitAddress];
    assign Address_out = Stall ? Address_reg[3] : Address_reg[HitAddress];
    assign FullSB = Valid_reg[0] & Valid_reg[1] & Valid_reg[2] & Valid_reg[3];
    assign SBStall = Stall;
    assign CacheWrite = CacheWrite_reg;
endmodule

// TODO: add LoadByte and StoreByte support
          
                    