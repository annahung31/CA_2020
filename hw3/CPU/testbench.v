`timescale 1ns/1ps
`define CYCLE      10.0
`define HCYCLE     (`CYCLE/2)
`define RST_DELAY  5
`define MAX_CYCLE  10000

module test_cpu;
 
    parameter INST_W   = 32;
    parameter DATA_W   = 64;
    parameter ADDR_W   = 64;
    parameter MAX_INST = 16;

    wire                  i_clk;
    wire                  i_rst_n;
    wire [ INST_W-1 : 0 ] i_inst;
    wire                  i_valid_inst;
    wire [ DATA_W-1 : 0 ] read_data;
    wire                  d_valid_data;
    wire [ ADDR_W-1 : 0 ] i_addr;
    wire                  i_valid_addr;
    wire [ DATA_W-1 : 0 ] write_data;
    wire [ ADDR_W-1 : 0 ] write_addr;
    wire                  MemRead;
    wire                  MemWrite;
    wire                  Finish;

    reg clk;
    reg rst_n;
    reg [7:0] answer [0:1023];

    integer error, i;

    assign i_clk   = clk;
    assign i_rst_n = rst_n;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars;
    end

    `ifdef T0
    initial $readmemb ("testcases/no_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/no_test_output.txt", answer);
    `elsif T1
    initial $readmemb ("testcases/store_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/store_test_output.txt", answer);
    `elsif T2
    initial $readmemb ("testcases/load_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/load_test_output.txt", answer);
    `elsif T3
    initial $readmemb ("testcases/add_sub_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/add_sub_test_output.txt", answer);
    `elsif T4
    initial $readmemb ("testcases/and_or_xor_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/and_or_xor_test_output.txt", answer);
    `elsif T5
    initial $readmemb ("testcases/andi_ori_xori_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/andi_ori_xori_test_output.txt", answer);
    `elsif T6
    initial $readmemb ("testcases/slli_srli_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/slli_srli_test_output.txt", answer);
    `elsif T7
    initial $readmemb ("testcases/bne_beq_test_input.txt", u_inst_mem.mem);
    initial $readmemb ("testcases/bne_beq_test_output.txt", answer);
    `endif

    always # (`HCYCLE) clk = ~clk;
    
    initial begin
 		`ifdef T0
			$display("Eof test");
		`elsif T1
			$display("Store test");
		`elsif T2
			$display("Load test");
		`elsif T3
			$display("Add sub test");
		`elsif T4
			$display("And or xor test");
		`elsif T5
			$display("Andi ori xori test");
		`elsif T6
			$display("Slli srli test");
		`elsif T7
			$display("Bne beq test");
		`endif
        error = 0;
        clk   = 1'b1;
        rst_n = 1; # (               0.25 * `CYCLE);
        rst_n = 0; # ((`RST_DELAY - 0.25) * `CYCLE);
        rst_n = 1; # (         `MAX_CYCLE * `CYCLE);
        $finish;
    end

    always @(negedge i_clk) begin
        if (Finish) begin
            $display("Check memory");
            for (i = 0; i < 1024; i++) begin
                if (answer[i] !== u_data_mem.mem[i]) begin
                    $display("Error!, at 0x%x, ans:%x, yours:%x", i, answer[i], u_data_mem.mem[i]);
                    error = 1;
                end
            end
            if (!error) begin
                $display("Correct!");
            end
            $finish;
        end
    end

    cpu #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_cpu (
        .i_clk(clk),
        .i_rst_n(i_rst_n),
        .i_i_valid_inst(i_valid_inst), // from instruction memory
        .i_i_inst(i_inst),             // from instruction memory
        .i_d_valid_data(d_valid_data), // from data memory
        .i_d_data(read_data),          // from data memory
        .o_i_valid_addr(i_valid_addr), // to instruction memory
        .o_i_addr(i_addr),             // to instruction memory
        .o_d_data(write_data),         // to data memory
        .o_d_addr(write_addr),         // to data memory
        .o_d_MemRead(MemRead),         // to data memory
        .o_d_MemWrite(MemWrite),       // to data memory
        .o_finish(Finish)
    );

    instruction_memory #(
        .ADDR_W(ADDR_W),
        .INST_W(INST_W),
        .MAX_INST(MAX_INST)
    ) u_inst_mem (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_valid(i_valid_addr),
        .i_addr(i_addr),
        .o_valid(i_valid_inst),
        .o_inst(i_inst)
    );

    data_memory #(
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W)
    ) u_data_mem (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data(write_data),
        .i_addr(write_addr),
        .i_MemRead(MemRead),
        .i_MemWrite(MemWrite),
        .o_valid(d_valid_data),
        .o_data(read_data)
    );

endmodule
