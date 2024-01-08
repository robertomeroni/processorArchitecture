`include "ALUDecoder.v"
`include "constants.v"

module tb_ALUDecoder;

   reg    [1:0]    ALUOp      ;
   reg    [2:0]    funct3     ;
   reg             funct7, Op5;
   wire   [2:0] ALUControl    ;

   ALUDecoder ALUDecoder_dut (
			      .ALUOp     (    ALUOp     ),
			      .funct3    (    funct3    ),
			      .funct7    (    funct7    ),
			      .Op5       (    Op5       ),
			      .ALUControl(    ALUControl) 
			      );

   task debug(
	      input  [2:0] out
	      );
      if (ALUControl != out)
      begin
	 $display("error in decode, ALUOp = %2b, funct3 = %3b, funct7 = %1b, Op5 = %1b", ALUOp, funct3, funct7, Op5);
      end
   endtask // debug
   

   initial begin
      $dumpfile("db_tb_ALUDecoder.vcd");
      $dumpvars(0, tb_ALUDecoder);
      $monitor("ALUControl = %3b", ALUControl);

      ALUOp = 2'b00; #10;
      debug(`ADD_FUNCT3);
      
      ALUOp = 2'b01; #10;
      debug(`SUB_FUNCT3);
      
      ALUOp = 2'b10;
      
      funct3 = 3'b000;
      Op5 = 1;
      funct7=1; #10;
      debug(`SUB_FUNCT3);
      
      funct7=0; #10;
      debug(`ADD_FUNCT3);

      funct3 = 3'b010; #10;
      debug(`SLT_FUNCT3);

      funct3 = 3'b110; #10;
      debug(`OR_FUNCT3);

      funct3 = 3'b111; #10;
      debug(`AND_FUNCT3);

      funct3 = 3'b001; #10;
      debug(`ADD_FUNCT3);

      ALUOp = 2'b11; #10;
      debug(`ADD_FUNCT3);
      
   end

endmodule
