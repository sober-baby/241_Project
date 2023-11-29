module part2(Clock, Reset_b, Data, Function, ALUout);
	input Clock;
	input Reset_b;
	input [3:0]Data;
	input [1:0]Function;
	output [7:0]ALUout;

	///ALUtoRegister connects ALU to register
	wire [7:0]ALUtoRegister;
	
	ALU a1(Data, ALUout[3:0], Function, ALUtoRegister, ALUout);
	
	Register r1(Clock, Reset_b, ALUtoRegister, ALUout);
	
endmodule


///ALU Unit
module ALU(A, B, Function, ALUout, MemoryValue);
	input [3:0]B;
	input [3:0]A;
	input [1:0]Function;
	output reg [7:0]ALUout;
	input [7:0]MemoryValue;
	
	///Start of Always Block
	always@ (*)
		begin
		case ( Function )
			2'b 00: ALUout = A+B;
			2'b 01: ALUout = {A*B};
			2'b 10: ALUout = B<<A; 
			2'b 11:  ALUout = MemoryValue;
	//		Hold current value in the Register, i.e.,the register value does not change.
			default : ALUout = 8'b0;
		endcase
	end
endmodule
	
	
/// Register module to store memory
module Register(clk,reset_b,d,q);
	input wire clk;
	input wire reset_b;
	input wire [7:0]d;
	output reg [7:0]q;
	
	always@ (posedge clk)
		begin
			if (reset_b) q <= 1'b 0 ;
			else q <= d ;
		end
endmodule


