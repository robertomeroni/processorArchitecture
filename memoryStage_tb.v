`include "constants.v"
`include "memoryStage.v"

module tb_memoryStage;

   reg                         clk, rst                            ;
   reg     [`WORD_SIZE-1:0]    ALUResultM, WriteDataM, PCPlus4M    ;
   reg     [4:0]               RdM                                 ;
   wire    [`WORD_SIZE-1:0]    ALUResultW, ReadDataW, PCPlus4W     ;
   wire    [4:0]               RdW                                 ;
   reg                         RegWriteM, MemWriteM                ;
   reg     [1:0]               ResultSrcM                          ;
   wire                        RegWriteW                           ;
   wire    [1:0]               ResultSrcW                          ;

   integer i;

   memoryStage memoryStage_dut (
				.clk           (    clk           ),
				.rst           (    rst           ),
				.ALUResultM    (    ALUResultM    ),
				.WriteDataM    (    WriteDataM    ),
				.PCPlus4M      (    PCPlus4M      ),
				.RdM           (    RdM           ),
				.ALUResultW    (    ALUResultW    ),
				.ReadDataW     (    ReadDataW     ),
				.PCPlus4W      (    PCPlus4W      ),
				.RdW           (    RdW           ),
				.RegWriteM     (    RegWriteM     ),
				.ResultSrcM    (    ResultSrcM    ),
				.RegWriteW     (    RegWriteW     ),
				.ResultSrcW    (    ResultSrcW    )
				);

   initial begin
      clk = 0; #5;
      for (i = 0; i < 12; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_memoryStage.vcd");
      $dumpvars(0, tb_memoryStage);
      $monitor("clk = %1b, ReadDataW = %32b", clk, ReadDataW);

      rst = 1;
      #10;

      rst = 0;
      ALUResultM = 32'b00000000000000000000000000000010;
      WriteDataM = 32'b11111111111111111111111111111111;
      MemWriteM = 1'b0;
      
   end

endmodule
