// constants file (to not be confused with Konstanz, city in Germany)


// Sizes.
`define WORD_SIZE 32
`define INSTR_MEM_SIZE 64
`define REGISTER_FILE_SIZE 32
`define DATA_MEM_SIZE 512

// Initial values.
`define PC_INITIAL   32'h00001000
`define PC_EXCEPTION 32'h00002000

// ALU operations.
`define ADD_OP 3'b000
`define SUB_OP 3'b001
`define AND_OP 3'b010
`define OR_OP  3'b011
`define MUL_OP 3'b100
   

