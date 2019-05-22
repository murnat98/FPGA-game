module vga_synchronization
(
	input clk,
	input reset, 
	input [10:0] object_position,
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

/*
task draw_square;
input [10:0] posx_start;
input [10:0] posx_end;
input [10:0] posy_start;
input [10:0] posy_end;

begin
	if (h_ctr >= X_START + posx_start && h_ctr <= X_START + posx_end)
	begin
		if (v_ctr >= Y_START + posy_start && v_ctr <= Y_START + posy_end)
		begin
			red   <= 8'd255;
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
endtask
*/
/**
 * Plane draw.
 */

localparam PLANE_POSX_START = 300;
localparam PLANE_POSY_START = 430;
localparam PLANE_POSX_END = 340;
localparam PLANE_POSY_END = 480;

always @(posedge clk)
begin
	// draw_square(PLANE_POSX_START, PLANE_POSX_END, PLANE_POSY_START, PLANE_POSY_END);
	if (!reset)
	begin
		if (h_ctr >= X_START + PLANE_POSX_START && h_ctr <= X_START + PLANE_POSX_END)
		begin
			if (v_ctr >= Y_START + PLANE_POSY_START && v_ctr <= Y_START + PLANE_POSY_END)
			begin
				red   <= 8'd255;
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
end

/**
 * object position.
 */
 
reg [10:0] y_cntr;
reg draw_permit;

localparam OBJECT_WIDTH       = 50;
localparam OBJECT_HEIGHT      = 50;
localparam UNDEFINED_POSITION = 1000;
 
always @(posedge clk)
begin
	if (reset)
	begin
		y_cntr <= 0;
		draw_permit <= 0;
	end
	else
	begin
		if (object_position != UNDEFINED_POSITION || draw_permit)
		begin
			draw_permit <= 1;
	
			// draw_square(object_position, object_position + OBJECT_WIDTH, y_cntr, y_cntr + OBJECT_HEIGHT);
			if (h_ctr >= X_START + object_position && h_ctr <= X_START + object_position + OBJECT_WIDTH)
			begin
				if (v_ctr >= Y_START + y_cntr && v_ctr <= Y_START + y_cntr + OBJECT_HEIGHT)
				begin
					red   <= 8'd255;
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
	
			y_cntr <= y_cntr + 1;
		
			if (y_cntr > DV_TIME)
			begin
				y_cntr <= 0;
				draw_permit <= 0;
			end	
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
