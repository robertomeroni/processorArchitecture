`include "constants.v"
`ifndef INCLUDE_MUX
 `include "mux.v"
`endif

module writeBackStage (
		       input clk, rst,
		       input [`WORD_SIZE-1:0] ALUResultW, ReadDataW, PCPlus4W,
		       // Control ports.
		       input [1:0] ResultSrcW,

		       // inout: pass these values along
		       input [4:0] RdW,
		       input RegWriteW,

		       // hazard output
		       output [4:0] RdWH,
		       output RegWriteWH,
		       
		       output [4:0] RdWW,
		       output RegWriteWW,
		       output [`WORD_SIZE-1:0] ResultWW
		       );

   wire [`WORD_SIZE-1:0] ResultW;
   
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
      $display("--- WRITEBACK STAGE ---");
      // $display("ALUResultW = %32b", ALUResultW);
      // $display("ResultSrcW = %2b", ResultSrcW);
      // $display("RdW = %5b", RdW);
      $display("ResultW = %32b", ResultW);
   end

   assign RdWH = rst ? 0 : RdW;
   assign RegWriteWH = rst ? 0 : RegWriteW;

   assign RdWW = rst ? 5'b00000 : RdW;
   assign RegWriteWW = rst ? 5'b00000 : RegWriteW;
   assign ResultWW = rst ? 5'b00000 : ResultW;
	
endmodule
