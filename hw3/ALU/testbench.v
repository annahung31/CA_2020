`timescale 1ns/1ps
`define CYCLE      10.0
`define HCYCLE     (`CYCLE/2)
`define RST_DELAY  5
`define MAX_CYCLE  1000

module test_alu;

    parameter DATA_WIDTH  = 32;
    parameter INST_WIDTH  = 4;
    parameter NUM_OF_INST = 15;
    parameter NUM_OF_TEST = 4;

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars;
    end

    wire                  clk;
    wire                  rst_n;
    wire                  ivalid;
    wire [DATA_WIDTH-1:0] idata_a;
    wire [DATA_WIDTH-1:0] idata_b;
    wire [INST_WIDTH-1:0] inst;
    wire                  ovalid;
    wire [DATA_WIDTH-1:0] odata;
    wire                  overflow;

    alu #(
        .DATA_WIDTH(DATA_WIDTH), //port exported from module
        .INST_WIDTH(INST_WIDTH)
    ) u_alu (   //unit alu  要使用 alu 的時候另外取名
        .i_clk(clk),  
        .i_rst_n(rst_n),
        .i_data_a(idata_a),
        .i_data_b(idata_b),
        .i_inst(inst),
        .i_valid(ivalid),
        .o_data(odata),
        .o_overflow(overflow),
        .o_valid(ovalid)
    );

    alu_test #(
        .DATA_WIDTH(DATA_WIDTH),
        .INST_WIDTH(INST_WIDTH),
        .NUM_OF_INST(NUM_OF_INST),
        .NUM_OF_TEST(NUM_OF_TEST)
    ) u_alu_test (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_data(odata),
        .i_overflow(overflow),
        .i_valid(ovalid),
        .o_data_a(idata_a),
        .o_data_b(idata_b),
        .o_inst(inst),
        .o_valid(ivalid)
    );

    Clkgen u_clk (
        .clk(clk),
        .rst_n(rst_n)
    );

endmodule

module Clkgen (
    output reg clk,
    output reg rst_n
);
    always # (`HCYCLE) clk = ~clk;

    initial begin
        clk = 1'b1;
        rst_n = 1; # (               0.25 * `CYCLE);
        rst_n = 0; # ((`RST_DELAY - 0.25) * `CYCLE);
        $display("==========================================================================================");
        $display("Start testing");
        $display("==========================================================================================");
        rst_n = 1; # (         `MAX_CYCLE * `CYCLE);
        $finish;
    end
endmodule


