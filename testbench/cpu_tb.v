module cpu_tb();
	reg clk;

	parameter CYCLE = 100;

	cpu CPU0(
		.clk(clk)
	);

	initial clk <= 0;
	always #(CYCLE/2) clk <= ~clk;

endmodule