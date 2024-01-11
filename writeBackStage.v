`include "constants.v"
`ifndef INCLUDE_MUX
 `include "mux.v"
`endif

module writeBackStage (
		       input clk, rst,
		       input [`WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W,
		       output [`WORD_SIZE-1:0] ResultW,

		       // Control ports.
		       input [1:0] ResultSrcW
		       );
   
   // Modules.
   // Mux 3 to 1 for result.
   mux_3to1 Result_mux (
			.a(ALUResultW),
			.b(ReadDataW),
			.c(PCPlus4W),
			.sel(ResultSrcW),
			.out(ResultW)
			);

   always @ ( posedge clk or posedge rst ) begin
      #5;
      $display("ResultW = %32b", ResultW);
   end
   
endmodule
