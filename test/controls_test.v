`include "../src/controls.v"
`timescale 1ns/1ns

module controls_test();

task failed_test_dump;
input key_up, key_down, move;
begin
	$display("Test failed!\nkey_up=%d; key_down=%d => move=%d", key_up, key_down, move);
end
endtask

reg key_up, key_down;
wire [1:0] move;

controls cntr_test
(
	.key_up  (key_up),
	.key_down(key_down),
	.move    (move)
);

initial begin
	
	#1;
	key_up = 0;
	key_down = 0;
	if (move != 2'd2) begin
		failed_test_dump(key_up, key_down, move);
	end

	#1;
	key_up = 1;
	key_down = 0;
	if (move != 2'd0) begin
		failed_test_dump(key_up, key_down, move);
	end

	#1;
	key_up = 0;
	key_down = 1;
	if (move != 2'd1) begin
		failed_test_dump(key_up, key_down, move);
	end

	#1;
	key_up = 1;
	key_down = 1;
	if (move != 2'd2) begin
		failed_test_dump(key_up, key_down, move);
	end
	
end

endmodule