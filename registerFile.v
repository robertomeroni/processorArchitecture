`include "constants.v"

module registerFile(
		    input clk,
		    input rst,
		    input [4:0] A1,
		    input [4:0] A2,
		    input [4:0] A3,
		    input [`WORD_SIZE-1:0] WD3,
		    input WE3,
		    output [`WORD_SIZE-1:0] RD1,
		    output [`WORD_SIZE-1:0] RD2
		    );
   
   // Declaring the registers.
   reg [`WORD_SIZE-1:0] r [`REGISTER_FILE_SIZE-1:0];
   reg [`WORD_SIZE-1:0] rm [1:0]; // special registers, for handling exceptions.
   

   // Assigning the initial value 0 to the 0th register.
   initial begin
      r[0] <= 0;
      rm[0] <= `PC_EXCEPTION;
   end

   // Register Logic.
   always @ (A3 or WD3 or WE3) begin
      if(WE3 & (A3 != 5'b00000)) begin // cannot write to register 0.
         r[A3] <= WD3;
	 $display("Wrote %32b to r%d", WD3, A3);
      end
   end

   // Assigning the output.
   assign RD1 = (rst) ? 0 : r[A1];
   assign RD2 = (rst) ? 0 : r[A2];


   // TODO: implementation of special registers 
endmodule

