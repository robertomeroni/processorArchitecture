`include "constants.v"

module extender(
    input [1:0] ImmSrc,
    input [24:0] inp,
    output [31:0] out,
    );
    
    case (ImmSrc)
        2'b00: assign out= {{20{inp[11]}},inp[11:0]}; // lw
        2'b01: assign out= {{20{inp[24]}},inp[24:18],inp[4:0]}; // sw
        default: assign out= {{20{inp[11]}},inp[11:0]}; // TODO: add more cases
    endcase