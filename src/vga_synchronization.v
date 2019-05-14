`define AH_TIME 16
`define BH_TIME 96
`define CH_TIME 48
`define DH_TIME 640
`define AV_TIME 10
`define BV_TIME 2
`define CV_TIME 33
`define DV_TIME 480

module vga_synchronization
(
	input clk,
	input reset,
	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	output sync_n,
	output blank_n,
	output reg h_sync,
	output reg v_sync
);

assign blank_n = 1'b0;
assign sync_n = 1'b0;

reg [10:0] h_ctr = 1'b0;
reg [10:0] v_ctr = 1'b0;

/**
 * horizontal synchronization
 */
always @(posedge clk)
begin
	h_sync <= 1'b1;
	
	if (h_ctr <= AH_TIME + BH_TIME + CH_TIME + DH_TIME)
	begin
		if (h_ctr <= AH_TIME + BH_TIME && h_ctr > AH_TIME)
		begin
			h_sync <= 1'b0;
		end

		if (h_ctr <= AH_TIME + BH_TIME + CH_TIME && h_ctr > AH_TIME + BH_TIME)
		begin
			h_sync <= 1'b1;
		end

		if (h_ctr > AH_TIME + BH_TIME + CH_TIME)
		begin
			red   <= 8'd255;
			green <= 8'd0;
			blue  <= 8'd0;
		end
	end
	else
	begin
		h_ctr <= 1'b0;
	end

	h_ctr <= h_ctr + 1;
end

always (@posedge h_sync)
begin
	v_sync <= 1'b1;

	if (v_ctr <= AV_TIME + BV_TIME + CV_TIME + DV_TIME)
	begin
		if (v_ctr <= AV_TIME + BV_TIME && v_ctr > AV_TIME)
		begin
			v_sync <= 1'b0;
		end

		if (v_ctr <= AV_TIME + BV_TIME + CV_TIME && v_ctr > AV_TIME + BV_TIME)
		begin
			v_sync <= 1'b1;
		end

	end
	else
	begin
		v_ctr <= 1'b0;
	end
	
	v_ctr <= v_ctr + 1;
end

endmodule
