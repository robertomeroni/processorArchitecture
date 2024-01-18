module hazard_unit
  (
   input rst, 
   input RegWriteM, 
   input RegWriteW, 
   input [4:0] RdM, 
   input [4:0] RdW, 
   input [4:0] Rs1E, 
   input [4:0] Rs2E,
   input [4:0] Rs1D,
   input [4:0] Rs2D,
   input [4:0] RdE,
   input ResultSrcE0,
   output [1:0] ForwardAE, 
   output [1:0] ForwardBE,
   output StallF, 
   output StallD,
   output FlushE
   );

   wire lwStall;

   initial begin
      $monitor("lwStall = %1b", lwStall);
   end

   // forwarding to solve RAW hazard
   assign ForwardAE = (rst == 1'b1) ? 2'b00 : 
		      ((RegWriteM == 1'b1) & (RdM != 5'h00) & (RdM == Rs1E)) ? 2'b10 :
		      ((RegWriteW == 1'b1) & (RdW != 5'h00) & (RdW == Rs1E)) ? 2'b01 : 2'b00;
   
   assign ForwardBE = (rst == 1'b1) ? 2'b00 : 
		      ((RegWriteM == 1'b1) & (RdM != 5'h00) & (RdM == Rs2E)) ? 2'b10 :
		      ((RegWriteW == 1'b1) & (RdW != 5'h00) & (RdW == Rs2E)) ? 2'b01 : 2'b00;

   // stall to deal with data hazard
   assign lwStall = (rst == 1'b1) ? 1'b0 :  ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
   assign FlushE  = (rst == 1'b1) ? 1'b0 : lwStall;
   assign StallD  = (rst == 1'b1) ? 1'b0 : lwStall;
   assign StallF  = (rst == 1'b1) ? 1'b0 : lwStall;
   
endmodule
