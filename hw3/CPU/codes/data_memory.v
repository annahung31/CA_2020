module data_memory #(
    parameter ADDR_W = 64,
    parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n,
    input  [DATA_W-1:0] i_data,
    input  [ADDR_W-1:0] i_addr,
    input               i_MemRead,
    input               i_MemWrite,
    output              o_valid,
    output [DATA_W-1:0] o_data
);
 
    reg [7:0] mem   [0:1023];
    reg [7:0] mem_w [0:1023];
    reg              o_valid_r, o_valid_w;
    reg [DATA_W-1:0] o_data_r,  o_data_w;
    reg        [3:0] cs, ns;
    reg [ADDR_W-1:0] temp_addr, temp_addr_w;
    reg [DATA_W-1:0] temp_data, temp_data_w;
    reg              temp_MemRead, temp_MemRead_w;
    reg              temp_MemWrite, temp_MemWrite_w;

    wire i_valid;

    integer i;
    
    assign o_valid = o_valid_r;
    assign o_data  = o_data_r;
    assign i_valid = i_MemRead | i_MemWrite;
    
    always @(*) begin
        if (i_valid) begin
            temp_addr_w     = i_addr;
            temp_data_w     = i_data;
            temp_MemRead_w  = i_MemRead;
            temp_MemWrite_w = i_MemWrite;
        end else begin
            temp_addr_w     = temp_addr;
            temp_data_w     = temp_data;
            temp_MemRead_w  = temp_MemRead;
            temp_MemWrite_w = temp_MemWrite;
        end
    end

    always @(*) begin
        if (cs == 7 && temp_MemRead) begin
            o_valid_w = 1;
            o_data_w  = {mem[temp_addr+7], mem[temp_addr+6],
                         mem[temp_addr+5], mem[temp_addr+4],
                         mem[temp_addr+3], mem[temp_addr+2], 
                         mem[temp_addr+1], mem[temp_addr+0]};
            temp_MemRead_w   = 0;
            temp_MemWrite_w  = 0;
            temp_data_w      = 0;
            temp_addr_w      = 0;
        end else if (cs == 7 && temp_MemWrite) begin
            mem_w[temp_addr+0] = temp_data[ 7:0];
            mem_w[temp_addr+1] = temp_data[15:8];
            mem_w[temp_addr+2] = temp_data[23:16];
            mem_w[temp_addr+3] = temp_data[31:24];
            mem_w[temp_addr+4] = temp_data[39:32];
            mem_w[temp_addr+5] = temp_data[47:40];  
            mem_w[temp_addr+6] = temp_data[55:48];
            mem_w[temp_addr+7] = temp_data[63:56]; 
            o_valid_w        = 0;
            temp_MemRead_w   = 0;
            temp_MemWrite_w  = 0;
            temp_data_w      = 0;
            temp_addr_w      = 0;
        end else begin
            for (i=0; i<1024; i++)
                mem_w[i] <= mem[i];
        	o_valid_w = 0;
            o_data_w  = 0;
        end
    end

    always @(*) begin
        case (cs)
        	0: ns = (i_valid) ? 1 : 0;
        	1: ns = 2;
        	2: ns = 3;
        	3: ns = 4;
            4: ns = 5;
            5: ns = 6;
            6: ns = 7;
            7: ns = 0;
        endcase
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_valid_r     <= 0;
            o_data_r      <= 0;
            cs            <= 0;
            temp_addr     <= 0;
            temp_data     <= 0;
            temp_MemRead  <= 0;
            temp_MemWrite <= 0;
            for (i=0; i<1024; i++)
                mem[i] <= 0;
        end else begin
            o_valid_r     <= o_valid_w;
            o_data_r      <= o_data_w;
            cs            <= ns; 
            temp_addr     <= temp_addr_w;
            temp_data     <= temp_data_w;
            temp_MemRead  <= temp_MemRead_w;
            temp_MemWrite <= temp_MemWrite_w;
            for (i=0; i<1024; i++)
                mem[i] <= mem_w[i];
        end
    end

endmodule 