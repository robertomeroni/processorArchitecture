`include "constants.v"
`include "decodeStage.v"

module tb_decodeStage;

   reg                         clk, rst                                        ;
   reg     [`WORD_SIZE-1:0]    InstrD, PCD, PCPlus4D, ResultW                  ;
   reg                         RegWriteW                                       ;
   reg     [4:0]               RdW                                             ;
   wire    [`WORD_SIZE-1:0]    RD1E,RD2E, PCE                                  ;
   wire    [4:0]               Rs1E,Rs2E, RdE                                  ;
   wire    [`WORD_SIZE-1:0]    ImmExtE,PCPlus4E                                ;
   wire                        RegWriteE,MemWriteE, JumpE, BranchE, ALUSrcE    ;
   wire    [1:0]               ResultSrcE                                      ;
   wire    [2:0]               ALUControlE                                     ;

   integer i;

   decodeStage decodeStage_dut (
				.clk           (    clk           ),
				.rst           (    rst           ),
				.InstrD        (    InstrD        ),
				.PCD           (    PCD           ),
				.PCPlus4D      (    PCPlus4D      ),
				.ResultW       (    ResultW       ),
				.RegWriteW     (    RegWriteW     ),
				.RdW           (    RdW           ),
				.RD1E          (    RD1E          ),
				.RD2E          (    RD2E          ),
				.PCE           (    PCE           ),
				.Rs1E          (    Rs1E          ),
				.Rs2E          (    Rs2E          ),
				.RdE           (    RdE           ),
				.ImmExtE       (    ImmExtE       ),
				.PCPlus4E      (    PCPlus4E      ),
				.RegWriteE     (    RegWriteE     ),
				.MemWriteE     (    MemWriteE     ),
				.JumpE         (    JumpE         ),
				.BranchE       (    BranchE       ),
				.ALUSrcE       (    ALUSrcE       ),
				.ResultSrcE    (    ResultSrcE    ),
				.ALUControlE   (    ALUControlE   )
				);

   initial begin
      clk = 0; #5;
      for (i = 0; i < 12; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_decodeStage.vcd");
      $dumpvars(0, tb_decodeStage);
      $monitor("clk = %1b, RD1 = %32b, RD2 = %32b, PCD = %32b", clk, RD1E, RD2E, PCD);

      rst = 1;
      #10;
      
      rst = 0;
      InstrD = 32'b00000000000000000000001000110011;
      rst = 0;
      PCD = 40;
      PCPlus4D = 4;
      RegWriteW = 1;
      RdW = 10;
      
      
   end

endmodule
