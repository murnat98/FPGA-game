module object
(
	input clk,
	input rst,
	input [10:0] random_number,
	output reg [10:0] object_position
);

parameter UNDEFINED_POSITION = 1000;

reg [31:0] timer = 0;

always @(posedge clk)
begin
	if (rst)
	begin
		timer           <= 0;
		object_position <= UNDEFINED_POSITION;
	end
	else
	begin
		if (timer)
		begin
			timer <= timer + 1;
			object_position <= UNDEFINED_POSITION;
		end
		else
		begin
			timer <= 1;
			object_position <= UNDEFINED_POSITION;
		end
	end
end

endmodule
