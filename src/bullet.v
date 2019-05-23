module bullet
(
	input clk,
	input rst,
	input key_1,
	output reg bullet
);

reg key_r;
reg key_rr;

always @(posedge clk)
begin
	if (rst)
	begin
		key_r  <= 1;
		key_rr <= 1;
	end
	else
	begin
		key_r  <= key_1;
		key_rr <= key_r;
		bullet <= key_rr & ~key_r;
	end
end

endmodule
