module cpu(clk, rst_n, RsRx);
	input clk, rst_n;
	output RsRx;
	reg [31:0] pc;
	reg enable;
	wire [31:0] instruction, w_data, r_data1, r_data2, alu_result, imm, npc, mem_data;
	wire [3:0] alu_ctrl;
	wire alu_src1, alu_src2, branch, zero, is_jal, is_lui, reg_write, mem_write, mem_to_reg;

	wire [7:0] uart_IN_data;
    wire uart_we;
    wire uart_OUT_data;
	
	wire [31:0] hc_OUT_data;

	initial begin
		pc <= 32'h0000_8000;
		enable <= 0;
	end

    always @(posedge clk) begin
		if(enable) pc <= npc;
	end
	always @(posedge rst_n) enable <= 1;

	fetch F0(
		.pc(pc),
		.instruction(instruction)
	);

	decode D0(
		.instruction(enable ? instruction : 32'h00000033),
		.imm(imm),
		.alu_ctrl(alu_ctrl),
		.alu_src1(alu_src1),
		.alu_src2(alu_src2),
		.branch(branch),
		.is_jal(is_jal),
		.is_lui(is_lui),
		.reg_write(reg_write),
		.mem_write(mem_write),
		.mem_to_reg(mem_to_reg)
	);

	register REG0(
		.clk(clk),
		.rs1(is_lui ? 5'b0 : instruction[19:15]),
		.rs2(instruction[24:20]),
		.rd(instruction[11:7]),
		.w_data(w_data),
		.reg_write(reg_write),
		.r_data1(r_data1),
		.r_data2(r_data2)
	);

	alu ALU0(
		.op1(alu_src1 ? pc : r_data1),
		.op2(alu_src2 ? r_data2 : imm),
		.alu_ctrl(alu_ctrl),
		.branch(branch),
		.result(alu_result),
		.zero(zero)
	);

	memory MEM0(
		.clk(clk),
		.w_data(r_data2),
		.w_addr(mem_write ? alu_result : 0),
		.r_addr(mem_to_reg ? alu_result : 0),
		.funct3(instruction[14:12]),
		.mem_write(mem_write),
		.r_data(mem_data),
		.uart_OUT_data(uart_OUT_data),
		.uart_IN_data(uart_IN_data),
		.uart_we(uart_we),
		.uart_tx(RsRx),
		.hc_OUT_data(hc_OUT_data)
	);

	write_back W0(
		.pc(pc),
		.alu_result(alu_result),
		.imm(imm),
		.mem_data(mem_data),
		.zero(zero),
		.is_jal(is_jal),
		.mem_to_reg(mem_to_reg),
		.w_data(w_data),
		.npc(npc)
	);


    uart uart0(
        .uart_tx(uart_OUT_data),
        .uart_wr_i(uart_we),
        .uart_dat_i(uart_IN_data),
        .sys_clk_i(clk),
        .sys_rstn_i(rst_n)
    );

    hardware_counter hardware_counter0(
        .CLK_IP(clk),
        .RSTN_IP(rst_n),
        .COUNTER_OP(hc_OUT_data)
    );

endmodule