`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module v7404 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1;
	input pin3;
	input pin5;
	input pin9;	
	input pin11;
	input pin13;
	
	output pin2;
	output pin4;
	output pin6;
	output pin8;
	output pin10;
	output pin12;	
	
	assign pin2=~pin1;
	assign pin4=~pin3;
	assign pin6=~pin5;
	assign pin8=~pin9;
	assign pin10=~pin11;
	assign pin12=~pin13;

endmodule



module v7408 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);

	input pin1;
	input pin2;
	input pin4;
	input pin5;	
	input pin13;
	input pin12;
	input pin10;
	input pin9;
	
	output pin3;
	output pin6;
	output pin11;
	output pin8;
	
	assign pin3= pin1*pin2;
	assign pin6= pin4*pin5;
	assign pin11= pin13*pin12;
	assign pin8= pin9*pin10;
	

endmodule



module v7432 (pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
	
	input pin1;
	input pin2;
	input pin4;
	input pin5;	
	input pin13;
	input pin12;
	input pin10;
	input pin9;
	
	output pin3;
	output pin6;
	output pin11;
	output pin8;
	
	assign pin3= pin1+pin2;
	assign pin6= pin4+pin5;
	assign pin11= pin13+pin12;
	assign pin8= pin9+pin10;

endmodule



module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
///connect wire
	wire wire1, wire2, wire3;
	
	v7404 not1(
		.pin1(s),
		.pin2(wire1)
	);

	v7408 and1(
		.pin1(wire1),
		.pin2(x),
		.pin3(wire2),
		.pin4(y),
		.pin5(s),
		.pin6(wire3)	
	);
	
	
	v7432 or1(
		.pin1(wire2),
		.pin2(wire3),
		.pin3(m)
	);

endmodule
