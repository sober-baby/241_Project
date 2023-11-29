`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, KEY, SW);
	input [9:0] SW;
	input [1:0] KEY;
	output [9:0] LEDR;

	part2 yy(
	  .ClockIn(KEY[0]),
	  .Reset(KEY[1]),
	  .Speed(SW[1:0]),
	  .CounterValue(LEDR[7:0])
	  );
endmodule





