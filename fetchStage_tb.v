`include "fetchStage.v"
`include "constants.v"

module tb_fetchStage;

   reg                         clk          ;
   reg                         rst          ;
   reg                         PCSrcE       ;
   reg     [`WORD_SIZE-1:0]    PCTargetE    ;
   wire    [`WORD_SIZE-1:0]    InstrD       ;
   wire    [`WORD_SIZE-1:0]    PCD          ;
   wire    [`WORD_SIZE-1:0]    PCPlus4D     ;

   integer i;
   

   fetchStage fetchStage_dut  (
			       .clk          (    clk          ),
			       .rst          (    rst          ),
			       .PCSrcE       (    PCSrcE       ),
			       .PCTargetE    (    PCTargetE    ),
			       .InstrD       (    InstrD       ),
			       .PCD          (    PCD          ),
			       .PCPlus4D     (    PCPlus4D     )
			       );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 3; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_fetchStage.vcd");
      $dumpvars(0, tb_fetchStage);

      $monitor("clk = %1b, InstrD = %32b, PCD = %32b, PCPlus4D = %32b", clk, InstrD, PCD, PCPlus4D);

      PCSrcE = 0;
      rst = 0;
      #10;
      
   end

endmodule
