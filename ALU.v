module ALU (clk, rst, srcAE, srcBE, ALUControlE, out);
`include "constants.v"
   input clk;
   input  rst;
   input  [WORD_SIZE-1:0]      srcAE;
   input  [WORD_SIZE-1:0]      srcBE;
   input [2:0] 		      ALUControlE;
   output reg [WORD_SIZE-1:0] out;
      // TODO: add Zero flag

    always @(posedge clk or negedge rst)begin
      case (ALUControlE)
	ADD_FUNCT3: out <= srcAE + srcBE;
        SUB_FUNCT3: out <= srcAE - srcBE;
        MUL_FUNCT3: out <= srcAE * srcBE;
        AND_FUNCT3: out <= srcAE & srcBE;
        OR_FUNCT3:  out <= srcAE | srcBE;
        default: out = '0;
      endcase
   end
endmodule


