module alu(op1, op2, alu_ctrl, branch, result, zero);
	input [31:0] op1;
	input [31:0] op2;
	input [3:0] alu_ctrl;
	input branch;
	output reg [31:0] result;
	output reg zero;

	always @(alu_ctrl, branch, op1, op2) begin
		casex(alu_ctrl)
			4'b0000: result <= op1 + op2; // ADD
			4'b1000: result <= op1 - op2; // SUB
			4'bx001: result <= op1 << op2[4:0]; // SLL
			4'bx010: result <= $signed(op1) < $signed(op2) ? 1 : 0; // SLT
			4'bx011: result <= op1 < op2 ? 1 : 0; // SLTu
			4'bx100: result <= op1 ^ op2; // XOR
			4'b0101: result <= op1 >> op2[4:0]; // SRL
			4'b1101: result <= $signed(op1) >>> op2[4:0]; // SRA
			4'bx110: result <= op1 | op2; // OR
			4'bx111: result <= op1 & op2; // AND
			default: result <= 0;
		endcase
	end

	always @(alu_ctrl, branch, op1, op2) begin
		if(branch) begin
			casex(alu_ctrl)
				4'bx000: zero <= op1 == op2;
				4'bx001: zero <= op1 != op2;
				4'bx100: zero <= $signed(op1) < $signed(op2);
				4'bx101: zero <= $signed(op1) >= $signed(op2);
				4'bx110: zero <= op1 < op2;
				4'bx111: zero <= op1 >= op2;
				default: zero <= 0;
			endcase
		end
		else zero <= 0;
	end
endmodule