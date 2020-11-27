


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
    reg [3:0]          dcs, dns;
    reg [DATA_W-1 : 0] reg_file[0:31];  //reg_file[0].size=DATA_W
    reg [DATA_W-1 : 0] reg_file_w[0:31];
    reg                o_i_valid_r, o_i_valid_w;
    reg [4 : 0]        rd, rs1, rs2;
    reg [DATA_W-1 : 0] rs1_value;
    reg [11 : 0]       imm;
    reg                o_finish_r, o_finish_w;
    reg [ADDR_W-1 : 0] o_i_addr_r, o_i_addr_w;
    reg [DATA_W-1 : 0] o_d_data_r, o_d_data_w;
    reg [ADDR_W-1 : 0] o_d_addr_r,o_d_addr_w;
    reg                o_d_MemRead_r, o_d_MemRead_w;
    reg                o_d_MemWrite_r, o_d_MemWrite_w;
    reg                over_r, over_w;
    reg                shift_temp;
    reg                data_count;
    reg [INST_W-1 : 0] i_inst_temp;
    wire [6:0]         opcode;
    wire [5:0]         rdd;




    assign rdd      = i_i_inst[11:7];
    assign opcode   = i_i_inst[6:0];
    assign o_i_valid_addr = o_i_valid_r;
    assign o_finish = o_finish_r;
    assign o_i_addr = o_i_addr_r;

    assign o_d_addr = o_d_addr_r;
    assign o_d_data = o_d_data_r;
    assign o_d_MemWrite = o_d_MemWrite_r;
    assign o_d_MemRead = o_d_MemRead_r;

    // count 15 cycles to wait for instr mem.
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
        if (i_i_valid_inst) begin
            i_inst_temp = i_i_inst;
            
        end
    end



    always @(*) begin
        if (cs == 15) begin
            
            pc_w = pc_r + 4;
            o_i_addr_w = pc_r;
            o_i_valid_w = 1;

        end 

        // else if (cs == 0) begin
        //     o_i_valid_w = 1;
        // end
        
        else begin
            
        	o_i_valid_w = 0; 
            pc_w = pc_r;
            o_i_addr_w = pc_w;

            
        end

    end

    // check if instr is fetched.
    always @( *) begin
        for (i=0; i < 32; i=i+1)
            reg_file_w[i] = reg_file[i];

        if (cs == 6) begin

            // LD
            if (i_inst_temp[6:0] == 7'b0000011 
             && i_inst_temp[14:12] == 3'b011) begin
                
                imm[11:0] = i_inst_temp[31:20];
                rs1 = i_inst_temp[19:15];
                
                rs1_value = reg_file[rs1];
                rd = i_inst_temp[11:7]; 
                
                o_d_addr_w = {{52{imm[11]}}, imm[11:0]} + rs1_value;  //addr
                                           
                o_d_MemRead_w = 1;
                // o_d_MemWrite_w = 0;
                data_count = 1;
                // $display("%x", i_d_data);
                
            end


            // SD
            else if (i_inst_temp[6:0] == 7'b0100011 
                && i_inst_temp[14:12] == 3'b011) begin
                imm[4:0] = i_inst_temp[11:7];
                imm[11:5] = i_inst_temp[31:25];

                rs1 = i_inst_temp[19:15];
                rs1_value = reg_file[rs1];
                rs2 = i_inst_temp[24:20];
                // $display("%d %x %x %x %x %x", opcode, rs1, rs1_value, {{52{imm[11]}}, imm[11:0]}, o_d_addr_w, o_d_data_w);
                

                o_d_addr_w = {{52{imm[11]}}, imm[11:0]} + rs1_value;  //addr
                o_d_data_w = reg_file[rs2];                                         // data
                o_d_MemWrite_w = 1;
                // o_d_MemRead_w = 0;
                data_count = 1;
                
                
                
            end


            // ADDI
            else if (i_inst_temp[6:0] == 7'b0010011 
                && i_inst_temp[14:12] == 3'b000) begin
                
                rs1 = i_inst_temp[19:15];
                rd = i_inst_temp[11:7];  // 11:7
                // $display("%d %x", opcode, {{52{imm[11]}}, imm[11:0]} );
                rs1_value = reg_file[rs1];
                imm[11:0] = i_inst_temp[31:20];
                reg_file_w[rd] = {{52{imm[11]}}, imm[11:0]} + rs1_value; 
                o_d_MemWrite_w = 0;
                o_d_MemRead_w = 0;
            end            


            // OR
            else if (i_inst_temp[6:0] == 7'b0110011 
                    && i_inst_temp[31:25] == 7'b0000000
                    && i_inst_temp[14:12] == 3'b110) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];
                reg_file_w[rd] = reg_file[rs1] | reg_file[rs2];

            end

            // AND
            else if (i_inst_temp[6:0] == 7'b0110011 
                    && i_inst_temp[31:25] == 7'b0000000 
                    && i_inst_temp[14:12] == 3'b111) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];
                reg_file_w[rd] = reg_file[rs1] & reg_file[rs2];
            end

            // XOR
            else if (i_inst_temp[6:0] == 7'b0110011 
                    && i_inst_temp[31:25] == 7'b0000000 
                    && i_inst_temp[14:12] == 3'b100) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];
                reg_file_w[rd] = reg_file[rs1] ^ reg_file[rs2];
            end


            // ADD
            else if (i_inst_temp[6:0] == 7'b0110011 && i_inst_temp[31:25] == 7'b0000000) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];
                reg_file_w[rd] = reg_file[rs1] + reg_file[rs2];
            end

            // SUB
            else if (i_inst_temp[6:0] == 7'b0110011 && i_inst_temp[31:25] == 7'b0100000) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];
                reg_file_w[rd] = reg_file[rs1] - reg_file[rs2];
            end


            // XORI
            else if (i_inst_temp[6:0] == 0010011 
                  && i_inst_temp[14:12] == 3'b100) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                imm[11:0] = i_inst_temp[31:20];
                reg_file_w[rd] = reg_file[rs1] ^ {{52{imm[11]}}, imm[11:0]};
            end
            
            // ORI
            else if (i_inst_temp[6:0] == 0010011 
                  && i_inst_temp[14:12] == 3'b100) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                imm[11:0] = i_inst_temp[31:20];
                reg_file_w[rd] = reg_file[rs1] | {{52{imm[11]}}, imm[11:0]};
            end


            // ANDI
            else if (i_inst_temp[6:0] == 0010011 
                  && i_inst_temp[14:12] == 3'b100) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                imm[11:0] = i_inst_temp[31:20];
                reg_file_w[rd] = reg_file[rs1] & {{52{imm[11]}}, imm[11:0]};
            end


            // SLLI
            else if (i_inst_temp[6:0] == 7'b0010011 
                  && i_inst_temp[31:25] == 7'b0000000
                  && i_inst_temp[14:12] == 3'b001) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];  // shamt
                reg_file_w[rd] = reg_file[rs1] << reg_file[rs2];

            end

            // SRLI
            else if (i_inst_temp[6:0] == 7'b0010011 
                  && i_inst_temp[31:25] == 7'b0000000
                  && i_inst_temp[14:12] == 3'b101) begin
                rd = i_inst_temp[11:7];
                rs1 = i_inst_temp[19:15];
                rs2 = i_inst_temp[24:20];  // shamt
                reg_file_w[rd] = reg_file[rs1] >> reg_file[rs2];
            end


            // BEQ

            else if (i_inst_temp[6:0] == 7'b1100011 
                  && i_inst_temp[14:12] == 3'b000) begin
                      if (i_inst_temp[19:15] == i_inst_temp[24:20])
                            pc_w = pc_r + 
                                    ({i_inst_temp[31], i_inst_temp[7], i_inst_temp[30:25],i_inst_temp[11:8]} << 1);
                
            end


            // BNE

            else if (i_inst_temp[6:0] == 7'b1100011 
                  && i_inst_temp[14:12] == 3'b001) begin
                      if (i_inst_temp[19:15] != i_inst_temp[24:20])
                            pc_w = pc_r + 
                                ({i_inst_temp[31], i_inst_temp[7], i_inst_temp[30:25],i_inst_temp[11:8]} << 1);
                
            end




            else if (i_inst_temp[6:0] == 7'b1111111) begin
                o_finish_w = 1;
            end        
        end
        else begin
            o_d_MemWrite_w = 0;
            o_finish_w = 0;
            o_d_data_w = 0;
            o_d_MemRead_w = 0;
        end
            
            
    end


    // clock for data mem
    always @(*) begin
        case (dcs) //current state
            0: dns = (data_count)? 1 : 0;  // dns: next state
            1: begin
                if (o_d_MemWrite_r) begin
                    o_d_MemWrite_w = 0;
                end
                else if(o_d_MemRead_r) begin
                    o_d_MemRead_w = 0;
                end
                dns = 2;
            end
            2: dns = 3;
            3: dns = 4;
            4: dns = 5;
            5: dns = 6;
            6: dns = 7;
            7: dns = 8;
            8: dns = 9;
            9: dns = 10;
            10: begin
                dns = 0;
                data_count = 0;
            end
        endcase

        if (i_d_valid_data) begin
            
            reg_file[i_inst_temp[11:7]] = i_d_data;
            

        end
    end



    // sequential
    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            pc_r           <= 0;   
            cs             <= 0;
            dcs            <= 0;
            o_i_valid_r    <= 0;
            o_finish_r     <= 0;
            o_i_addr_r     <= 0;
            o_d_data_r     <= 0;
            o_d_addr_r     <= 0;
            o_d_MemWrite_r <= 0;
            o_d_MemRead_r  <= 0;
            data_count     <= 0;
            i_inst_temp    <= 64'b0;

            for (i=0; i < 32; i=i+1)
                reg_file[i] <= 64'b0;

        end else begin
            
            pc_r           <= pc_w;
            cs             <= ns;
            dcs            <= dns;
            o_i_valid_r    <= o_i_valid_w;
            o_finish_r     <= o_finish_w;
            o_i_addr_r     <= o_i_addr_w;
            o_d_data_r     <= o_d_data_w;
            o_d_addr_r     <= o_d_addr_w;
            o_d_MemWrite_r <= o_d_MemWrite_w;
            o_d_MemRead_r  <= o_d_MemRead_w;
            
            

            for (i=0; i < 32; i=i+1)
                reg_file[i] <= reg_file_w[i];
            
        end
    end



endmodule //cpu

