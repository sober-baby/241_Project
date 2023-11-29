`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, KEY, SW);
    input [7:0] SW;
	 input [1:0] KEY;
    output [7:0] LEDR;

    part3 yy(
        .A(SW[7:4]),
        .B(SW[3:0]),
        .Function(KEY[1:0]),
        .ALUout(LEDR[7:0])
        );
endmodule



