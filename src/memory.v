module memory(clk, w_data, w_addr, r_addr, funct3, mem_write, r_data);
	input clk;
	input [31:0] w_data;
	input [31:0] w_addr, r_addr;
	input [2:0] funct3;
	input mem_write;
	output reg [31:0] r_data;

	reg [31:0] mem [0:24575];

	always @(posedge clk) begin
		if(mem_write) begin
			case(funct3)
				3'b000: begin
				  			case(w_addr[1:0])
								2'b00: mem[w_addr/4][31:24] <= w_data[7:0];
								2'b01: mem[w_addr/4][23:16] <= w_data[7:0];
								2'b10: mem[w_addr/4][15:8] <= w_data[7:0];
								2'b11: mem[w_addr/4][7:0] <= w_data[7:0];
							endcase
						end
				3'b001: begin
				  			case(w_addr[1:0])
								2'b00: mem[w_addr/4][31:16] <= {w_data[7:0], w_data[15:8]};
								2'b01: mem[w_addr/4][23:8] <= {w_data[7:0], w_data[15:8]};
								2'b10: mem[w_addr/4][15:0] <= {w_data[7:0], w_data[15:8]};
							endcase
						end
				3'b010: mem[w_addr/4] <= {w_data[7:0], w_data[15:8], w_data[23:16], w_data[31:24]};
				default: ;
			endcase
		end
	end

	always @(r_addr, funct3) begin
		case(funct3)
			3'b000: begin
						case(r_addr[1:0])
							2'b00: r_data <= {{24{mem[r_addr/4][31]}}, mem[r_addr/4][31:24]};
							2'b01: r_data <= {{24{mem[r_addr/4][23]}}, mem[r_addr/4][23:16]};
							2'b10: r_data <= {{24{mem[r_addr/4][15]}}, mem[r_addr/4][15:8]};
							2'b11: r_data <= {{24{mem[r_addr/4][7]}}, mem[r_addr/4][7:0]};
						endcase
					end
			3'b001: begin
						case(r_addr[1:0])
							2'b00: r_data <= {{16{mem[r_addr/4][23]}}, mem[r_addr/4][23:16], mem[r_addr/4][31:24]};
							2'b01: r_data <= {{16{mem[r_addr/4][15]}}, mem[r_addr/4][15:8], mem[r_addr/4][23:16]};
							2'b10: r_data <= {{16{mem[r_addr/4][7]}}, mem[r_addr/4][7:0], mem[r_addr/4][15:8]};
						endcase
					end
			3'b010: r_data <= {mem[r_addr/4][7:0], mem[r_addr/4][15:8], mem[r_addr/4][23:16], mem[r_addr/4][31:24]};
			3'b100: begin
						case(r_addr[1:0])
							2'b00: r_data <= {24'b0, mem[r_addr/4][31:24]};
							2'b01: r_data <= {24'b0, mem[r_addr/4][23:16]};
							2'b10: r_data <= {24'b0, mem[r_addr/4][15:8]};
							2'b11: r_data <= {24'b0, mem[r_addr/4][7:0]};
						endcase
					end
			3'b101: begin
						case(r_addr[1:0])
							2'b00: r_data <= {16'b0, mem[r_addr/4][23:16], mem[r_addr/4][31:24]};
							2'b01: r_data <= {16'b0, mem[r_addr/4][15:8], mem[r_addr/4][23:16]};
							2'b10: r_data <= {16'b0, mem[r_addr/4][7:0], mem[r_addr/4][15:8]};
						endcase
					end
		endcase
	end
endmodule