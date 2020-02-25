module cpu_tb();
	reg clk;
	reg cpu_resetn;
    wire uart_tx;

	parameter CYCLE = 100;

	cpu CPU0(
		.clk(clk),
		.rst_n(cpu_resetn),
		.RsRx(uart_tx)
	);

	initial begin
        #10   	clk     = 1'd0;
                cpu_resetn    = 1'd0;
        #(CYCLE) cpu_resetn = 1'd1;
    end

	always #(CYCLE/2) clk <= ~clk;

endmodule