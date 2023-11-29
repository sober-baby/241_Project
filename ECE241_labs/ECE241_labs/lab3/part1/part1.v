`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display



module FA(a, b, c_in, s,  c_out);
	input a,b,c_in;
	output s,c_out;
	assign s = a^b^c_in;
	assign c_out = (a&b)|(a&c_in)|(b&c_in);
endmodule

module part1(a, b, c_in, s,  c_out);
	input [7:4] a;
	input [3:0] b;
	input c_in;
	
	output [3:0] s;
	output [9:6] c_out;

	FA U0 (a[4],b[0],c_in,s[0],c_out[6]);
	FA U1 (a[5],b[1],c_out[6],s[1],c_out[7]);
	FA U2 (a[6],b[2],c_out[7],s[2],c_out[8]);
	FA U3 (a[7],b[3],c_out[8],s[3],c_out[9]);
endmodule