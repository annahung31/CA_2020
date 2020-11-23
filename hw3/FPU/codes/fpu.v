module fpu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 1
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);

    // homework
    reg [DATA_WIDTH-1:0] o_data_r, o_data_w; 
    reg                  o_valid_r, o_valid_w;
    wire [30:23]          i_expo_a, i_expo_b;
    wire [22:0]           i_frag_a, i_frag_b;
    reg [30:23]           i_expo_sub;
    reg [30:23]           o_expo;
    
    wire                  i_sign_a, i_sign_b;
    reg [46:0]            i_frag_aa, i_frag_bb;
    reg [23:0]            i_frag_a1, i_frag_b1;
    reg [46:0]            i_frag_af, i_frag_bf;
    reg [47:0]            i_frag_o, i_frag_ma, i_frag_mb;
    reg [22:0]            i_frag_oo;


    


    // 把 register 的訊號送到 o_data
    assign o_data = o_data_r;  // o_data 這條線吃 o_data_r 的內容
    assign o_valid = o_valid_r;

    assign i_expo_a = i_data_a[30:23];
    assign i_expo_b = i_data_b[30:23];
    assign i_frag_a = i_data_a[22:0];
    assign i_frag_b = i_data_b[22:0];
    assign i_sign_a = i_data_a[DATA_WIDTH-1];
    assign i_sign_b = i_data_b[DATA_WIDTH-1];




    //combinational
    always @(*) begin
        if (i_valid) begin    // i_valid 的功能是什麼？ Ａ跟 B 是真的才開始動作。 A 跟 B 是什麼？
           
            case (i_inst) 
                1'd0: begin  //add

                    i_frag_a1 = {1'b1, i_frag_a};
                    i_frag_b1 = {1'b1, i_frag_b};

                    if (i_expo_a > i_expo_b) begin 
                        i_expo_sub = i_expo_a - i_expo_b;
                        i_frag_bf = {i_frag_b1, 23'b0};
                        i_frag_bb = i_frag_bf >> i_expo_sub;
                        i_frag_aa = {i_frag_a1, 23'b0};

                        o_expo = i_expo_a;
                    end
                    else begin
                        i_expo_sub = i_expo_b - i_expo_a;
                        i_frag_af = {i_frag_a1, 23'b0};
                        i_frag_aa = i_frag_af >> i_expo_sub;
                        i_frag_bb = {i_frag_b1, 23'b0};
                        o_expo = i_expo_b;
                    end
                    
                    if (i_sign_a ^ i_sign_b) begin                        
                        
                        if (i_frag_aa > i_frag_bb) begin
                            
                            i_frag_o = i_frag_aa - i_frag_bb;
                            
                            o_data_w[DATA_WIDTH-1] = i_sign_a;
                            
                        end

                        else begin
                            i_frag_o = i_frag_bb - i_frag_aa;
                            o_data_w[DATA_WIDTH-1] = i_sign_b;

                        end
                            
                    
                        if (i_frag_o[46] == 1) begin
                            
                            if (i_frag_o[22] == 1)
                                o_data_w[22:0] = i_frag_o[45:23]+1;
                            else
                                o_data_w[22:0] = i_frag_o[45:23];
                            o_data_w[30:23] = o_expo;

                        end
                            
                        else if (i_frag_o[45] == 1) begin
                            if (i_frag_o[21] == 1)
                                o_data_w[22:0] = i_frag_o[44:22]+1;
                            else
                                o_data_w[22:0] = i_frag_o[44:22];

                            o_data_w[30:23] = o_expo - 1;
                        end
                            
                        else if (i_frag_o[44] == 1) begin
                            if (i_frag_o[20] == 1)
                                o_data_w[22:0] = i_frag_o[43:21]+1;
                            else
                                o_data_w[22:0] = i_frag_o[43:21];

                            o_data_w[30:23] = o_expo - 2;
                        end

                        else if (i_frag_o[43] == 1) begin
                            if (i_frag_o[19] == 1)
                                o_data_w[22:0] = i_frag_o[42:20]+1;
                            else
                                o_data_w[22:0] = i_frag_o[42:20];

                            o_data_w[30:23] = o_expo - 3;
                        end


                        else if (i_frag_o[42] == 1) begin
                            if (i_frag_o[18] == 1)
                                o_data_w[22:0] = i_frag_o[41:19]+1;
                            else
                                o_data_w[22:0] = i_frag_o[41:19];

                            o_data_w[30:23] = o_expo - 4;
                        end



                        else begin
                            o_data_w[22:0] = i_frag_o[39:17];
                            o_data_w[30:23] = o_expo;                               
                        end


                    end
                    else begin
                        
                        i_frag_o = i_frag_aa + i_frag_bb;
                        

                        if (i_frag_o[47] == 1) begin
                            if (i_frag_o[23] == 1)
                                o_data_w[22:0] = i_frag_o[46:24]+1;
                            else
                                o_data_w[22:0] = i_frag_o[46:24];
                            
                            o_data_w[30:23] = o_expo + 1;
                        end

                        else if (i_frag_o[46] == 1) begin
                            if (i_frag_o[22] == 1)
                                o_data_w[22:0] = i_frag_o[45:23] + 1;
                            else
                                o_data_w[22:0] = i_frag_o[45:23];
                            o_data_w[30:23] = o_expo;
                        end
                        

                        else begin
                            o_data_w[22:0] = i_frag_o[44:12];
                            o_data_w[30:23] = o_expo - 1;
                        end
                            

                        o_data_w[DATA_WIDTH-1] = i_sign_a;
                    end

                    o_valid_w = 1;                    
                end


                1'd1: begin
                    o_data_w[30:23] = i_expo_a + i_expo_b - 127;
                    o_data_w[DATA_WIDTH-1] = i_sign_a ^ i_sign_b;

                    i_frag_ma[47:24] = 24'd0;
                    i_frag_ma[23] = 1;
                    i_frag_ma[22:0] = i_frag_a;
                    i_frag_mb[47:24] = 24'd0;
                    i_frag_mb[23] = 1;
                    i_frag_mb[22:0] = i_frag_b;

                    i_frag_o = i_frag_ma * i_frag_mb;

                    // rounding
                    //case 1: G == 1 and R == 1
                    if (i_frag_o[22] && i_frag_o[21]) begin
                        i_frag_o[47:23] = i_frag_o[47:23] + 1;
                    end
                    //case 2: G == 1 and R == 0 -> check if S == 0
                    else if (i_frag_o[22] && ~i_frag_o[21]) begin 
                        i_frag_o[20] = |i_frag_o[20:0]? 1 : 0; //check all bits after S
                        if (i_frag_o[20] == 1)
                            i_frag_o[47:23] = i_frag_o[47:23] + 1;
                        else if (i_frag_o[23] == 1)
                            i_frag_o[47:23] = i_frag_o[47:23] + 1;
                            
                    end
                    

                    o_data_w[22:0] = i_frag_o[45:23];

                    o_valid_w = 1;    
                end

                default: begin
                    o_data_w     = 0;
                    o_valid_w    = 1;  
                end  
            endcase
        end else begin
            o_data_w     = 0; 
            o_valid_w    = 0;  
        end
    end


    //sequencial
    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin   //變成 0 的時候，reset register
            o_data_r <= 0;
            o_valid_r <= 0;
        
        end else begin
            o_data_r <= o_data_w;

            o_valid_r <= o_valid_w;
        end
    end


endmodule