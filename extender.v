`include "constants.v"

module extender(
		input [1:0] ImmSrc,
		input [24:0] inp,
		output reg [31:0] out
		);

   always @ (ImmSrc, inp) begin
      $display("inp = %25b", inp);
      case (ImmSrc)
        2'b00: out = {{20{inp[24]}}, inp[24:13]}; // lw
        2'b01: out = {{20{inp[24]}}, inp[24:18], inp[4:0]}; // sw
	2'b10: out = {{20{inp[24]}}, inp[0], inp[23:18], inp[4:1], 1'b0}; // br
	2'b11: out = {{12{inp[24]}}, inp[12:5], inp[13], inp[23:14], 1'b0}; // j
        default: out = 32'bx; // TODO: add more cases
      endcase
   end
endmodule
