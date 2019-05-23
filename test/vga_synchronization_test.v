`include "../src/vga_synchronization.v"
`include "../src/object.v"
`include "../src/lfsr.v"
`timescale 1ns/1ns

module vga_synchronization_test();

reg clk = 0, reset = 1'b1;
wire [7:0] red, green, blue;
wire [10:0] position;
wire h_sync, v_sync, blank_n, sync_n;

vga_synchronization vga
(
	.clk(clk),
	.reset(reset),
	.red(red),
	.green(green),
	.blue(blue),
	.h_sync(h_sync),
	.v_sync(v_sync),
	.blank_n(blank_n),
	.sync_n(sync_n),
	.object_position(position)
);

object object_inst
(
	.clk(clk),
	.rst(reset),
	.random_number(random_number),
	.object_position(position)
);

wire [7:0] out;

lfsr lfsr_inst
(
	.clk(clk),
	.rst(reset),
	.out(random_number)
);

initial
begin
	reset = 1;
	#10;
	reset = 0;
end

always
begin
	#1;
	clk <= ~clk;
end

endmodule