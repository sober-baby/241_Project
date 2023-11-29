module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   //

	
	wire loadX;
	wire loadYC;
	wire loadB;
	wire Plot;
	wire[7:0]blackX;
	wire[6:0]blackY;
	wire[4:0]area;
	
	control cc(iClock, iResetn, iPlotBox, iBlack, iLoadX, blackX, blackY, area,
	loadX, loadYC, loadB, Plot, oDone, oPlot);
	
	datapath dd(iClock, iResetn, loadX, loadYC, loadB, oPlot, iColour, iXY_Coord, 
	oX, blackX, oY, blackY, oColour, area);
	
endmodule 


///Control Module

module control(

	input iClock,
	input iResetn,
    input iPlotBox,
    input iBlack,
	input iLoadX,
	input [7:0] blackX,
	input [6:0] blackY,
	input [4:0] area,
	 
    output reg load_X, 
	output reg load_YC,
	output reg load_B,
	output reg plot,
    output reg done, 
	output reg oPlot
   );
	
	
	
	
	parameter X_SCREEN_PIXELS = 8'd160;
    parameter Y_SCREEN_PIXELS = 7'd120;
	 
	 
	reg [2:0] currentState, nextState;
	 
	localparam 
					State_A        = 3'd0,  ///load x
					WAIT_A           = 3'd1,
					State_B        = 3'd2,  /// load y and c
					WAIT_B	         = 3'd3,
					State_C        = 3'd4,  /// draw
					BLACK            = 3'd5,  /// all black
					DONE             = 3'd6;  /// return odone

    // Next state logic aka our state table
    always@(posedge iClock)
    begin
            case (currentState)
				
			
                State_A: nextState = iLoadX ? WAIT_A : State_A;
					 WAIT_A: nextState = iLoadX ? WAIT_A : State_B;
					 
                State_B: nextState = iPlotBox ? WAIT_B : State_B;
					 WAIT_B: nextState = iPlotBox ? WAIT_B : State_C;
					 
                State_C: begin
								if(area == 5'd15)  // loop unitl get 4x4
									nextState = DONE;
								else
									nextState = State_C;
							  end
							  
					 BLACK: begin
								if(blackX == X_SCREEN_PIXELS - 1 && blackY == Y_SCREEN_PIXELS - 1) // loop until draw all area
									nextState = DONE;
								else
									nextState = BLACK;
							  end
					 
					 DONE: nextState = State_A;
								 
			 
            default:     nextState = State_A;
        endcase
    end 
	 
	 
	always@(posedge iClock)
		
		///Setting different stages of loads
		begin: enable_signals
		
			load_X <= 1'b0;
			load_YC <= 1'b0;
			load_B <= 1'b0;
			
			
			if ( iBlack == 1 || iLoadX == 1)
				plot <= 1'b0;
				done <= 1'b0;
				oPlot <= 0;
			
			
			case (currentState)
			
				State_A:
				begin
					load_X <= 1'b1;
					oPlot <= 1'b0;
					plot <= 1'b0;
					
				end
				
				State_B:
				begin
					load_YC <= 1'b1;
					plot <= 1'b0;
					
				end
				
				State_C:
				begin
					plot <= 1'b1;
					oPlot <= 1'b1;
					
				end
				
				BLACK:
				begin
					load_B <= 1'b1;
					oPlot <= 1'b1;
					
				end
				
				DONE:
				begin
					done <= 1'b1;
					
				end
		
			endcase
		end 
		

	always@(posedge iClock)
	
		///FSM 
		begin: FSM
			if(!iResetn)
				currentState <= State_A;
				
			if (iBlack)
				currentState <= BLACK;
	
			else 
				currentState <= nextState;
				
		end 
		
endmodule


///Data Path Module

module datapath(


	input iClock,
	input iResetn,
	input loadX, 
	input loadYC, 
	input loadB, 
	input oPlot,
	input [2:0] iColour,
	input [6:0] iXY_Coord,
	 
	output reg [7:0] oX, 
	output reg [7:0] blackX,
	output reg [6:0] oY, 
	output reg [6:0] blackY,
	output reg [2:0] oColour,
	output reg [4:0] area
	);
	
	/// Parameters
	parameter X_SCREEN_PIXELS = 8'd160;
    parameter Y_SCREEN_PIXELS = 7'd120;
	
	
	/// X,Y and Colour
	reg [7:0] x_loc;
	reg [6:0] y_loc;
	reg [2:0] Colour;
	
	always@(posedge iClock)
		begin
			if (!iResetn) 
				begin
					x_loc <= 8'b0;
					y_loc <= 7'b0;
					Colour <= 3'b0;
					area <= 5'b0;
				end
				
			///Loading X cord
			else
				begin
					if (loadX)
						begin
							x_loc[7] <= 1'b0;
							x_loc[6:0] <= iXY_Coord;
						end
					
					///Loading Y cord
					if (loadYC)
						begin
							y_loc <= iXY_Coord;
							Colour <= iColour;
						end
					
					///Plot 
					if (oPlot)
						begin
							if (area == 5'd16)
								begin
									area <= 5'd0;
								end
								
							else 
								begin
									area <= area + 1;
								end 
								
							oX <= x_loc + area[1:0];
							oY <= y_loc + area[3:2];
							oColour <= Colour;
							
						end
					///Load Black
					if (loadB)
						begin
							oX <= blackX;
							oY <= blackY;
							oColour <= 3'b000;
						end
				end
					
		end
	
	
	///Drawing Black Screen
	always@(posedge iClock)
		begin
			if (!iResetn) 
				begin
					blackX <= 8'b0;
					blackY <= 7'b0;
				end
				
			if ( blackX == X_SCREEN_PIXELS-1&& blackY == Y_SCREEN_PIXELS-1)
				begin
					blackX <= 8'b0;
					blackY <= 7'b0;
				end
			
			else if ( blackX == X_SCREEN_PIXELS-1)
				begin
					blackX <= 8'b0;
					blackY <= blackY+1;
				end
				
			if (loadB)
				begin
					blackX <= blackX+1;
					
				end
		end
endmodule