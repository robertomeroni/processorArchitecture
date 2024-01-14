// constants file (to not be confused with Konstanz, city in Germany)


// Sizes.
`define WORD_SIZE 32
`define INSTR_MEM_SIZE 1024
`define REGISTER_FILE_SIZE 32
`define DATA_MEM_SIZE 512

// Initial values.
`define PC_INITIAL   32'h00001000
`define PC_EXCEPTION 32'h00002000

// ALU operations.
`define ADD_FUNCT3 3'b000
`define SUB_FUNCT3 3'b001
`define AND_FUNCT3 3'b010
`define OR_FUNCT3  3'b011
`define MUL_FUNCT3 3'b100
`define SLT_FUNCT3 3'b101

// funct7 operational codes.
`define LOAD_FUNCT7 7'b0000011
`define STORE_FUNCT7 7'b0100011
`define RTYPE_FUNCT7 7'b0110011
`define BEQ_FUNCT7 7'b1100011
`define ITYPE_FUNCT7 7'b0010011
`define JAL_FUNCT7 7'b1101111
