`include "constants.v"
`include "executeStage.v"

module tb_executeStage;

   reg                         clk, rst                                       ;
   reg     [`WORD_SIZE-1:0]    RD1E, RD2E, PCE                                ;
   reg     [4:0]               Rs1E, Rs2E, RDE                                ;
   reg     [`WORD_SIZE-1:0]    ImmExtE, PCPlus4E                              ;
   reg     [`WORD_SIZE-1:0]    ResultW                                        ;
   wire    [`WORD_SIZE-1:0]    ALUResultM, WriteDataM, PCPlus4M, PCTargetE    ;
   wire    [4:0]               RdM                                            ;
   reg                         RegWriteE, ALUSrcE, MemWriteE, JumpE, BranchE  ;
   reg     [1:0]               ResultSrcE, ForwardAE, ForwardBE               ;
   reg     [2:0]               ALUControlE                                    ;
   wire                        RegWriteM, MemWriteM                           ;
   wire                        PCSrcE                                         ;
   wire    [1:0]               ResultSrcM                                     ;

   integer i;

   executeStage executeStage_dut (
				  .clk            (    clk            ),
				  .rst            (    rst            ),
				  .RD1E           (    RD1E           ),
				  .RD2E           (    RD2E           ),
				  .PCE            (    PCE            ),
				  .Rs1E           (    Rs1E           ),
				  .Rs2E           (    Rs2E           ),
				  .RDE            (    RDE            ),
				  .ImmExtE        (    ImmExtE        ),
				  .PCPlus4E       (    PCPlus4E       ),
				  .ResultW        (    ResultW        ),
				  .ALUResultM     (    ALUResultM     ),
				  .WriteDataM     (    WriteDataM     ),
				  .PCPlus4M       (    PCPlus4M       ),
				  .PCTargetE      (    PCTargetE      ),
				  .RdM            (    RdM            ),
				  .RegWriteE      (    RegWriteE      ),
				  .ALUSrcE        (    ALUSrcE        ),
				  .MemWriteE      (    MemWriteE      ),
				  .JumpE          (    JumpE          ),
				  .BranchE        (    BranchE        ),
				  .ResultSrcE     (    ResultSrcE     ),
				  .ForwardAE      (    ForwardAE      ),
				  .ForwardBE      (    ForwardBE      ),
				  .ALUControlE    (    ALUControlE    ),
				  .RegWriteM      (    RegWriteM      ),
				  .MemWriteM      (    MemWriteM      ),
				  .PCSrcE         (    PCSrcE         ),
				  .ResultSrcM     (    ResultSrcM     )
				  );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 12; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_executeStage.vcd");
      $dumpvars(0, tb_executeStage);
      // $monitor("clk = %1b, ALUResultM = %32b, WriteDataM = %32b, RegWriteM = %1b", clk, ALUResultM, WriteDataM, RegWriteM);

      rst = 1;
      #10;
      RegWriteE = 1;
      ALUSrcE = 0;
      ResultSrcE = 1;
      RD1E = 10;
      RD2E = 20;
      ALUControlE = 3'b000;
      JumpE = 0;
      BranchE = 0;
      ResultW = 0;
      PCE = 30;
      ImmExtE = 100;
      ForwardAE = 2'b00;
      ForwardBE = 2'b00;
      #10;
      rst = 0;
      
   end

endmodule
