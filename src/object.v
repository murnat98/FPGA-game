module object
(
	input clk,
	input rst,
	input [31:0] random_number,
	output reg [10:0] object_position
);

parameter UNDEFINED_POSITION = 1000;

reg [31:0] timer = 0;
reg [31:0] fix_rn = 0;

always @(posedge clk)
begin
	if (rst)
	begin
		object_position <= UNDEFINED_POSITION;
	end
	else
	begin
		if (timer)
		begin
			timer <= timer + 1;
			if (timer < fix_rn)
			begin
				timer <= timer + 1;
			end
			else
			begin
				timer <= 0;
				object_position <= random_number[10:0];
			end
		end
		else
		begin
			fix_rn <= random_number;
			timer <= 1;
			object_position <= UNDEFINED_POSITION;
		end
	end
end

endmodule
