(* ram_style = "block" *)
module dispatch_sram #(parameter DISP_SIZE = 10, INST_SIZE = 32)(
  clock,
  reset,
  
  readEnable,
  readAddress,
  readData,
  
  writeEnable,
  writeAddress,
  writeData,
  
  report
);

input clock;
input reset,
input enable;

input[INST_SIZE - 1:0] instruction_in;
input[DISP_SIZE - 1:0] index;

output 