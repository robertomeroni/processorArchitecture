`include "constants.v"
`include "controlUnit.v"

module tb_controlUnit;

   reg     [6:0]    Op                                          ;
   reg     [2:0]    funct3                                      ;
   reg              funct7                                      ;
   wire             RegWrite,MemWrite, Jump, Branch, ALUSrc     ;
   wire    [1:0]    ResultSrc, ImmSrc                           ;
   wire    [2:0]    ALUControl                                  ;

   controlUnit controlUnit_dut (
				.Op           (    Op            ),
				.funct3       (    funct3        ),
				.funct7       (    funct7        ),
				.RegWrite     (    RegWrite      ),
				.MemWrite     (    MemWrite      ),
				.Jump         (    Jump          ),
				.Branch       (    Branch        ),
				.ALUSrc       (    ALUSrc        ),
				.ResultSrc    (    ResultSrc     ),
				.ImmSrc       (    ImmSrc        ),
				.ALUControl   (    ALUControl    )
				);

   initial begin
      $dumpfile("db_tb_controlUnit.vcd");
      $dumpvars(0, tb_controlUnit);
      $monitor("Op = %7b, ALUControl = %3b", Op, ALUControl);

      Op = 7'b0110011;
      funct3 = 3'b000;
      funct7 = 1'b0;

   end

endmodule
