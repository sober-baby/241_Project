///FA moudle
module FA(a, b, c_in, s,  c_out);
	input a,b,c_in;
	output s,c_out;
	assign s = a^b^c_in;
	assign c_out = (a&b)|(a&c_in)|(b&c_in);
endmodule

///Adder moudle
module adder(a, b, c_in, s,  c_out);
	input [7:4] a;
	input [3:0] b;
	input c_in;
	
	output [7:0] s;
	output [9:6] c_out;

	FA U0 (a[4],b[0],c_in,s[0],c_out[6]);
	FA U1 (a[5],b[1],c_out[6],s[1],c_out[7]);
	FA U2 (a[6],b[2],c_out[7],s[2],c_out[8]);
	FA U3 (a[7],b[3],c_out[8],s[3],c_out[9]);
	assign s[4] = c_out[9];
	assign s[5] = 0;
	assign s[6] = 0;
	assign s[7] = 0;
	
endmodule
///Part2  moudle
module part2(A, B, Function, ALUout);
	input [7:4] A;
	input [3:0] B;
	input [1:0] Function;
	output reg [7:0]ALUout;
	
	wire [7:0] xx;
	adder u0(A, B, 0, xx);
	
	always@ (*)
	begin
		case ( Function )
		2'b 00: ALUout = xx[7:0];
		2'b 01: ALUout = |{A,B};
		2'b 10: ALUout = &{A,B};
		2'b 11: ALUout = {A,B};
		default ALUout = 8'b00000000;
		endcase
	end
endmodule

