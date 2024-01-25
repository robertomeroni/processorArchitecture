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
		       inout RegWriteW,

		       // hazard output
		       output [4:0] RdWH,
		       output RegWriteWH,
		       
		       output [`WORD_SIZE-1:0] ResultW
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

//    always @ ( posedge clk or posedge rst ) begin
//       #5;
//       $display("--- WRITEBACK STAGE ---");
//       $display("ALUResultW = %32b", ALUResultW);
//       $display("ResultSrcW = %2b", ResultSrcW);
//       $display("RdW = %5b", RdW);
//       $display("ResultW = %32b", ResultW);
//    end

   assign RdWH = RdW;
   assign RegWriteWH = RegWriteW;
endmodule
