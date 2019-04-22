module controls
(
	input key_up,
	input key_down,
	output [1:0] move
);

/*
	move = 0, if key_down is pressed (move down the plane),
	move = 1, if key_up is pressed (move up the plane),
	move = 2, if the action is undefined.
*/

assign move = !key_up   ? (key_down ? 2'd0 : 2'd2) :
	      !key_down ? 2'd1 :
	      2'd2;

endmodule