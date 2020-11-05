module instruction_memory #(
    parameter ADDR_W   = 64,
    parameter INST_W   = 32,
    parameter MAX_INST = 16
)(
    input               i_clk,
    input               i_rst_n,
    input               i_valid,
    input  [ADDR_W-1:0] i_addr,
    output              o_valid,
    output [INST_W-1:0] o_inst
);
 
    reg [INST_W-1:0] mem [0:MAX_INST-1];
    reg              o_valid_r, o_valid_w;
    reg [INST_W-1:0] o_inst_r,  o_inst_w;
    reg        [3:0] cs, ns;
    reg [ADDR_W-1:0] temp_addr_r, temp_addr_w;
    integer i;
    
    assign o_valid = o_valid_r;
    assign o_inst  = o_inst_r;
    
    always @(*) begin
        if (i_valid) begin
            temp_addr_w = i_addr;
        end else begin
            temp_addr_w = temp_addr_r;
        end
    end

    always @(*) begin
        if (cs == 5) begin
            o_valid_w = 1;
            o_inst_w  = mem[temp_addr_r/4];
        end else begin
        	o_valid_w = 0;
            o_inst_w  = 0;
        end
    end

    always @(*) begin
        case (cs)
        	0: ns = (i_valid) ? 1 : 0;
        	1: ns = 2;
        	2: ns = 3;
        	3: ns = 4;
            4: ns = 5;
            5: ns = 0;
        endcase
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_valid_r   <= 0;
            o_inst_r    <= 0;
            cs          <= 0;
            temp_addr_r <= 0;
        end else begin
            o_valid_r   <= o_valid_w;
            o_inst_r    <= o_inst_w;
            cs          <= ns;
            temp_addr_r <= temp_addr_w; 
        end
    end

endmodule 