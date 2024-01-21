// constants file (to not be confused with Konstanz, city in Germany)


// Sizes.
`define WORD_SIZE 32
`define INSTR_MEM_SIZE 2048
`define REGISTER_FILE_SIZE 32
`define DATA_MEM_SIZE 512
`define ICACHE_LINE_SIZE 128
`define ICACHE_NUM_LINES 4

// iCache constants.
`define OFFSET_BIT_PRECISION `WORD_SIZE // we can access the memory every n bits, where n is the offset bit precision. Example: 8 means we can access the memory byte by byte.
`define OFFSET_SIZE $clog2 (`ICACHE_LINE_SIZE / `OFFSET_BIT_PRECISION) // bits needed to represent the offset.
`define INDEX_SIZE $clog2 (`ICACHE_NUM_LINES) // bits needed to represent the index.
`define TAG_SIZE (`WORD_SIZE - `OFFSET_SIZE - `INDEX_SIZE) // bits needed to represent the tag.
`define OFFSET `OFFSET_SIZE-1:0
`define INDEX `INDEX_SIZE+`OFFSET_SIZE-1:`OFFSET_SIZE
`define TAG `WORD_SIZE-1:`INDEX_SIZE+`OFFSET_SIZE

// Initial values.
`define PC_INITIAL   32'h00001000
`define PC_EXCEPTION 32'h00002000
`define NOP 32'b000000000000_00000_000_00000_00100_11
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

`define PROGRAM_FILENAME "bookTest.txt"
