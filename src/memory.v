module memory(clk, w_data, w_addr, r_addr, funct3, mem_write, r_data, uart_OUT_data, uart_IN_data, uart_we, uart_tx, hc_OUT_data);
	input clk;
	input [31:0] w_data;
	input [31:0] w_addr, r_addr;
	input [2:0] funct3;
	input mem_write;
	output reg [31:0] r_data;

	input uart_OUT_data;
	output [7:0] uart_IN_data;
	output uart_we, uart_tx;

	input [31:0] hc_OUT_data;

	reg [31:0] mem [0:33000];

	initial begin
		// $readmemh("/home/yna/Documents/cpu/b3exp/benchmarks/Coremark/data.hex", mem);
	end

	always @(posedge clk) begin
		if(mem_write) begin
			case(funct3)
				3'b000: begin
				  			case(w_addr[1:0])
								2'b00: mem[w_addr/4][7:0] <= w_data[7:0];
								2'b01: mem[w_addr/4][15:8] <= w_data[7:0];
								2'b10: mem[w_addr/4][23:16] <= w_data[7:0];
								2'b11: mem[w_addr/4][31:24] <= w_data[7:0];
							endcase
						end
				3'b001: begin
				  			case(w_addr[1:0])
								2'b00: mem[w_addr/4][15:0] <= w_data[15:0];
								2'b01: mem[w_addr/4][23:8] <= w_data[15:0];
								2'b10: mem[w_addr/4][31:16] <= w_data[15:0];
								default: ;
							endcase
						end
				3'b010: mem[w_addr/4] <= w_data[31:0];
				default: ;
			endcase
		end
	end

	always @(r_addr, funct3) begin
		case(funct3)
			3'b000: begin
						case(r_addr[1:0])
							2'b00: r_data <= {{24{mem[r_addr/4][7]}}, mem[r_addr/4][7:0]};
							2'b01: r_data <= {{24{mem[r_addr/4][15]}}, mem[r_addr/4][15:8]};
							2'b10: r_data <= {{24{mem[r_addr/4][23]}}, mem[r_addr/4][23:16]};
							2'b11: r_data <= {{24{mem[r_addr/4][31]}}, mem[r_addr/4][31:24]};
						endcase
					end
			3'b001: begin
						case(r_addr[1:0])
							2'b00: r_data <= {{16{mem[r_addr/4][15]}}, mem[r_addr/4][15:0]};
							2'b01: r_data <= {{16{mem[r_addr/4][23]}}, mem[r_addr/4][23:8]};
							2'b10: r_data <= {{16{mem[r_addr/4][31]}}, mem[r_addr/4][31:16]};
							default: ;
						endcase
					end
			3'b010: begin
						if(r_addr == 32'hffffff00) r_data <= hc_OUT_data;
						else r_data <= mem[r_addr/4];
					end
			3'b100: begin
						case(r_addr[1:0])
							2'b00: r_data <= {24'b0, mem[r_addr/4][7:0]};
							2'b01: r_data <= {24'b0, mem[r_addr/4][15:8]};
							2'b10: r_data <= {24'b0, mem[r_addr/4][23:16]};
							2'b11: r_data <= {24'b0, mem[r_addr/4][31:24]};
						endcase
					end
			3'b101: begin
						case(r_addr[1:0])
							2'b00: r_data <= {16'b0, mem[r_addr/4][15:0]};
							2'b01: r_data <= {16'b0, mem[r_addr/4][23:8]};
							2'b10: r_data <= {16'b0, mem[r_addr/4][31:16]};
							default: ;
						endcase
					end
		endcase
	end

	// uart
	assign uart_IN_data = w_data[7:0];  // ストアするデータをモジュールへ入力
    assign uart_we = ((w_addr == 32'hf6fff070) && mem_write) ? 1'b1 : 1'b0;  // シリアル通信用アドレスへのストア命令実行時に送信開始信号をアサート
    assign uart_tx = uart_OUT_data;  // シリアル通信モジュールの出力はFPGA外部へと出力

endmodule