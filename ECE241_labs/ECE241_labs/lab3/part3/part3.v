///Part3  moudle
module part3(A, B, Function, ALUout);
	
	parameter N=6;

	input [2*N-1:N] A;
	input [N-1:0] B;
	input [1:0] Function;
	output reg [2*N-1:0]ALUout;
	

	always@ (*)
	begin
		case (Function)
		2'b 00: ALUout = {{(N-1),{1'b0}}, A+B};
		2'b 01: ALUout = |{A,B};
		2'b 10: ALUout = &{A,B};
		2'b 11: ALUout = {A,B};
		default ALUout = {(N+N),{1'b0}};
		endcase
	end
endmodule


