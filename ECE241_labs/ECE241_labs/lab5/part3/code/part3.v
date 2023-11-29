module part3#(parameter CLOCK_FREQUENCY=50000000)(ClockIn, Reset, Start, Letter, DotDashOut, NewBitOut);
	input wire ClockIn;
	input wire Reset;
	input wire Start;
	input wire [2:0] Letter;
	output wire DotDashOut;
	output wire NewBitOut;
	
	wire [11:0] code;

	
	LetterToCode a(Letter, code);
	Rate_Divider#(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) b (ClockIn, Reset, Start, NewBitOut);
	shift c(ClockIn, NewBitOut, Reset, Start, code, DotDashOut);
	

endmodule

///Shifter
module shift(ClockIn, NewBitIn, Reset, Start, code, Output);
	input ClockIn;
	input Reset;
	input NewBitIn;
	input Start;
	input [11:0]code;
	output Output;
	
	reg [11:0]data;
	
	
	always@ (posedge ClockIn)		
		begin
			if (Reset == 1) 
				data <= 12'b0;
				
			else if (Start == 1)
				data <= code;
				
			else if (NewBitIn == 1) 
				
			///Shift
				data <= {data[10:0], 1'b0};
					
		end
	assign Output = data[11];
endmodule



///Rate Divider
module Rate_Divider#(parameter CLOCK_FREQUENCY = 50000000) (ClockIn, Reset, Start, NewBitOut);
	input ClockIn;
	input Start;
	input Reset;
	output NewBitOut;
	reg [26:0] count;

	
	always @(posedge ClockIn)
	begin
		if (Reset)
			count <= 0;		
		if((Start == 1) || (count == 0))
			begin
					count <= (0.5*CLOCK_FREQUENCY);
			end
		else
			begin
				count <= count - 1;
			end
	end
	assign NewBitOut = (count == 0) ? 1:0;
	
endmodule 





///Letter Decoder
module LetterToCode(Letter, code);
	input[2:0] Letter;
	output reg [11:0]code;
	
	always@(*)
		begin
			case(Letter)
			3'b 000: code = 12'b 101110000000;
			3'b 001: code = 12'b 111010101000;
			3'b 010: code = 12'b 111010111010;
			3'b 011: code = 12'b 111010100000;
			3'b 100: code = 12'b 100000000000;
			3'b 101: code = 12'b 101011101000;
			3'b 110: code = 12'b 111011101000;
			3'b 111: code = 12'b 101010100000;
			endcase
		end
endmodule

