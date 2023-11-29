module part1 (Clock, Enable, Reset, CounterValue);
	input Clock;
	input Enable;
	input Reset;
	output [7:0] CounterValue;
	
	///Connection between output and and Gate
	wire [6:0]andGate;
	
	///Start of T flip Flop
	TFlipFlop a(Enable, Clock, Reset, CounterValue[0]);
	assign andGate[0] = Enable & CounterValue[0];
	
	TFlipFlop b(andGate[0], Clock, Reset, CounterValue[1]);
	assign andGate[1] = andGate[0] & CounterValue[1];
	
	TFlipFlop c(andGate[1], Clock, Reset, CounterValue[2]);
	assign andGate[2] = andGate[1] & CounterValue[2];
	
	TFlipFlop d(andGate[2], Clock, Reset, CounterValue[3]);
	assign andGate[3] = andGate[2] & CounterValue[3];
	
	TFlipFlop e(andGate[3], Clock, Reset, CounterValue[4]);
	assign andGate[4] = andGate[3] & CounterValue[4];
	
	TFlipFlop f(andGate[4], Clock, Reset, CounterValue[5]);
	assign andGate[5] = andGate[4] & CounterValue[5];
	
	TFlipFlop g(andGate[5], Clock, Reset, CounterValue[6]);
	assign andGate[6] = andGate[5] & CounterValue[6];
	
	TFlipFlop h(andGate[6], Clock, Reset, CounterValue[7]);
	
endmodule

///T Flip Flop
module TFlipFlop(d, clk,reset,Q);
	input clk;
	input reset; 
	input d;
	output reg Q;
	
	
	always@ (posedge clk)
		begin
			if (reset) Q <= 1'b 0 ;
			else Q <= Q ^ d ;
		end
endmodule
	