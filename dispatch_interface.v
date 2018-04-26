(* ram_style = "block" *)
module dispatch_interface #(parameter CORE = 0, DATA_WIDTH = 32, INDEX_WIDTH = 3)(
  clock,
  reset,
  read,
  write,
  in_address,
  in_data,
  out_address,
  out_data,
  report
);

input clock;
input reset;

input write;
input[INDEX_WIDTH - 1:0] in_address;
input[DATA_WIDTH - 1:0] in_data;

input read;
input[INDEX_WIDTH - 1:0] out_address;
output[DATA_WIDTH - 1:0] out_data;

input report;

BSRAM #(CORE, DATA_WIDTH, INDEX_WIDTH) DISP_RAM(
  .clock(clock),
  .reset(reset),
  .readEnable(read),
  .readAddress(out_address),
  .readData(out_data),
  
  .writeEnable(write),
  .writeAddress(in_address),
  .writeData(in_data),
  
  .report(report)
);

reg[31:0] cycles;
always @ (posedge clock) begin
  cycles <= reset?  0:cycles + 1;
  if(report)begin
    $display ("------ Core %d Memory Interface - Current Cycle %d --", CORE, cycles); 
          
    $display ("| Input Address     [%h]", in_address);
    $display ("| Output Address    [%h]", out_address);
    $display ("| Read              [%b]", read);
    $display ("| Write             [%b]", write);
    $display ("| Out Data          [%h]", out_data);
    $display ("| In Data           [%h]", in_data);
    $display ("----------------------------------------------------------------------");
  end
end

endmodule