module lfsr
(
	input rst,
	input clk,
	output reg [10:0] out
);

always @(posedge clk)
begin
	if (rst)
	begin
		out <= 0;
	end
	else
	begin
		out <= 11'd300;
	end
end

endmodule
