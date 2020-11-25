


module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64

)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [ INST_W-1 : 0 ] i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [ DATA_W-1 : 0 ] i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ ADDR_W-1 : 0 ] o_i_addr,       // to instruction memory
    output [ DATA_W-1 : 0 ] o_d_data,       // to data memory
    output [ ADDR_W-1 : 0 ] o_d_addr,       // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);


    integer            i;
    reg [63:0]         pc_r, pc_w;
    reg [3:0]          cs, ns;
    reg [DATA_W-1 : 0] reg_file[0:31];  //reg_file[0].size=DATA_W
    reg [DATA_W-1 : 0] reg_file_w[0:31];
    reg                o_i_valid_r, o_i_valid_w;
    reg [4 : 0]        rd, rs1, rs2;
    reg [11 : 0]       imm;
    reg                o_finish_r, o_finish_w;
    reg [ADDR_W-1 : 0] o_i_addr_r, o_i_addr_w;
    reg [DATA_W-1 : 0] o_d_data_r, o_d_data_w;
    reg [ADDR_W-1 : 0] o_d_addr_r,o_d_addr_w;
    // reg                o_d_MemRead_r, o_d_MemRead_W;
    reg                o_d_MemWrite_r, o_d_MemWrite_w;

    assign o_i_valid_addr = o_i_valid_r;
    assign o_finish = o_finish_r;
    assign o_i_addr = o_i_addr_r;
    // assign o_d_MemRead = o_d_MemRead_r;
    assign o_d_MemWrite = o_d_MemWrite_r;

    // count 5 cycles to wait for instr mem.
    always @(*) begin
        case (cs) //current state
            0: ns = 1;  // ns: next state
            1: ns = 2;
            2: ns = 3;
            3: ns = 4;
            4: ns = 5;
            5: ns = 6;
            6: ns = 7;
            7: ns = 8;
            8: ns = 9;
            9: ns = 10;
            10: ns = 11;
            11: ns = 12;
            12: ns = 13;
            13: ns = 14;
            14: ns = 15;
            15: ns = 0;
        endcase
    end



    always @(*) begin
        if (cs == 15) begin
            pc_w = pc_r + 4;
            o_i_addr_w = pc_w;
            o_i_valid_w = 1;
        end else begin
        	o_i_valid_w = 0; 
            pc_w = pc_r;
            o_i_addr_w = pc_w;

            
        end

    end

    // check if instr is fetched.
    always @( *) begin
        if (cs == 6) begin

            // LD


            // ADDI



            // SD
            if (i_i_inst[6:0] == 7'b0100011 
                && i_i_inst[18:16] == 7'b011) begin
                imm[4:0] = i_i_inst[11:7];
                imm[11:5] = i_i_inst[31:25];

                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];

                o_d_addr_w = {{52{imm[11]}}, imm[11:0]} + reg_file[rs1];  //addr
                o_d_data_w = rs2;           // data
                o_d_MemWrite_w = 1;
            end




            // OR
            if (i_i_inst[6:0] == 7'b0110011 
                    && i_i_inst[31:25] == 7'b0000000
                    && i_i_inst[18:16] == 7'b110) begin
                rd = i_i_inst[11:7];
                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];
                reg_file_w[rd] = reg_file[rs1] | reg_file[rs2];

            end
            // AND
            else if (i_i_inst[6:0] == 7'b0110011 
                    && i_i_inst[31:25] == 7'b0000000 
                    && i_i_inst[18:16] == 7'b111) begin
                rd = i_i_inst[11:7];
                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];
                reg_file_w[rd] = reg_file[rs1] & reg_file[rs2];
            end

            // XOR
            else if (i_i_inst[6:0] == 7'b0110011 
                    && i_i_inst[31:25] == 7'b0000000 
                    && i_i_inst[18:16] == 7'b100) begin
                rd = i_i_inst[11:7];
                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];
                reg_file_w[rd] = reg_file[rs1] ^ reg_file[rs2];
            end


            // ADD
            else if (i_i_inst[6:0] == 7'b0110011 && i_i_inst[31:25] == 7'b0000000) begin
                rd = i_i_inst[11:7];
                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];
                reg_file_w[rd] = reg_file[rs1] + reg_file[rs2];
            end

            // SUB
            else if (i_i_inst[6:0] == 7'b0110011 && i_i_inst[31:25] == 7'b0100000) begin
                rd = i_i_inst[11:7];
                rs1 = i_i_inst[19:15];
                rs2 = i_i_inst[24:20];
                reg_file_w[rd] = reg_file[rs1] - reg_file[rs2];
            end


            // imm: sign-extended 12-bit -> sign-extension -> 32 bit
            // then opeate with rs1

            // XORI
            // else if (i_i_inst[6:0] == 0010011 
            // && i_i_inst[31:25] == 0100000
            //             && i_i_inst[18:16] == 111) begin
            //     rd = i_i_inst[11:7];
            //     rs1 = i_i_inst[19:15];
            //     rs2 = i_i_inst[24:20];
            //     reg_file_w[rd] = reg_file[rs1] - reg_file[rs2];
            // end
            
            // ORI

            // ANDI

            // SLLI

            // SRLI






            // BEQ

            // BNE




            else if (i_i_inst[6:0] == 7'b1111111) begin
                o_finish_w = 1;
            end        
        end
    end



    // sequential
    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            pc_r        <= 0;   
            cs          <= 0;
            o_i_valid_r <= 0;
            o_finish_r  <= 0;
            o_i_addr_r  <= 0;
            o_d_MemWrite_r <= 0;
            // o_d_MemRead_r <= 0;
            o_d_data_r  <= 0;
            o_d_addr_r  <= 0;
            for (i=0; i < 31; i=i+1)
                reg_file[i] <= 64'b0;

        end else begin
            pc_r        <= pc_w;
            cs          <= ns;
            o_i_valid_r <= o_i_valid_w;
            o_finish_r  <= o_finish_w;
            o_i_addr_r  <= o_i_addr_w;
            o_d_MemWrite_r <= o_d_MemWrite_w;
            // o_d_MemRead_r <= o_d_MemRead_w;
            o_d_data_r   <= o_d_data_w;
            o_d_addr_r  <= o_d_addr_w;

            for (i=0; i < 31; i=i+1)
                reg_file[i] <= reg_file_w[i];
            
        end
    end



endmodule //cpu

