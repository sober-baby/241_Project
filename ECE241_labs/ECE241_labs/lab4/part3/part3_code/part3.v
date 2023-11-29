module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	
	input clock;
	input reset;
	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	input [3:0]Data_IN;
	output [3:0]Q;

	///ALUtoRegister connects ALU to register
	wire [7:0]ALUtoRegister;
	
	ALU a1(ParallelLoadn, RotateRight, ASRight, Data_IN, ALUtoRegister, Q);
	
	Register r1(clock, reset, ALUtoRegister, Q);
	
endmodule


///ALU Unit
module ALU(ParallelLoadn, RotateRight, ASRight, Data_IN, out, memory);

	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	input [3:0]Data_IN;
	input [3:0]memory;
	output reg [3:0]out;
	
	///Start of Always Block
	always@ (*)
		begin
			if (ParallelLoadn == 1)///Use Memopry Data
				out = memory;
				if (RotateRight == 0)//Rotate Left
					out = {memory[2:0], memory[3]};
				if (RotateRight == 1)//Rotate Right
					out = {memory[0], memory[3:1]};
				
			if (ParallelLoadn == 0)///Use New Input Value
				out = Data_IN;
	end
endmodule
	
	
/// Register module to store memory
module Register(clk,reset,d,q);
	input wire clk;
	input wire reset;
	input wire [3:0]d;
	output reg [3:0]q;
	
	always@ (posedge clk)
		begin
			if (reset) q <= 1'b 0 ;
			else q <= d ;
		end
endmodule


