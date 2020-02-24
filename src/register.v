module register(clk, rs1, rs2, rd, w_data, reg_write, r_data1, r_data2);
	input clk;
	input [4:0] rs1;
	input [4:0] rs2;
	input [4:0] rd;
	input [31:0] w_data;
	input reg_write;
	output [31:0] r_data1;
	output [31:0] r_data2;

	reg [31:0] mem [0:31];
	// reg [4:0] r_addr1;
	// reg [4:0] r_addr2;

	initial mem[0] <= 0;

	// always @(posedge clk) begin
	// 	r_addr1 <= r_reg1;
	// 	r_addr2 <= r_reg2;
	// 	if(reg_write && w_reg != 0) mem[w_reg] <= w_data;
	// end
    // 
	// assign r_data1 = mem[r_addr1];
	// assign r_data2 = mem[r_addr2];

	always @(posedge clk) begin
	    if(reg_write && rd != 0) mem[rd] <= w_data;
    end

	assign r_data1 = mem[rs1];
	assign r_data2 = mem[rs2];
endmodule