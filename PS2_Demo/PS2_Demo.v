
module PS2_Demo (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7

	LED
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;

output		[7:0]	LED;
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

reg[5:0] current_state, next_state;
localparam SELECT_SPEED = 5'd0;
localparam SELECT_SPEED_WAIT = 5'd1;
localparam SELECT_DIFFICULTY = 5'd2;
localparam SELECT_DIFFICULTY_WAIT = 5'd3;
localparam READY_STATE = 5'd4;
localparam GAME_START= 5'd5;
localparam GAME_OVER = 5'd6;


always@(*)
begin: state_table
	case (current_state)
		SELECT_SPEED: next_state = (ps2_key_pressed && (ps2_key_data== 8'h26 || ps2_key_data== 8'h16 || ps2_key_data== 8'h1E)) ? SELECT_SPEED_WAIT : SELECT_SPEED;
		SELECT_SPEED_WAIT: next_state = !(ps2_key_pressed) ? SELECT_DIFFICULTY : SELECT_SPEED_WAIT;
		SELECT_DIFFICULTY: next_state = (ps2_key_pressed && (ps2_key_data== 8'h26 || ps2_key_data== 8'h16 || ps2_key_data== 8'h1E)) ? SELECT_DIFFICULTY_WAIT : SELECT_DIFFICULTY;
		SELECT_DIFFICULTY_WAIT: next_state = !(ps2_key_pressed) ? READY_STATE : SELECT_DIFFICULTY_WAIT;
		READY_STATE: next_state = (ps2_key_pressed && ps2_key_data == 8'h26) ? GAME_START : READY_STATE;
		GAME_START: next_state = !(ps2_key_pressed) ? GAME_OVER : GAME_START;	
		GAME_OVER: next_state = ps2_key_pressed ? SELECT_SPEED : GAME_OVER;
	default: next_state = SELECT_SPEED;
	endcase
end

always @(*)
begin: enable_signals
last_data_received = 8'h00;
	case(current_state)
		SELECT_SPEED: begin
			last_data_received = 8'h01;
		end
		SELECT_SPEED_WAIT: begin
			last_data_received = 8'h02;
		end
		SELECT_DIFFICULTY: begin
			last_data_received = 8'h03;
		end
		SELECT_DIFFICULTY_WAIT: begin
			last_data_received = 8'h04;
		end
		READY_STATE: begin
			last_data_received = 8'h05;
		end
		GAME_START: begin
			last_data_received = 8'h06;
		end
		GAME_OVER: begin
			last_data_received = 8'h07;
		end
	endcase
end

always @(posedge CLOCK_50)
begin: state_FFS
	if(ps2_key_pressed)
		current_state <= next_state;
end


// By default make all our signals 0
   



/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/



//change game level from 1 to 4 by pressing numbers 1 ,2 3, 4 on the keyboard

/*
always @(posedge CLOCK_50)
begin
	if (KEY[0] == 1'b0)
		last_data_received <= 8'h00;
	else if (ps2_key_pressed == 1'b1 && ps2_key_data== 8'h29)
		last_data_received <= ps2_key_data;
	else if (ps2_key_pressed == 1'b1 && ps2_key_data== 8'h16)
		last_data_received <= ps2_key_data;
	else if (ps2_key_pressed == 1'b1 && ps2_key_data== 8'h1E)
		last_data_received <= ps2_key_data;
	else if (ps2_key_pressed == 1'b1 && ps2_key_data== 8'h29)
		last_data_received <= ps2_key_data;
end
*/

/*
always @(posedge CLOCK_50)
begin
    if (KEY[0] == 1'b0)
        last_data_received <= 8'h00;
    else if (ps2_key_pressed == 1'b1)
        last_data_received <= ps2_key_data;

    // Finite State Machine transitions
    case (fsm_state)
        SELECT_SPEED: begin
            if (ps2_key_pressed && (ps2_key_data== 8'h29 || ps2_key_data== 8'h16 || ps2_key_data== 8'h1E)) begin
                case (ps2_key_data)
                    8'h01, 8'h02, 8'h03: fsm_state <= SELECT_DIFFICULTY;
                endcase
            end
        end


        SELECT_DIFFICULTY: begin
            if (ps2_key_pressed && (ps2_key_data== 8'h29 || ps2_key_data== 8'h16 || ps2_key_data== 8'h1E)) begin
                case (ps2_key_data)
                    8'h01, 8'h02, 8'h03: fsm_state <= READY_STATE;
                endcase
            end
        end
        READY_STATE: begin
            if (ps2_key_pressed && (ps2_key_data == 8'h29))  // Assuming spacebar is 8'h29
				//start the game which is to start a timer

        end
    endcase
end

*/

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50			(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX1)
);


endmodule
