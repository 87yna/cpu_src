module fetch(clk, pc, instruction);
	input clk;
	input [31:0] pc;
	output [31:0] instruction;

	reg [31:0] mem [0:24575];
	// reg [31:0] addr;

	initial begin
		// $readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/tests/IntRegReg/code.hex", mem);
		// $readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/tests/IntRegImm/code.hex", mem);
		// $readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/tests/ControlTransfer/code.hex", mem);
		// $readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/tests/ZeroRegister/code.hex", mem);
		$readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/tests/LoadAndStore/code.hex", mem);
	end

	// always @(posedge clk) begin
    //     addr <= pc / 4;
    // end

	// assign instruction = mem[addr];
	assign instruction = mem[pc/4];

endmodule