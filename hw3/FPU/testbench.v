`timescale 1ns/1ps
`define CYCLE      10.0
`define HCYCLE     (`CYCLE/2)
`define RST_DELAY  5
`define MAX_CYCLE  1000

module test_fpu;

    parameter DATA_WIDTH  = 32;
    parameter INST_WIDTH  = 1;
    parameter NUM_OF_INST = 2;
    parameter NUM_OF_TEST = 10;

    initial begin
        $dumpfile("fpu.vcd");
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
    
    fpu #(
        .DATA_WIDTH(DATA_WIDTH),
        .INST_WIDTH(INST_WIDTH)
    ) u_fpu (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_data_a(idata_a),
        .i_data_b(idata_b),
        .i_inst(inst),
        .i_valid(ivalid),
        .o_data(odata),
        .o_valid(ovalid)
    );

    fpu_test #(
        .DATA_WIDTH(DATA_WIDTH),
        .INST_WIDTH(INST_WIDTH),
        .NUM_OF_INST(NUM_OF_INST),
        .NUM_OF_TEST(NUM_OF_TEST)
    ) u_fpu_test (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_data(odata),
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


module fpu_test #(
    parameter DATA_WIDTH  = 32,
    parameter INST_WIDTH  = 1,
    parameter NUM_OF_INST = 2,
    parameter NUM_OF_TEST = 10
)(
    input                       i_clk,
    input                       i_rst_n,
    input      [DATA_WIDTH-1:0] i_data,
    input                       i_valid,
    output reg [DATA_WIDTH-1:0] o_data_a,
    output reg [DATA_WIDTH-1:0] o_data_b,
    output reg [INST_WIDTH-1:0] o_inst,
    output reg                  o_valid
);

    reg             [1:0] ns, cs;
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
    
    localparam
        Idle   = 0,
        Test00 = 1,
        Test01 = 2,
        End    = 3;

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
                    $display("Finish add test.");
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
                    ns = End;
                    total_error = total_error + test_unit[1].inst.error;
                    $display("Finish mul test.");
                    $display("==========================================================================================");
                end
            end
            End: begin
                ns = End;
                $display("Finish all tests.");
                $display("Score: %.1f/20.0", (20-total_error));
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
    parameter INST_WIDTH  = 1,
    parameter NUM_OF_TEST = 10
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_start,
    input  [DATA_WIDTH-1:0] i_data,
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
    reg  [           3:0] idx_w, idx_r;
    
    wire [DATA_WIDTH-1:0] input_A, input_B, output_data;
    wire                  test_finish;
    
    integer error;
    
    assign test_finish     = (idx_r == NUM_OF_TEST-1);
    assign input_A         = input_array[idx_r][DATA_WIDTH-1:0];
    assign input_B         = input_array[idx_r][2*DATA_WIDTH-1:DATA_WIDTH];
    assign output_data     = output_array[idx_r][DATA_WIDTH-1:0];
    
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
            if (i_data !== output_data) begin
                $display("Test #%d: Error! A=0x%x, B=0x%x, yours=0x%x, answer=0x%x",
                    idx_r, input_A, input_B, i_data, output_data);
                error = error+1;
            end else begin
                $display("Test #%d: Correct!", idx_r);
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