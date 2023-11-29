`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, KEY, SW);
    input [2:0] SW;
	 input [1:0] KEY;
    output [9:0] LEDR;

    part1 yy(
        .clock(KEY[0]),
        .resetn(SW[0]),
        .w(SW[1]),
        .z(LEDR[9]),
		  .CurState(LEDR[3:0])
        );
endmodule


