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
        default: out = {{20{inp[11]}}, inp[11:0]}; // TODO: add more cases
      endcase
   end
endmodule
