module sort #(
    parameter DATA_W = 32
)(
    input i_clk,
    input i_rst_n,
    input  [DATA_W*8-1:0] i_input,
    output [DATA_W*8-1:0] o_output //reg 在 always 裡面放在左邊，會自動變成 wire
);
    
    wire [DATA_W-1:0] i_input_ [0:7];  // i_input_[0] 是前 8 個 bits
    wire [DATA_W-1:0] stage_1  [0:7];
    wire [DATA_W-1:0] stage_2  [0:7];
    wire [DATA_W-1:0] stage_3  [0:7];
    wire [DATA_W-1:0] stage_4  [0:7];
    wire [DATA_W-1:0] stage_5  [0:7];
    wire [DATA_W-1:0] stage_6  [0:7];
    
    genvar i;  //generate variable

    // registers for pipeline reg
    for(i = 0; i < 8; i=i+1) begin
        assign i_input_[i] = i_input[(i+1)*DATA_W-1:i*DATA_W]; 
    end
    
    // stage 1
    for(i = 0; i < 4; i=i+1) begin : t1
        if (i % 2 == 0) begin 
            comparator #(
                .DATA_W(DATA_W)
            ) u1 (
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_input_1(i_input_[2*i]),
                .i_input_2(i_input_[2*i+1]),
                .o_output_1(stage_1[2*i]),
                .o_output_2(stage_1[2*i+1])
            );
        end else begin
            comparator #(
                .DATA_W(DATA_W)
            ) u1 (
                .i_clk(i_clk),
                .i_rst_n(i_rst_n),
                .i_input_1(i_input_[2*i]),
                .i_input_2(i_input_[2*i+1]),
                .o_output_1(stage_1[2*i+1]),
                .o_output_2(stage_1[2*i])
            );
        end
    end

    // stage 2
    for(i = 0; i < 2; i=i+1) begin : t2
        comparator #(
            .DATA_W(DATA_W)
        ) u2 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_1[i]),
            .i_input_2(stage_1[i+2]),
            .o_output_1(stage_2[i]),
            .o_output_2(stage_2[i+2])
        );
    end
    for(i = 4; i < 6; i=i+1) begin : t3
        comparator #(
            .DATA_W(DATA_W)
        ) u2 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_1[i]),
            .i_input_2(stage_1[i+2]),
            .o_output_1(stage_2[i+2]),
            .o_output_2(stage_2[i])
        );
    end

    // stage 3
    for(i = 0; i < 2; i=i+1) begin : t4
        comparator #(
            .DATA_W(DATA_W)
        ) u3 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_2[2*i]),
            .i_input_2(stage_2[2*i+1]),
            .o_output_1(stage_3[2*i]),
            .o_output_2(stage_3[2*i+1])
        );
    end
    for(i = 0; i < 2; i=i+1) begin : t5
        comparator #(
            .DATA_W(DATA_W)
        ) u3 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_2[4+2*i]),
            .i_input_2(stage_2[4+2*i+1]),
            .o_output_1(stage_3[4+2*i+1]),
            .o_output_2(stage_3[4+2*i])
        );
    end

    // stage 4
    for(i = 0; i < 4; i=i+1) begin : t6
        comparator #(
            .DATA_W(DATA_W)
        ) u4 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_3[i]),
            .i_input_2(stage_3[i+4]),
            .o_output_1(stage_4[i]),
            .o_output_2(stage_4[i+4])
        );
    end

    // stage 5
    for(i = 0; i < 2; i=i+1) begin : t7
        comparator #(
            .DATA_W(DATA_W)
        ) u5 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_4[i]),
            .i_input_2(stage_4[i+2]),
            .o_output_1(stage_5[i]),
            .o_output_2(stage_5[i+2])
        );
    end
    for(i = 4; i < 6; i=i+1) begin : t8
        comparator #(
            .DATA_W(DATA_W)
        ) u5 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_4[i]),
            .i_input_2(stage_4[i+2]),
            .o_output_1(stage_5[i]),
            .o_output_2(stage_5[i+2])
        );
    end

    // stage 6
    for(i = 0; i < 8; i=i+2) begin : t9
        comparator #(
            .DATA_W(DATA_W)
        ) u6 (
            .i_clk(i_clk),
            .i_rst_n(i_rst_n),
            .i_input_1(stage_5[i]),
            .i_input_2(stage_5[i+1]),
            .o_output_1(stage_6[i]),
            .o_output_2(stage_6[i+1])
        );
    end
    
    for(i = 0; i < 8; i=i+1)
        assign o_output[(i+1)*DATA_W-1:i*DATA_W] = stage_6[i]; 

endmodule


module comparator #(
    parameter DATA_W = 32
)(
    input               i_clk,
    input               i_rst_n,
    input  [DATA_W-1:0] i_input_1,
    input  [DATA_W-1:0] i_input_2,
    output [DATA_W-1:0] o_output_1,
    output [DATA_W-1:0] o_output_2
);

    reg [DATA_W-1:0] o_output_1_r, o_output_2_r;
    reg [DATA_W-1:0] o_output_1_w, o_output_2_w;

    assign o_output_1 = o_output_1_r;
    assign o_output_2 = o_output_2_r;

    always @(*) begin
        if (i_input_1 > i_input_2) begin
            o_output_1_w = i_input_2;
            o_output_2_w = i_input_1;
        end else begin
            o_output_1_w = i_input_1;
            o_output_2_w = i_input_2;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_output_1_r <= 0;
            o_output_2_r <= 0;
        end else begin
            o_output_1_r <= o_output_1_w;
            o_output_2_r <= o_output_2_w;
        end
    end

endmodule