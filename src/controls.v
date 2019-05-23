module controls
(
	input clk,
	input rst,
	input key_left,
	input key_right,
	output reg [1:0] move
);

/*
	move = 0, if key_right is pressed (move down the plane),
	move = 1, if key_left is pressed (move up the plane),
	move = 2, if the action is undefined.
*/

reg key_left_r;
reg key_left_rr;
reg key_right_r;
reg key_right_rr;
reg left_pushed;
reg right_pushed;

always @(posedge clk)
begin
	if (rst)
	begin
		key_left_r   <= 1;
		key_left_rr  <= 1;
		key_right_r  <= 1;
		key_right_rr <= 1;
		left_pushed  <= 0;
		right_pushed <= 0;
	end
	else
	begin
		key_left_r   <= key_left;
		key_left_rr  <= key_left_r;
		key_right_r  <= key_right;
		key_right_rr <= key_right_r;

		left_pushed  <= key_left_rr  & ~key_left_r;
		right_pushed <= key_right_rr & ~key_right_r;

		if (left_pushed)
			move <= 2'd1;
		else
			if (right_pushed)
				move <= 2'd0;
			else
				move <= 2'd2;
	end
end

endmodule