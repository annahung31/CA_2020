`timescale 1ns/1ps
`define CYCLE      10.0
`define HCYCLE     (`CYCLE/2)
`define RST_DELAY  5
`define MAX_CYCLE  10000

module test_sort;

    parameter DATA_W = 8;

    reg clk;
    reg rst_n;
    integer i;
    integer t;

    reg [DATA_W-1:0] input_[0:7];
    wire [DATA_W-1:0] output_[0:7];

    always # (`HCYCLE) clk = ~clk;

    initial begin
        $dumpfile("sort.vcd");
        $dumpvars;
    end

    initial begin
        clk = 1'b1;
        rst_n = 1; 
        # (0.25 * `CYCLE);
        rst_n = 0; 
        # ((`RST_DELAY - 0.25) * `CYCLE);
        rst_n = 1;
        
        for (t = 0; t < 20; t=t+1) begin
            # (`CYCLE);
            for (i = 0; i < 8; i=i+1)
                input_[i] = {$random} % 256;
            $monitor("%d, %d, %d, %d, %d, %d, %d, %d", output_[0], output_[1], output_[2], output_[3],
                                                   output_[4], output_[5], output_[6], output_[7]);
        end
        
        
        # (`MAX_CYCLE * `CYCLE);
        $finish;
    end

    sort #(
        .DATA_W(DATA_W)
    ) u_sort (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_input({input_[7], input_[6], input_[5], input_[4], input_[3], input_[2], input_[1], input_[0]}),
        .o_output({output_[7], output_[6], output_[5], output_[4], 
                   output_[3], output_[2], output_[1], output_[0]})
    );

endmodule