module alu_test #(
    parameter DATA_WIDTH  = 32,
    parameter INST_WIDTH  = 4,
    parameter NUM_OF_INST = 15,
    parameter NUM_OF_TEST = 4
)(
    input                       i_clk,
    input                       i_rst_n,
    input      [DATA_WIDTH-1:0] i_data,
    input                       i_overflow,
    input                       i_valid,
    output reg [DATA_WIDTH-1:0] o_data_a,
    output reg [DATA_WIDTH-1:0] o_data_b,
    output reg [INST_WIDTH-1:0] o_inst,
    output reg                  o_valid
);

    reg             [5:0] ns, cs;
    reg                   test_start [0:NUM_OF_INST-1];
    wire                  test_done  [0:NUM_OF_INST-1];
    wire [DATA_WIDTH-1:0] test_dataA [0:NUM_OF_INST-1];
    wire [DATA_WIDTH-1:0] test_dataB [0:NUM_OF_INST-1];
    wire [INST_WIDTH-1:0] test_inst  [0:NUM_OF_INST-1];
    wire                  test_valid [0:NUM_OF_INST-1];
    integer total_error = 0;
    
    genvar i;
    generate
        for(i = 0; i < NUM_OF_INST; i=i+1) begin: test_unit
            test_interface #(
                .DATA_WIDTH(DATA_WIDTH),
                .INST_WIDTH(INST_WIDTH),
                .NUM_OF_TEST(NUM_OF_TEST)
            ) inst (
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_start(test_start[i]),
                .i_data(i_data),
                .i_overflow(i_overflow),
                .i_valid(i_valid),
                .o_data_a(test_dataA[i]),
                .o_data_b(test_dataB[i]),
                .o_inst(test_inst[i]),
                .o_valid(test_valid[i]),
                .o_done(test_done[i])
            );
        end
    endgenerate

    initial $readmemb ("./testcases/test00_input.txt",  test_unit[0].inst.input_array);
    initial $readmemb ("./testcases/test00_output.txt", test_unit[0].inst.output_array);
    initial $readmemb ("./testcases/test01_input.txt",  test_unit[1].inst.input_array);
    initial $readmemb ("./testcases/test01_output.txt", test_unit[1].inst.output_array);
    initial $readmemb ("./testcases/test02_input.txt",  test_unit[2].inst.input_array);
    initial $readmemb ("./testcases/test02_output.txt", test_unit[2].inst.output_array);
    initial $readmemb ("./testcases/test03_input.txt",  test_unit[3].inst.input_array);
    initial $readmemb ("./testcases/test03_output.txt", test_unit[3].inst.output_array);
    initial $readmemb ("./testcases/test04_input.txt",  test_unit[4].inst.input_array);
    initial $readmemb ("./testcases/test04_output.txt", test_unit[4].inst.output_array);
    initial $readmemb ("./testcases/test05_input.txt",  test_unit[5].inst.input_array);
    initial $readmemb ("./testcases/test05_output.txt", test_unit[5].inst.output_array);
    initial $readmemb ("./testcases/test06_input.txt",  test_unit[6].inst.input_array);
    initial $readmemb ("./testcases/test06_output.txt", test_unit[6].inst.output_array);
    initial $readmemb ("./testcases/test07_input.txt",  test_unit[7].inst.input_array);
    initial $readmemb ("./testcases/test07_output.txt", test_unit[7].inst.output_array);
    initial $readmemb ("./testcases/test08_input.txt",  test_unit[8].inst.input_array);
    initial $readmemb ("./testcases/test08_output.txt", test_unit[8].inst.output_array);
    initial $readmemb ("./testcases/test09_input.txt",  test_unit[9].inst.input_array);
    initial $readmemb ("./testcases/test09_output.txt", test_unit[9].inst.output_array);
    initial $readmemb ("./testcases/test10_input.txt",  test_unit[10].inst.input_array);
    initial $readmemb ("./testcases/test10_output.txt", test_unit[10].inst.output_array);
    initial $readmemb ("./testcases/test11_input.txt",  test_unit[11].inst.input_array);
    initial $readmemb ("./testcases/test11_output.txt", test_unit[11].inst.output_array);
    initial $readmemb ("./testcases/test12_input.txt",  test_unit[12].inst.input_array);
    initial $readmemb ("./testcases/test12_output.txt", test_unit[12].inst.output_array);
    initial $readmemb ("./testcases/test13_input.txt",  test_unit[13].inst.input_array);
    initial $readmemb ("./testcases/test13_output.txt", test_unit[13].inst.output_array);
    initial $readmemb ("./testcases/test14_input.txt",  test_unit[14].inst.input_array);
    initial $readmemb ("./testcases/test14_output.txt", test_unit[14].inst.output_array);
    
    localparam
        Idle   = 0,
        Test00 = 1,
        Test01 = 2,
        Test02 = 3,
        Test03 = 4,
        Test04 = 5,
        Test05 = 6,
        Test06 = 7,
        Test07 = 8,
        Test08 = 9,
        Test09 = 10,
        Test10 = 11,
        Test11 = 12,
        Test12 = 13,
        Test13 = 14,
        Test14 = 15,
        End    = 16;

    always @(*) begin
        ns      = cs;
        o_valid = 0;
        case (cs)
            Idle: begin
                ns = Test00;
            end
            Test00: begin
                test_start[0] = 1'b1;
                o_data_a      = test_dataA[0];
                o_data_b      = test_dataB[0];
                o_inst        = test_inst[0];
                o_valid       = test_valid[0];
                if (test_done[0]) begin
                    ns = Test01;
                    total_error = total_error + test_unit[0].inst.error;
                    $display("Finish signed add test.");
                    $display("==========================================================================================");
                end
            end
            Test01: begin
                test_start[1] = 1'b1;
                o_data_a      = test_dataA[1];
                o_data_b      = test_dataB[1];
                o_inst        = test_inst[1];
                o_valid       = test_valid[1];
                if (test_done[1]) begin
                    ns = Test02;
                    total_error = total_error + test_unit[1].inst.error;
                    $display("Finish signed sub test.");
                    $display("==========================================================================================");
                end
            end
            Test02: begin
                test_start[2] = 1'b1;
                o_data_a      = test_dataA[2];
                o_data_b      = test_dataB[2];
                o_inst        = test_inst[2];
                o_valid       = test_valid[2];
                if (test_done[2]) begin
                    ns = Test03;
                    total_error = total_error + test_unit[2].inst.error;
                    $display("Finish signed mul test.");
                    $display("==========================================================================================");
                end
            end
            Test03: begin
                test_start[3] = 1'b1;
                o_data_a      = test_dataA[3];
                o_data_b      = test_dataB[3];
                o_inst        = test_inst[3];
                o_valid       = test_valid[3];
                if (test_done[3]) begin
                    ns = Test04;
                    total_error = total_error + test_unit[3].inst.error;
                    $display("Finish signed max test.");
                    $display("==========================================================================================");
                end
            end
            Test04: begin
                test_start[4] = 1'b1;
                o_data_a      = test_dataA[4];
                o_data_b      = test_dataB[4];
                o_inst        = test_inst[4];
                o_valid       = test_valid[4];
                if (test_done[4]) begin
                    ns = Test05;
                    total_error = total_error + test_unit[4].inst.error;
                    $display("Finish signed min test.");
                    $display("==========================================================================================");
                end
            end
            Test05: begin
                test_start[5] = 1'b1;
                o_data_a      = test_dataA[5];
                o_data_b      = test_dataB[5];
                o_inst        = test_inst[5];
                o_valid       = test_valid[5];
                if (test_done[5]) begin
                    ns = Test06;
                    total_error = total_error + test_unit[5].inst.error;
                    $display("Finish unsigned add test.");
                    $display("==========================================================================================");
                end
            end
            Test06: begin
                test_start[6] = 1'b1;
                o_data_a      = test_dataA[6];
                o_data_b      = test_dataB[6];
                o_inst        = test_inst[6];
                o_valid       = test_valid[6];
                if (test_done[6]) begin
                    ns = Test07;
                    total_error = total_error + test_unit[6].inst.error;
                    $display("Finish unsigned sub test.");
                    $display("==========================================================================================");
                end
            end
            Test07: begin
                test_start[7] = 1'b1;
                o_data_a      = test_dataA[7];
                o_data_b      = test_dataB[7];
                o_inst        = test_inst[7];
                o_valid       = test_valid[7];
                if (test_done[7]) begin
                    ns = Test08;
                    total_error = total_error + test_unit[7].inst.error;
                    $display("Finish unsigned mul test.");
                    $display("==========================================================================================");
                end
            end
            Test08: begin
                test_start[8] = 1'b1;
                o_data_a      = test_dataA[8];
                o_data_b      = test_dataB[8];
                o_inst        = test_inst[8];
                o_valid       = test_valid[8];
                if (test_done[8]) begin
                    ns = Test09;
                    total_error = total_error + test_unit[8].inst.error;
                    $display("Finish unsigned max test.");
                    $display("==========================================================================================");
                end
            end
            Test09: begin
                test_start[9] = 1'b1;
                o_data_a      = test_dataA[9];
                o_data_b      = test_dataB[9];
                o_inst        = test_inst[9];
                o_valid       = test_valid[9];
                if (test_done[9]) begin
                    ns = Test10;
                    total_error = total_error + test_unit[9].inst.error;
                    $display("Finish unsigned min test.");
                    $display("==========================================================================================");
                end
            end
            Test10: begin
                test_start[10] = 1'b1;
                o_data_a       = test_dataA[10];
                o_data_b       = test_dataB[10];
                o_inst         = test_inst[10];
                o_valid        = test_valid[10];
                if (test_done[10]) begin
                    ns = Test11;
                    total_error = total_error + test_unit[10].inst.error;
                    $display("Finish and test.");
                    $display("==========================================================================================");
                end
            end
            Test11: begin
                test_start[11] = 1'b1;
                o_data_a       = test_dataA[11];
                o_data_b       = test_dataB[11];
                o_inst         = test_inst[11];
                o_valid        = test_valid[11];
                if (test_done[11]) begin
                    ns = Test12;
                    total_error = total_error + test_unit[11].inst.error;
                    $display("Finish or test.");
                    $display("==========================================================================================");
                end
            end
            Test12: begin
                test_start[12] = 1'b1;
                o_data_a       = test_dataA[12];
                o_data_b       = test_dataB[12];
                o_inst         = test_inst[12];
                o_valid        = test_valid[12];
                if (test_done[12]) begin
                    ns = Test13;
                    total_error = total_error + test_unit[12].inst.error;
                    $display("Finish xor test.");
                    $display("==========================================================================================");
                end
            end
            Test13: begin
                test_start[13] = 1'b1;
                o_data_a       = test_dataA[13];
                o_data_b       = test_dataB[13];
                o_inst         = test_inst[13];
                o_valid        = test_valid[13];
                if (test_done[13]) begin
                    ns = Test14;
                    total_error = total_error + test_unit[13].inst.error;
                    $display("Finish flip test.");
                    $display("==========================================================================================");
                end
            end
            Test14: begin
                test_start[14] = 1'b1;
                o_data_a       = test_dataA[14];
                o_data_b       = test_dataB[14];
                o_inst         = test_inst[14];
                o_valid        = test_valid[14];
                if (test_done[14]) begin
                    ns = End;
                    total_error = total_error + test_unit[14].inst.error;
                    $display("Finish reverse test.");
                    $display("==========================================================================================");
                end
            end
            End: begin
                ns = End;
                $display("Finish all tests.");
                $display("Score: %.1f/30.0", (60-total_error)/2.0);
                $finish;
            end
        endcase
    end

    always @(negedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            cs <= Idle;
        end else begin
            cs <= ns;
        end
    end

endmodule

module test_interface #(
    parameter DATA_WIDTH  = 32,
    parameter INST_WIDTH  = 4,
    parameter NUM_OF_TEST = 4
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_start,
    input  [DATA_WIDTH-1:0] i_data,
    input                   i_overflow,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data_a,
    output [DATA_WIDTH-1:0] o_data_b,
    output [INST_WIDTH-1:0] o_inst,
    output                  o_valid,
    output                  o_done
);

    reg [2*DATA_WIDTH+INST_WIDTH-1:0] input_array  [0:NUM_OF_TEST-1];
    reg [2*DATA_WIDTH+INST_WIDTH-1:0] output_array [0:NUM_OF_TEST-1];

    localparam
        Idle_  = 0,
        Read   = 1,
        Write  = 2,
        Done   = 3,
        Finish = 4;

    reg                   o_valid_w, o_valid_r;
    reg  [DATA_WIDTH-1:0] o_data_a_w, o_data_a_r;
    reg  [DATA_WIDTH-1:0] o_data_b_w, o_data_b_r;
    reg  [           2:0] cs_, ns_;
    reg  [           2:0] idx_w, idx_r;
    
    wire [DATA_WIDTH-1:0] input_A, input_B, output_data;
    wire                  output_overflow, test_finish;
    
    integer error;
    
    assign test_finish     = (idx_r == NUM_OF_TEST-1);
    assign input_A         = input_array[idx_r][DATA_WIDTH-1:0];
    assign input_B         = input_array[idx_r][2*DATA_WIDTH-1:DATA_WIDTH];
    assign output_data     = output_array[idx_r][DATA_WIDTH-1:0];
    assign output_overflow = output_array[idx_r][DATA_WIDTH];

    assign o_data_a        = o_data_a_r;
    assign o_data_b        = o_data_b_r;
    assign o_inst          = input_array[idx_r][2*DATA_WIDTH+INST_WIDTH-1:2*DATA_WIDTH];
    assign o_valid         = o_valid_r;
    assign o_done          = (cs_ == Finish);
    
    always @(*) begin
        case (cs_)
            Idle_   : ns_ = (i_start) ? Read : Idle_;
            Read    : ns_ = Write;
            Write   : ns_ = (i_valid) ? (test_finish ? Done : Read) : Write;
            Done    : ns_ = Finish;
            Finish  : ns_ = Finish;
            default : ns_ = Idle_;
        endcase
    end

    always @(*) begin
        idx_w = idx_r;
        o_valid_w  = 0;
        o_data_a_w = 0;
        o_data_b_w = 0;
        case (cs_)
            Read: begin
                o_valid_w = 1;
                o_data_a_w = input_array[idx_r][DATA_WIDTH-1:0];
                o_data_b_w = input_array[idx_r][2*DATA_WIDTH-1:DATA_WIDTH];
            end
            Write: begin
                idx_w = (i_valid && !test_finish) ? idx_r+1 : idx_r;
            end
        endcase
    end

    always @(negedge i_clk) begin
        if (cs_ == Idle_) begin
            error = 0;
        end else if (cs_ == Write && i_valid) begin
            if (output_overflow) begin
                if (i_overflow) begin
                    $display("Test #%d: Correct!", idx_r);
                end else begin
                    $display("Test #%d: Error! A=0x%x, B=0x%x, yours=(0x%x, 0x%x), answer=(0x%x, 0x%x)", 
                        idx_r, input_A, input_B, i_overflow, i_data,
                        output_overflow, output_data);
                    error = error+1;
                end
            end else begin
                if (i_data !== output_data || i_overflow !== 1'b0) begin
                    $display("Test #%d: Error! A=0x%x, B=0x%x, yours=(0x%x, 0x%x), answer=(0x%x, 0x%x)",
                        idx_r, input_A, input_B, i_overflow, i_data, 
                        output_overflow, output_data);
                    error = error+1;
                end else begin
                    $display("Test #%d: Correct!", idx_r);
                end
            end
        end 
        else if (cs_ == Done) begin
            if (error == 0) begin
                $display("ALL PASS!");
            end else begin
                $display("#Errors: %d", error);
            end
        end
    end
 
    always @(negedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            cs_        <= Idle_;
            idx_r      <= 0;
            o_valid_r  <= 0;
            o_data_a_r <= 0;
            o_data_b_r <= 0;
        end else begin
            cs_        <= ns_;
            idx_r      <= idx_w;
            o_valid_r  <= o_valid_w;
            o_data_a_r <= o_data_a_w;
            o_data_b_r <= o_data_b_w;
        end
    end

endmodule