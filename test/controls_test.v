`include "../src/controls.v"
`timescale 1ns/1ns

module controls_test();

task failed_test_dump;
input key_left, key_right, move;
begin
	$display("Test failed!\nkey_up=%d; key_down=%d => move=%d", key_left, key_right, move);
end
endtask

reg clk = 0, rst;
reg key_left = 1, key_right = 1;
wire [1:0] move;

controls cntr_test
(
	.clk(clk),
	.rst(rst),
	.key_left (key_left),
	.key_right(key_right),
	.move     (move)
);

always
begin
	#1;
	clk = ~clk;
end

initial 
begin
	rst = 1;
	#10; 
	rst = 0;
	#2;
	key_left = 1;
	key_right = 1;
	if (move != 2'd2) begin
		failed_test_dump(key_left, key_right, move);
	end

	#2;
	key_left = 1;
	key_right = 0;
	if (move != 2'd0) begin
		failed_test_dump(key_left, key_right, move);
	end

	#2;
	key_left = 1;
	key_right = 1;
	if (move != 2'd2) begin
		failed_test_dump(key_left, key_right, move);
	end
end

endmodule