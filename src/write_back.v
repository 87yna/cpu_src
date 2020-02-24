module write_back(pc, alu_result, imm, mem_data, zero, is_jal, mem_to_reg, w_data, npc);
    input [31:0] pc;
    input [31:0] alu_result, imm, mem_data;
    input zero, is_jal, mem_to_reg;
	output [31:0] w_data, npc;

    assign w_data = mem_to_reg ? mem_data : (is_jal  ? pc + 4 : alu_result);

    //if(is_jal) npc = result;
    //else if(zero) npc = pc + imm;
    //else npc = pc + 4;

    assign npc = is_jal ? alu_result : pc + (zero ? imm : 4);
endmodule
