module main
(
	input clk50,
	input main_reset,
	output [7:0] main_red,
	output [7:0] main_green,
	output [7:0] main_blue,
	output main_sync_n,
	output main_blank_n,
	output main_h_sync,
	output main_v_sync,
	output vga_clk25
);

wire clk25;

assign vga_clk25 = clk25;

pll pll_module
(
	.inclk0(clk50),
	.c0(clk25)
);

vga_synchronization vga
(
	.clk(clk25),
	.reset(main_reset),
	.red(main_red),
	.green(main_green),
	.blue(main_blue),
	.sync_n(main_sync_n),
	.blank_n(main_blank_n),
	.h_sync(main_h_sync),
	.v_sync(main_v_sync)
);

endmodule