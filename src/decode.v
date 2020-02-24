module decode(instruction, imm, alu_ctrl, alu_src1, alu_src2, branch, is_jal, is_lui, reg_write, mem_write, mem_to_reg);
	input [31:0] instruction;
	output [31:0] imm;
	output [3:0] alu_ctrl;
	output alu_src1, alu_src2, branch, is_jal, is_lui, reg_write, mem_write, mem_to_reg;

    assign imm = imm_gen(instruction);
	assign alu_ctrl = alu_ctrl_gen(instruction);
	assign alu_src1 = alu_src1_gen(instruction[6:0]);
	assign alu_src2 = alu_src2_gen(instruction[6:0]);
	assign branch = instruction[6:0] == 7'b1100011;
	assign is_jal = instruction[6:0] == 7'b1100111 || instruction[6:0] == 7'b1101111;
	assign is_lui = instruction[6:0] == 7'b0110111;
	assign reg_write = instruction[6:0] == 7'b1100011 || instruction[6:0] == 7'b0100011 ? 0 : 1;
	assign mem_write = instruction[6:0] == 7'b0100011;
	assign mem_to_reg = instruction[6:0] == 7'b0000011;
	
	function [31:0] imm_gen;
        input [31:0] ir;
	    casex(ir[6:0])
		    7'b0010011: imm_gen = {{20{ir[31]}}, ir[31:20]}; // I type
            7'b0x10111: imm_gen = {ir[31:12], 12'b0}; // LUi, AUiPC
			7'b1101111: imm_gen = {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0}; // JAL
			7'b1100111: imm_gen = {{20{ir[31]}}, ir[31:20]}; // JALR
			7'b1100011: imm_gen = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B type
			7'b0100011: imm_gen = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Store
			7'b0000011: imm_gen = {{20{instruction[31]}}, instruction[31:20]}; // Load
		    default: imm_gen = 0;
	    endcase
    endfunction

	function [3:0] alu_ctrl_gen;
	    input [31:0] ir;
		casex(ir[6:0])
		    7'b0010011: alu_ctrl_gen = {ir[14:12] == 3'b000 ? 1'b0 : ir[30], ir[14:12]};
		    7'b0110011: alu_ctrl_gen = {ir[30], ir[14:12]};
			// 7'b0x10111: alu_ctrl_gen = 4'b0000; // output ADD when LUi, AUiPC
			// 7'b110x111: alu_ctrl_gen = 4'b0000; //　output ADD when JAL, JALR
			7'b1100011: alu_ctrl_gen = {ir[30], ir[14:12]}; // B type
			// 7'b0100011: alu_ctrl_gen = 4'b0000; // Store
			// 7'b0000011: alu_ctrl_gen = 4'b0000; // Load
			default: alu_ctrl_gen = 4'b0000; // ADD
		endcase
	endfunction

	function alu_src1_gen; // 1: op1 = pc, 0: op1 = rs1
		input [6:0] ir;
		case (ir)
			7'b0010111: alu_src1_gen = 1; // AUiPC
			7'b1101111: alu_src1_gen = 1; // JAL
			default: alu_src1_gen = 0;
		endcase
	endfunction

	function alu_src2_gen; // 0: op2 = imm, 1: op2 = rs2;
        input [6:0] ir;
        casex(ir)
		    // 7'b0010011: alu_src2_gen = 0; // I type
            7'b0110011: alu_src2_gen = 1; // U type
			// 7'b0x10111: alu_src2_gen = 0; // LUi, AUiPC
			// 7'b1101111: alu_src2_gen = 0; // JAL, JALR
			7'b1100011: alu_src2_gen = 1; // B type
            default: alu_src2_gen = 0;
        endcase
    endfunction
endmodule