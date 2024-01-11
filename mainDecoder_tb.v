`include "mainDecoder.v"
`include "constants.v"

module tb_mainDecoder;

   reg     [6:0]    Op                                          ;
   wire             Branch, Jump, MemWrite, ALUSrc, RegWrite    ;
   wire             Op5                                         ;
   wire    [1:0]    ResultSrc, ImmSrc, ALUOp                    ;

   mainDecoder  mainDecoder_dut (
				 .Op           (    Op           ),
				 .Branch       (    Branch       ),
				 .Jump         (    Jump         ),
				 .MemWrite     (    MemWrite     ),
				 .ALUSrc       (    ALUSrc       ),
				 .RegWrite     (    RegWrite     ),
				 .Op5          (    Op5          ),
				 .ResultSrc    (    ResultSrc    ),
				 .ImmSrc       (    ImmSrc       ),
				 .ALUOp        (    ALUOp        )
				 );

   initial begin
      $dumpfile("db_tb_mainDecoder.vcd");
      $dumpvars(0, tb_mainDecoder);
      $monitor("Op = %7b, Branch = %1b, Jump = %1b, MemWrite = %1b, ALUSrc = %1b, RegWrite = %1b, Op5 = %1b, ResultSrc = %2b, ImmSrc = %2b, ALUOp = %2b, ", Op, Branch, Jump, MemWrite, ALUSrc, RegWrite, Op5, ResultSrc, ImmSrc, ALUOp);

      #10 Op = `LOAD_FUNCT7;
      #10 Op = `STORE_FUNCT7;
      #10 Op = `RTYPE_FUNCT7;
      #10 Op = `BEQ_FUNCT7  ;
      #10 Op = `ITYPE_FUNCT7;
      #10 Op = `JAL_FUNCT7  ;
      
   end

endmodule
