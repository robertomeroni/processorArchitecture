// constants file (to not be confused with Konstanz, city in Germany)


// Sizes.
parameter WORD_SIZE = 32;
parameter INSTR_MEM_SIZE = 64;
parameter REGISTER_FILE_SIZE = 32;
parameter DATA_MEM_SIZE = 512;

// Initial values.
parameter PC_INITIAL =   32'h00001000;
parameter PC_EXCEPTION = 32'h00002000;

// ALU operations.
parameter ADD_FUNCT3 = 3'b000;
parameter SUB_FUNCT3 = 3'b001;
parameter AND_FUNCT3 = 3'b010;
parameter OR_FUNCT3 = 3'b011;
parameter MUL_FUNCT3 = 3'b100;
parameter SLT_FUNCT3 = 3'b101;

// funct7 operational codes.
parameter LOAD_FUNCT7 = 7'b0000011;
parameter STORE_FUNCT7 = 7'b0100011;
parameter RTYPE_FUNCT7 = 7'b0110011;
parameter BEQ_FUNCT7 = 7'b1100011;
parameter ITYPE_FUNCT7 = 7'b0010011;
parameter JAL_FUNCT7 = 7'b1101111;
