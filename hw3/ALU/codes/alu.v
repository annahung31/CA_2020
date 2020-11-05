module alu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 4
)(
    input                   i_clk,
    input                   i_rst_n,  //ret= reset, n=negative . active: 從 1 變 0 才做
    input  [DATA_WIDTH-1:0] i_data_a,  // default 是 unsigned
    //input  signed [DATA_WIDTH-1:0] i_data_a,  // signed 的寫法
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_overflow,
    output                  o_valid
);


    // define output behavior, wire and registers
    reg [DATA_WIDTH-1:0] o_data_r, o_data_w;  // o_data_w要當成一條線
    reg                  o_verflow_r, o_overflow_w;
    reg                  o_valid_r, o_valid_w;
    integer ii;

    // // for signed add ??????
    // reg signed [DATA_WIDTH-1:0] signed_data_a, signed_data_b; //?????


    // 把 register 的訊號送到 o_data
    assign o_data = o_data_r;  // o_data 這條線吃 o_data_r 的內容
    assign o_overflow = o_verflow_r;
    assign o_valid = o_valid_r;
 

    //combinational
    always @(*) begin
        if (i_valid) begin    // i_valid 的功能是什麼？ Ａ跟 B 是真的才開始動作。 A 跟 B 是什麼？
            //如果是真的，就開始做運算
            case (i_inst) 
                //unsigned add 怎麼加
                // Q: 填滿是什麼？
                //            33 bit                32 bit     32 bit
                4'd5: begin
                    {o_overflow_w, o_data_w} = i_data_a + i_data_b; // {} 代表先把兩條 wire 先 concat 在一起。 o_overflow_w 是幹嘛的？
                    o_valid_w = 1;
                end
                4'd6: begin
                    {o_overflow_w, o_data_w} = i_data_a - i_data_b;
                    o_valid_w = 1;
                end
                4'd7: begin
                    {o_overflow_w, o_data_w} = i_data_a * i_data_b;
                    o_valid_w = 1;
                end
                4'd8: begin
                    if (i_data_a > i_data_b)
                        {o_overflow_w, o_data_w} = i_data_a;
                    else
                        {o_overflow_w, o_data_w} = i_data_b;
                    o_valid_w = 1;
                end

                4'd9: begin
                    if (i_data_a > i_data_b)
                        {o_overflow_w, o_data_w} = i_data_b;
                    else
                        {o_overflow_w, o_data_w} = i_data_a;
                    o_valid_w = 1;
                end

                4'd10: begin
                    o_overflow_w = 0;
                    o_data_w = i_data_a & i_data_b;
                    o_valid_w = 1;
                end

                4'd11: begin
                    o_overflow_w = 0;
                    o_data_w = i_data_a | i_data_b;
                    o_valid_w = 1;
                end

                4'd12: begin
                    o_overflow_w = 0;
                    o_data_w = i_data_a ^ i_data_b;
                    o_valid_w = 1;
                end

                4'd13: begin
                    o_overflow_w = 0;
                    o_data_w = ~i_data_a;
                    o_valid_w = 1;
                end

                4'd14: begin
                    o_overflow_w = 0;
                    
                    for (ii=DATA_WIDTH-1; ii >= 0; ii=ii-1)
                        o_data_w[DATA_WIDTH-1-ii] = i_data_a[ii];
                    o_valid_w = 1;
                end
                
                default: begin
                    o_overflow_w = 0;
                    o_data_w     = 0;
                    o_valid_w    = 1;  // 因為已經算完了
                end  
            endcase
        end else begin
            o_overflow_w = 0;
            o_data_w     = 0; 
            o_valid_w    = 0;   //?????
        end
    end


    //sequencial
    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin   //變成 0 的時候，reset register
            o_data_r <= 0;
            o_verflow_r <= 0;
            o_valid_r <= 0;
        
        end else begin
            o_data_r <= o_data_w;
            o_verflow_r <= o_overflow_w;
            o_valid_r <= o_valid_w;
        end
    end


endmodule


