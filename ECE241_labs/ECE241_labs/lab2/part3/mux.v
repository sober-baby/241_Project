`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(HEX0, SW);
    input [3:0] SW;
    output [6:0] HEX0;

    hex_decoder u0(
        .display(HEX0),
        .c(SW),
        );
endmodule
