module dispatch_unit #(parameter CORE = 0, DATA_WIDTH = 32, INDEX_WIDTH = 3)(
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

wire[4:0] ins_dest;
wire[4:0] ins_src1;
wire[4:0] ins_src2;

//Instruction status
//FORMAT:[ISSUE:READ:EX:WB]  -- index corresponds to depth
reg[3:0] ins_stat[7:0];

//ID status
//FORMAT: [OPCODE(7):ID_DEST(5)]
reg[11:0] id_stat;

//EXE status (only 1 functional unit)
//FORMAT: [OPCODE(7):EXE_DEST(5)]
reg[11:0] exe_stat;

//MEM status
//FORMAT: [OPCODE(7):MEM_DEST(5)]
reg[11:0] mem_stat;

//WB status
//FORMAT: [OPCODE(7):WB_DEST(5)]
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
  if (~reset) begin
    id_stat[11:5] <= id_opcode;
    id_stat[4:0] <= id_dest;
    exe_stat[11:5] <= exe_opcode;
    exe_stat[4:0] <= exe_dest;
    mem_stat[11:5] <= mem_opcode;
    mem_stat[4:0] <= mem_dest;
    wb_stat[11:5] <= wb_opcode;
    wb_stat[4:0] <= wb_dest;
    
  else if (reset) begin
    id_stat <= 0;
    exe_stat <= 0;
    mem_stat <= 0;
    wb_stat <= 0;
    queue_top <= 0;
    queue_bot <= 1;
  end
end

endmodule