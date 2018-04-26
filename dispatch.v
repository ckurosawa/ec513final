module dispatch_unit #(parameter CORE = 0, DATA_WIDTH = 32, INDEX_WIDTH = 8)(
  clock,
  reset,
  report,
  
  //Inputs
  in_instruction,
  
  id_opcode,
  id_dest,
  exe_opcode,
  exe_dest,
  mem_opcode,
  mem_dest,
  wb_opcode,
  wb_dest,
  
  //Outputs
  out_instruction
);

reg[31:0] queue_top;
reg[31:0] queue_bot;

//Instruction status
//FORMAT:[ISSUE:READ:EX:WB]  -- index corresponds to depth
reg[3:0] ins_stat[7:0];

//ID status
//FORMAT: [OPCODE(7):ID_DEST(5):ID_SRC1(5):ID_SRC2(5)]
reg[11:0] id_stat;

//EXE status
//FORMAT: [OPCODE(7):EXE_DEST(5):EXE_SRC1(5):EXE_SRC2(5)]
reg[11:0] exe_stat; //only 1 functional unit

//MEM status
//FORMAT: [OPCODE(7):MEM_DEST(5):MEM_SRC1(5):MEM_SRC2(5)]
reg[11:0] mem_stat;

//WB status
//FORMAT: [OPCODE(7):WB_DEST(5):WB_SRC1(5):MEM_SRC2(5)]
reg[11:0] wb_stat;

//Holds instructions (sequential)
//Max # instructions is 8
dispatch_interface disp_int #(parameter CORE, DATA_WIDTH, INDEX_WIDTH)(
  .clock(clock),
  .reset(reset),
  .read(read_enable),
  .write(write_enable),
  .in_address(queue_bot), //address to write (comes from control)
  .in_data(in_instruction), //data to write
  .out_address, //address to read (comes from control)
  .out_data(out_instruction), //data read
  .report(report)
);

always @ (posedge clock) begin
  

endmodule