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
    output SBStall,
    output ByteAddress_out,
    output CacheWrite,
    output StoreBufferMiss
    );

    reg [`STOREBUFFER_LINE_SIZE-1:0] Data_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg [`STOREBUFFER_LINE_SIZE-1:0] Address_reg [0:`STOREBUFFER_NUM_LINES-1];
    reg HitAddress;
    reg Hit;
    reg StoreBufferMiss;
    reg Stall;
    reg CacheWrite;
    reg [`STOREBUFFER_NUM_LINES-1:0] Valid_reg;
    reg F0;

    initial begin
        F0 <= 0;
        Hit <= 0;
        HitAddress <= 0;
        CacheWrite <= 0;
        StoreBufferMiss <= 0;
        Stall <= 0;
        Valid_reg[0] = 0;
        Valid_reg[1] = 0;
        Valid_reg[2] = 0;
        Valid_reg[3] = 0;
    end

    always @(*) begin
        if (FullSB) begin
            Stall <= 1'b1;
        end 
    end


    always @(posedge clk) begin
            if (Enable) begin
                HitAddress <= 0;
                Hit <= 0;
                CacheWrite <= 0;
                StoreBufferMiss <= 0;
                if (Stall) begin
                    F0 <= 1'b1;
                    Stall <= F0;
                end else if (Address_in == Address_reg[0]) begin
                // check if address is already in store buffer
                    $display("StoreBuffer: Hit = %d", Hit);
                    Hit = 1;
                    HitAddress = 0;
                end else if (Address_in == Address_reg[1]) begin
                    $display("StoreBuffer: Hit = %d", Hit);
                    Hit = 1;
                    HitAddress = 1;
                end else if (Address_in == Address_reg[2]) begin
                    $display("StoreBuffer: Hit = %d", Hit);
                    Hit = 1;
                    HitAddress = 2;
                end else if (Address_in == Address_reg[3]) begin
                    $display("StoreBuffer: Hit = %d", Hit);
                    Hit = 1;
                    HitAddress = 3;
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
                    if (Hit == 1) begin
                        Data_reg[HitAddress] = Data_in;
                        Address_reg[HitAddress] = Address_in;
                        Valid_reg[HitAddress] = 1;
                    end else if ( FullSB ) begin
                            $display("StoreBuffer full"); 
                            CacheWrite <= 1;
                            Valid_reg[3] = 0;
                    end else if (Valid_reg[0] == 0) begin
                            Data_reg[0] = Data_in;
                            Address_reg[0] = Address_in;
                            Valid_reg[0] = 1;
                    end else if (Valid_reg[1] == 0) begin
                            Data_reg[1] = Data_in;
                            Address_reg[1] = Address_in;
                            Valid_reg[1] = 1;
                        end else if (Valid_reg[2] == 0) begin
                            Data_reg[2] = Data_in;
                            Address_reg[2] = Address_in;
                            Valid_reg[2] = 1;
                        end else if (Valid_reg[3] == 0) begin
                            Data_reg[3] = Data_in;
                            Address_reg[3] = Address_in;
                            Valid_reg[3] = 1;
                        end
                    end
                    end
                $display ("StoreBuffer: Data_in = %h", Data_in);
                $display ("StoreBuffer: Address_in = %h", Address_in);
                $display ("--------------------------------------");
                $display("StoreBuffer: data = %h", Data_reg[0]);
                $display("StoreBuffer: data = %h", Data_reg[1]);
                $display("StoreBuffer: data = %h", Data_reg[2]);
                $display("StoreBuffer: data = %h", Data_reg[3]);
                $display("StoreBuffer: address = %h", Address_reg[0]);
                $display("StoreBuffer: address = %h", Address_reg[1]);
                $display("StoreBuffer: address = %h", Address_reg[2]);
                $display("StoreBuffer: address = %h", Address_reg[3]);
      end
    
    assign Data_out = Stall ? Data_reg[3] : Data_reg[HitAddress];
    assign Address_out = Stall ? Address_reg[3] : Address_reg[HitAddress];
    assign FullSB = Valid_reg[0] & Valid_reg[1] & Valid_reg[2] & Valid_reg[3];
    assign SBStall = Stall;
endmodule

// TODO: add LoadByte and StoreByte support
          
                    