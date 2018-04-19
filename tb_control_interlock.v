module tb_control_interlock();
  reg clock;
  reg reset;
  
  //Write checks
  reg id_exe_regWrite;
  reg[4:0] id_exe_write_reg;
  reg exe_mem_regWrite;
  reg[4:0] exe_mem_write_reg;
  reg mem_wb_regWrite;
  reg[4:0] mem_wb_write_reg;
  
  //Read checks
  reg[6:0] if_id_opcode;
  reg[4:0] if_id_read_reg1;
  reg[4:0] if_id_read_reg2;
                  
  //Output(s)
  wire stall;
  
  //for readability
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
  
  control_interlock ci(
    .id_exe_regWrite(id_exe_regWrite),
    .id_exe_write_reg(id_exe_write_reg),
    .exe_mem_regWrite(exe_mem_regWrite),
    .exe_mem_write_reg(exe_mem_write_reg),
    .mem_wb_regWrite(mem_wb_regWrite),
    .mem_wb_write_reg(mem_wb_write_reg),
    
    .if_id_opcode(if_id_opcode),
    .if_id_read_reg1(if_id_read_reg1),
    .if_id_read_reg2(if_id_read_reg2),
    
    .stall(stall)
  );
  
  //clock gen
  always #1 clock = ~clock;
  
  initial begin
    clock = 0;
    reset = 0;
    $display (" --- Start --- ");
    repeat (1) @ (posedge clock);
    
    id_exe_regWrite <= 0;
    id_exe_write_reg <= 5'b00000;
    exe_mem_regWrite <= 0;
    exe_mem_write_reg <= 5'b00000;
    mem_wb_regWrite <= 0;
    mem_wb_write_reg <= 5'b00000;
    
    if_id_opcode <= 7'b0000000;
    if_id_read_reg1 <= 5'b00000;
    if_id_read_reg2 <= 5'b00000;
    
    repeat (1) @ (posedge clock);
    id_exe_regWrite <= 1;
    id_exe_write_reg <= 5'b00001;
    
    if_id_opcode <= R_TYPE;
    if_id_read_reg1 <= 5'b00001;
    if_id_read_reg2 <= 5'b00011;
      
    repeat (1) @ (posedge clock);
    id_exe_regWrite <= 0;
    exe_mem_regWrite <= 1;
    exe_mem_write_reg <= 5'b01010;
    if_id_opcode <= BRANCH;
    if_id_read_reg1 <= 5'b00010;
    if_id_read_reg2 <= 5'b01010;
      
    repeat (1) @ (posedge clock);
    if_id_opcode <= I_TYPE;
  end
    
  always @ (posedge clock) begin
    $display("ID Control: %h %h %h", if_id_opcode, if_id_read_reg1, if_id_read_reg2);
    $display("EXE Control: %h %h", id_exe_regWrite, id_exe_write_reg);
    $display("MEM Control: %h %h", exe_mem_regWrite, exe_mem_write_reg);
    $display("WB Control: %h %h", mem_wb_regWrite, mem_wb_write_reg);
    $display("Stall: %b", stall);
  end
endmodule