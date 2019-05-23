module vga_synchronization
(
	input clk,
	input reset, 
	input [10:0] object_position,
	input [1:0] move,
	input bullet,
	output reg [7:0] red,
	output reg [7:0] green,
	output reg [7:0] blue,
	output sync_n,
	output blank_n,
	output reg h_sync,
	output reg v_sync
);

parameter AH_TIME = 16;
parameter BH_TIME = 96;
parameter CH_TIME = 48;
parameter DH_TIME = 640;
parameter AV_TIME = 10;
parameter BV_TIME = 2;
parameter CV_TIME = 33;
parameter DV_TIME = 480;

parameter X_START = BH_TIME + CH_TIME;
parameter Y_START = BV_TIME + CV_TIME;

parameter TOTAL_H_TIME = AH_TIME + BH_TIME + CH_TIME + DH_TIME;
parameter TOTAL_V_TIME = AV_TIME + BV_TIME + CV_TIME + DV_TIME;

assign blank_n = 1'b1;
assign sync_n  = 1'b0;

reg [10:0] h_ctr = 11'b0;
reg [10:0] v_ctr = 11'b0;


/**
 * Plane draw.
 */

localparam PLANE_POSX_START = 300;
localparam PLANE_POSY_START = 430;
localparam PLANE_POSX_END = 340;
localparam PLANE_POSY_END = 480;

localparam BULLET_POSX_START = 25;
localparam BULLET_POSX_END   = 35;
localparam BULLET_HEIGHT     = 10;

localparam BULLET_START_POSITION_Y = PLANE_POSY_START - BULLET_HEIGHT;

reg [10:0] y_cntr;
reg [10:0] y_cntr_bullet;
reg [7:0] velocity;
reg [10:0] object_position_save;
reg [10:0] plane_offset_x;
reg [10:0] offset;
reg game_over;
reg draw_permit;
reg bullet_draw_permit;

localparam OBJECT_WIDTH       = 50;
localparam OBJECT_HEIGHT      = 50;
localparam OBJECT_VELOCITY    = 5;
localparam UNDEFINED_POSITION = 1000;
localparam PLANE_VELOCITY     = 40;

always @(posedge clk)
begin
	if (reset)
	begin
		velocity             <= 0;
		y_cntr               <= 0;
		y_cntr_bullet        <= BULLET_START_POSITION_Y;
		draw_permit          <= 0;
		object_position_save <= 0;
		plane_offset_x       <= PLANE_POSX_START;
		offset               <= PLANE_POSX_START;
		game_over            <= 0;
		bullet_draw_permit   <= 0;
	end
	else
	begin
		if (plane_offset_x <= object_position_save)
		begin
			if (plane_offset_x + PLANE_POSX_END - PLANE_POSX_START >= object_position_save &&
				 PLANE_POSY_START <= y_cntr + OBJECT_HEIGHT)
			begin
				game_over <= 1;
			end
			else
			begin
				game_over <= 0;
			end
		end
		else
		begin
			if (object_position_save + OBJECT_WIDTH >= plane_offset_x &&
			    PLANE_POSY_START <= y_cntr + OBJECT_HEIGHT)
			begin
				game_over <= 1;
			end
			else
			begin
				game_over <= 0;
			end
		end
		
		if (h_ctr >= X_START + plane_offset_x && h_ctr <= X_START + PLANE_POSX_END - PLANE_POSX_START + plane_offset_x && 
		    v_ctr >= Y_START + PLANE_POSY_START && v_ctr <= Y_START + PLANE_POSY_END)
		begin
			red   <= 8'd255;
			green <= 8'd0;
			blue  <= 8'd0;
		end
		else
		begin
			if (bullet_draw_permit)
			begin
				if (h_ctr >= X_START + plane_offset_x + BULLET_POSX_START && 
				    h_ctr <= X_START + plane_offset_x + BULLET_POSX_END)
				begin
					if (v_ctr >= Y_START + y_cntr_bullet && v_ctr <= Y_START + y_cntr_bullet + BULLET_HEIGHT)
					begin
						red   <= 8'd255;
						green <= 8'd255;
						blue  <= 8'd255;
					end
					else
					begin
						red   <= 8'd0;
						green <= 8'd0;
						blue  <= 8'd0;
					end
				end
				else
				begin
					red   <= 8'd0;
					green <= 8'd0;
					blue  <= 8'd0;
				end
			end
			
			if (draw_permit)
			begin
				if (h_ctr >= X_START + object_position_save && h_ctr <= X_START + object_position_save + OBJECT_WIDTH)
				begin
					if (v_ctr >= Y_START + y_cntr && v_ctr <= Y_START + y_cntr + OBJECT_HEIGHT)
					begin
						red   <= 8'd0;
						green <= 8'd255;
						blue  <= 8'd0;
					end
					else
					begin
						red   <= 8'd0;
						green <= 8'd0;
						blue  <= 8'd0;
					end
				end
				else
				begin
					red   <= 8'd0;
					green <= 8'd0;
					blue  <= 8'd0;
				end
			end
			else
			begin
				red   <= 8'd0;
				green <= 8'd0;
				blue  <= 8'd0;
			end
		end
		
		if (!velocity && !h_ctr && draw_permit && !game_over)
		begin
			y_cntr <= y_cntr + OBJECT_VELOCITY;
			
			if (y_cntr > DV_TIME)
			begin
				y_cntr <= 0;
				draw_permit <= 0;
			end
		end
		
		if (!velocity && !h_ctr && bullet_draw_permit && !game_over)
		begin
			y_cntr_bullet <= y_cntr_bullet - 1;
			
			if (y_cntr_bullet <= 1)
			begin
				y_cntr_bullet <= BULLET_START_POSITION_Y;
				bullet_draw_permit <= 0;
			end
		end
		
		velocity <= velocity + 1;
		
		if (offset <= PLANE_VELOCITY)
		begin
			offset <= offset + PLANE_VELOCITY;
		end
		
		if (offset >= DH_TIME - PLANE_VELOCITY)
		begin
			offset <= offset - PLANE_VELOCITY;
		end
		
		case (move)
			2'd0: offset <= offset + PLANE_VELOCITY;
			2'd1: offset <= offset - PLANE_VELOCITY;
		endcase
		
		if (!h_ctr && !game_over)
		begin
			plane_offset_x <= offset;
		end
		
		if (object_position != UNDEFINED_POSITION && !game_over)
		begin
			draw_permit <= 1;
			
			object_position_save <= object_position;
		end
		
		if (bullet && !game_over)
		begin
			bullet_draw_permit <= 1;
		end
	end
end

/**
 * Horizontal synchronization
 */
always @(posedge clk)
begin
	if(reset)
		begin
			h_ctr  <= 0;
			h_sync <= 0;
		end
	else
	begin
		if (h_ctr < TOTAL_H_TIME)
			h_ctr <= h_ctr + 1;
		else
			h_ctr <= 0;
						  
		if (h_ctr < BH_TIME)
			h_sync	<=	0;
		else
			h_sync	<=	1;
	end
end

/**
 * Vertical synchronization
 */
always @(posedge clk)
begin
	if(reset)
	begin
		v_ctr  <= 0;
		v_sync <= 0;
	end
	else
	begin
		if(h_ctr == 0)
		begin
			if (v_ctr < TOTAL_V_TIME)
				v_ctr <= v_ctr + 1;
			else
				v_ctr <= 0;
									 
			if (v_ctr < BV_TIME)
				v_sync <= 0;
			else
					v_sync <= 1;
			end
		end
    end
endmodule
