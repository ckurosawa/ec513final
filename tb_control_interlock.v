module tb_control_interlock();

reg clock, reset;

reg id_exe_regWrite, exe_mem_regWrite, mem_wb_regWrite;
reg[4:0] id_exe_write_reg, exe_mem_write_reg, mem_wb_write_reg;

reg[6:0] if_id_opcode;
reg[4:0] if_id_reg1;
reg[4:0] if_id_reg2;

control_interlock(.clock(clock),
                  .reset(reset),
                  
                  //Post ID feedback
                  .id_exe_regWrite(id_exe_regWrite), //write enable
                  .id_exe_write_reg(id_exe_write_reg), //write rgister
                  .exe_mem_regWrite(exe_mem_regWrite),
                  .exe_mem_write_reg(),
                  .mem_wb_regWrite(),
                  .mem_wb_write_reg(),
                  
                  //ID Inputs
                  .if_id_opcode(),
                  .if_id_read_reg1(),
                  .if_id_read_reg2(),
                  
                  //Stall output
                  .stall()
);

always #1 clock = ~clock; //Clock generator

initial begin
  clock = 0;
  reset = 1;

endmodule