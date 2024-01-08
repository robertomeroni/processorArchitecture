`include "dataMemory.v"
`include "constants.v"

module tb_dataMemory;

   reg                        clk    ;
   reg                        rst    ;   
   reg                        WE     ;
   reg    [`WORD_SIZE-1:0]    A      ;
   reg    [`WORD_SIZE-1:0]    WD     ;
   wire    [`WORD_SIZE-1:0]    RD    ;

   integer i;

   dataMemory dataMemory_dut (
			      .clk    (    clk    ),
			      .rst    (    rst    ),
			      .WE     (    WE     ),
			      .A      (    A      ),
			      .WD     (    WD     ),
			      .RD     (    RD     )
			      );

   initial begin
      clk = 0; #5;
      for (i = 0; i < 30; i = i + 1) begin
	 clk = 1; #5 clk = 0; #5;
      end
   end

   initial begin
      $dumpfile("db_tb_dataMemory.vcd");
      $dumpvars(0, tb_dataMemory);
      $monitor("RD = %32b", RD);

      // test reading after write
      rst = 0;
      
      A = 100;
      WD = 32'b11111111111111110000000000000000;
      WE = 1; #10;
      WE = 0; #10;
      if (RD != 32'b11111111111111110000000000000000) begin
	 $display("erorr in dataMemory");
      end
      
      A = 200;
      WD = 32'b00000000000000001111111111111111;
      WE = 1; #10;
      WE = 0; #10;
      if (RD != 32'b00000000000000001111111111111111) begin
	 $display("erorr in dataMemory");
      end

      WE = 0; #10; 
      rst = 1; #10;
      if (RD != 32'b00000000000000000000000000000000) begin
	 $display("erorr in dataMemory");
      end
      
   end

endmodule
