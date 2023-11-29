module part2#(parameter CLOCK_FREQUENCY = 2)(ClockIn, Reset, Speed, CounterValue);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	
	///Condition where speed zero is entered
	wire [3:0] a0;
	///Condition Where other speed are entered
	wire [3:0] a1;
	///Choice of final display case
	reg [3:0] a_final;
	
	RateDivider_case0 b(ClockIn, Reset, a0);
	RateDivider_case1# (.CLOCK_FREQUENCY(CLOCK_FREQUENCY))a3(ClockIn, Reset, Speed, a1);
	
	
	always @(*)
	begin
		if (Speed == 0)
			a_final <= a0;
		else 
			a_final <= a1;
	end
		
		
	DisplayCounter c(ClockIn, Reset, a_final, CounterValue);	
	
endmodule

///Zero Case
module RateDivider_case0(ClockIn, Reset, Enable);
	input ClockIn;
	input Reset;
	output reg Enable;
	reg [26:0] count;
	
	
	
	always @(ClockIn)
	begin
		
		if((Reset == 1) || (count == 0))
			begin
				Enable <= ClockIn; 
			end
		else
			begin
				count <= count - 1;
			end
		
	end

endmodule

///All other Cases
module RateDivider_case1# (parameter CLOCK_FREQUENCY = 2) (ClockIn, Reset, Speed, Enable);
	input ClockIn;
	input Reset;
	input [1:0] Speed;
	output reg Enable;
	
	reg [26:0] count;
	
	always @(posedge ClockIn)
	begin
		
		if((Reset == 1) || (count == 0))
			begin
			///Give initial Value of 1 to zero case
				if (Speed == 2'b00)
					count <= 1;
				if (Speed == 2'b01)
					count <= CLOCK_FREQUENCY-1;
				if (Speed == 2'b10)
					count <= (2*CLOCK_FREQUENCY)-1;
				if (Speed == 2'b11)
					count <= (4*CLOCK_FREQUENCY)-1;
			end
		else
			begin
				count <= count - 1;
			end
	end
	
	///assigning output
	always @(*)
	begin
		if (count == 0)
			begin
				Enable <= 1;
			end
		else 
			begin 
				Enable <= 0;
			end
	end
endmodule 

module DisplayCounter(Clock, Reset, EnableDC, CounterValue);
	input Clock;
	input Reset;
	input EnableDC;
	output reg [3:0] CounterValue;
	
	always@ (posedge Clock)		
		begin
			if (Reset == 1'b1) 
				CounterValue  <= 1'b0;
			if (EnableDC == 1'b1) 
				CounterValue <= CounterValue + 1;
		end
endmodule


	