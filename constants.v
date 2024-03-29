// constants file (to not be confused with Konstanz, city in Germany)


// Sizes.
`define WORD_SIZE 32
`define INSTR_MEM_SIZE 2048
`define REGISTER_FILE_SIZE 32
`define DATA_MEM_SIZE 512
`define CACHE_LINE_SIZE 128
`define CACHE_NUM_LINES 4
`define INDEX_SIZE $clog2 (`CACHE_NUM_LINES) // bits needed to represent the index.

// iCache constants.
`define IOFFSET_BIT_PRECISION `WORD_SIZE // we can access the memory every n bits, where n is the offset bit precision. Example: 8 means we can access the memory byte by byte.
`define IOFFSET_SIZE $clog2 (`CACHE_LINE_SIZE / `IOFFSET_BIT_PRECISION) // bits needed to represent the offset.
`define ITAG_SIZE (`WORD_SIZE - `IOFFSET_SIZE - `INDEX_SIZE) // bits needed to represent the tag.
`define IOFFSET `IOFFSET_SIZE-1:0
`define IINDEX `INDEX_SIZE+`IOFFSET_SIZE-1:`IOFFSET_SIZE
`define ITAG `WORD_SIZE-1:`INDEX_SIZE+`IOFFSET_SIZE

//dCache constants.
`define DOFFSET_BIT_PRECISION `WORD_SIZE // we access the memory every byte.
`define DOFFSET_SIZE $clog2 (`CACHE_LINE_SIZE / `DOFFSET_BIT_PRECISION) // bits needed to represent the offset.
`define DTAG_SIZE (`WORD_SIZE - `DOFFSET_SIZE - `INDEX_SIZE) // bits needed to represent the tag.
`define DOFFSET `DOFFSET_SIZE-1:0
`define DINDEX `INDEX_SIZE+`DOFFSET_SIZE-1:`DOFFSET_SIZE
`define DTAG `WORD_SIZE-1:`INDEX_SIZE+`DOFFSET_SIZE

// StoreBuffer constants.
`define STOREBUFFER_LINE_SIZE 32
`define STOREBUFFER_NUM_LINES 4

// Branch predictor constants.
`define BRANCH_PREDICTOR_NUM_LINES 4
`define BINDEX_SIZE $clog2 (`BRANCH_PREDICTOR_NUM_LINES) // bits needed to represent the index.
`define BINDEX `BINDEX_SIZE-1:0

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
`define SLL_FUNCT3 3'b110
`define SGT_FUNCT3 3'b111

// funct7 operational codes.
`define LOAD_FUNCT7 7'b0000011
`define STORE_FUNCT7 7'b0100011
`define RTYPE_FUNCT7 7'b0110011
`define BEQ_FUNCT7 7'b1100011
`define ITYPE_FUNCT7 7'b0010011
`define JAL_FUNCT7 7'b1101111

`define PROGRAM_FILENAME "store_test.txt"
`define NUM_CYCLES 150

