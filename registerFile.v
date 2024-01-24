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
   

   initial begin
      r[0] <= 0;
      r[1] <= 0;
      r[2] <= 0;
      r[3] <= 0;
      r[4] <= 0;
      r[5] <= 0;
      r[6] <= 0;
      r[7] <= 0;
      r[8] <= 0;
      r[9] <= 0;
      r[10] <= 0;
      r[11] <= 0;
      r[12] <= 0;
      r[13] <= 0;
      r[14] <= 0;
      r[15] <= 0;
      r[16] <= 0;
      r[17] <= 0;
      r[18] <= 0;
      r[19] <= 0;
      r[20] <= 0;
      r[21] <= 0;
      r[22] <= 0;
      r[23] <= 0;
      r[24] <= 0;
      r[25] <= 0;
      r[26] <= 0;
      r[27] <= 0;
      r[28] <= 0;
      r[29] <= 0;
      r[30] <= 0;
      r[31] <= 0;
      rm[0] <= `PC_EXCEPTION;
   end

   // Register Logic.
   always @ (*) begin
      if(WE3 & (A3 != 5'b00000)) begin // cannot write to register 0.
         r[A3] = WD3;
	      $display("Wrote %d to r%d", WD3, A3);
      end
   end


   always @ (posedge clk) begin
      $display ("AAAAAAAAAAAAAAAA r[14] = %d", r[14]);
   end
   
   
   // Assigning the output.
   assign RD1 = (rst) ? 0 : r[A1];
   assign RD2 = (rst) ? 0 : r[A2];


   // TODO: implementation of special registers 
endmodule

