module vga_synchronization
(
	input clk,
	input reset,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	output vga_clk,
	output sync_n,
	output blank_n,
	output h_sync,
	output v_sync
);
endmodule
