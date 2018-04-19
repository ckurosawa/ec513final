module control_interlock(id_exe_regWrite, //write enable
                         id_exe_write_reg, //write rgister
                         exe_mem_regWrite,
                         exe_mem_write_reg,
                         mem_wb_regWrite,
                         mem_wb_write_reg,
                         
                         if_id_opcode,
                         if_id_read_reg1,
                         if_id_read_reg2,
                         
                         stall
);
input id_exe_regWrite;
input exe_mem_regWrite;
input mem_wb_regWrite;
input[4:0] id_exe_write_reg;
input[4:0] exe_mem_write_reg;
input[4:0] mem_wb_write_reg;

input[4:0] if_id_read_reg1;
input[4:0] if_id_read_reg2;
input[6:0] if_id_opcode;

output stall;

localparam [6:0]R_TYPE  = 7'b0110011,
                I_TYPE  = 7'b0010011,
                STORE   = 7'b0100011,
                LOAD    = 7'b0000011,
                BRANCH  = 7'b1100011,
                JALR    = 7'b1100111,
                JAL     = 7'b1101111,
                AUIPC   = 7'b0010111,
                LUI     = 7'b0110111,
                FENCES  = 7'b0001111,
                SYSCALL = 7'b1110011;

//reg1 read enable true = ALU, ALUi, LW, SW, BR, JALR
//reg2 read enable true = ALU, SW, BR
wire reg1Read;
wire reg2Read;
assign reg1Read = ((if_id_opcode == R_TYPE) | (if_id_opcode == I_TYPE) | (if_id_opcode == STORE) | (if_id_opcode == LOAD) | (if_id_opcode == BRANCH) | (if_id_opcode == JALR)) ? 1:0;
assign reg2Read = ((if_id_opcode == R_TYPE) | (if_id_opcode == STORE) | (if_id_opcode == BRANCH)) ? 1:0;


//READ after WRITE data hazard
assign stall = (((reg1Read & id_exe_regWrite) & (if_id_read_reg1 == id_exe_write_reg)) |
               ((reg1Read & exe_mem_regWrite) & (if_id_read_reg1 == exe_mem_write_reg)) |
               ((reg1Read & mem_wb_regWrite) & (if_id_read_reg1 == mem_wb_write_reg)) |
               ((reg2Read & id_exe_regWrite) & (if_id_read_reg1 == id_exe_write_reg)) |
               ((reg2Read & exe_mem_regWrite) & (if_id_read_reg1 == exe_mem_write_reg)) |
               ((reg2Read & mem_wb_regWrite) & (if_id_read_reg1 == mem_wb_write_reg)))? 1:0;

endmodule