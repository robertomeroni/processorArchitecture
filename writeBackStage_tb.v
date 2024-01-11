`include "constants.v"
`include "writeBackStage.v"

module tb_writeBackStage;

   reg                         clk,rst                            ;
   reg     [`WORD_SIZE-1:0]    ALUResultW, ReadDataW, PCPlus4W    ;
   wire    [`WORD_SIZE-1:0]    ResultW                            ;
   reg     [1:0]               ResultSrcW                         ;

   integer i;

   writeBackStage writeBackStage_dut (
				      .clk           (    clk           ),
				      .rst           (    rst           ),
				      .ALUResultW    (    ALUResultW    ),
				      .ReadDataW     (    ReadDataW     ),
				      .PCPlus4W      (    PCPlus4W      ),
				      .ResultW       (    ResultW       ),
				      .ResultSrcW    (    ResultSrcW    )
				      );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 12; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_writeBackStage.vcd");
      $dumpvars(0, tb_writeBackStage);
      $monitor("clk = %1b, ResultW = %32b", clk, ResultW);

      rst = 1;
      #10;

      rst = 0;
      ReadDataW = 37;
      PCPlus4W = 0;
      ALUResultW = 0;
      ResultSrcW = 2'b01;
      
   end

endmodule
