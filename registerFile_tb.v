`include "registerFile.v"

module tb_registerFile;

   reg                         clk    ;
   reg                         rst    ;
   reg     [4:0]               A1     ;
   reg     [4:0]               A2     ;
   reg     [4:0]               A3     ;
   reg     [`WORD_SIZE-1:0]    WD3    ;
   reg                         WE3    ;
   wire    [`WORD_SIZE-1:0]    RD1    ;
   wire    [`WORD_SIZE-1:0]    RD2    ;

   integer i;

   registerFile registerFile_dut (
				  .clk    (    clk    ),
				  .rst    (    rst    ),
				  .A1     (    A1     ),
				  .A2     (    A2     ),
				  .A3     (    A3     ),
				  .WD3    (    WD3    ),
				  .WE3    (    WE3    ),
				  .RD1    (    RD1    ),
				  .RD2    (    RD2    )
				  );

   // let the clock run a little bit
   initial begin
      clk = 0; #5;
      for (i = 0; i < 15; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_registerFile.vcd");
      $dumpvars(0, tb_registerFile);
      $monitor("RD1 = %32b, RD2 = %32b", RD1, RD2);

      // read register 0
      rst = 0;
      WE3 = 0;
      A1 = 0; A2 = 0;
      #10;

      // write to register 10
      A3 = 10;
      WD3 = 32'b11111111111111111111111111111111;
      WE3 = 1;
      A1 = 10; A2 = 10;
      #10;
      WE3 = 0;
      #10;

      // test the reset
      rst = 1;
      #10;
      
      // try writing 11111... to register 0
      rst = 0;
      A3 = 0;
      A1 = 0; A2 = 0;
      WE3 = 1;
   end

endmodule
