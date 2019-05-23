module lfsr
(
	input rst,
	input clk,
	output reg [8:0] out
);

wire linear_feedback;

assign linear_feedback = !(out[8] ^ out[3]);

always @(posedge clk)
begin
	if (rst)
	begin
		out <= 0;
	end
	else
	begin
		out <= {out[7:0], linear_feedback};
	end
end

endmodule
