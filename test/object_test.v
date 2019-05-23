`include "../src/object.v"
`include "../src/lfsr.v"
`timescale 1ns/1ns

module object_test();

reg clk = 1'b0, rst = 1'b1;
wire [10:0] random;
wire [10:0] pos;

object object_tst
(
	.clk(clk),
	.rst(rst),
	.random_number(random),
	.object_position(pos)
);


lfsr lfsr_instance
(
	.clk(clk),
	.rst(rst),
	.out(random)
);

always
begin
	#1;
	clk = ~clk;
end

initial
begin
	#10;
	rst <= 1'b0;
end

endmodule
