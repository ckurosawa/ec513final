(* ram_style = "block" *)
module dispatch_interface #(parameter CORE = 0, DATA_WIDTH = 32, INDEX_WIDTH = 8, VALID_BIT = 1)(
  clock,
  reset,
  read,
  write,
  in_address,
  in_data,
  in_valid,
  out_address,
  out_data,
  report  
);
localparam OVERHEAD = VALID_BIT;

input clock;
input reset;

input write;
input in_valid;
input[INDEX_WIDTH - 1:0] in_address;
input[DATA_WIDTH - 1:0] in_data;

input read;
output[INDEX_WIDTH - 1:0] out_address;
output[DATA_WIDTH + OVERHEAD - 1:0] out_data;

input report;

wire[DATA_WIDTH + OVERHEAD - 1:0] in_databus; //Combine overhead w/ data in sram

assign in_databus[DATA_WIDTH + OVERHEAD - 1: DATA_WIDTH + OVERHEAD - VALID_BIT - 1] = in_valid;
assign in_databus[DATA_WIDTH + OVERHEAD - VALID_BIT - 1:0] =  in_data;

BSRAM #(CORE, DATA_WIDTH + OVERHEAD, INDEX_WIDTH) DIS_RAM(
  .clock(clock),
  .reset(reset),
  .readEnable(read),
  .readAddress(in_address),
  .readData(in_databus),
  
  .writeEnable(write),
  .writeAddress(out_address),
  .writeData(out_data),
  
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
    $display ("| Valid             [%b]", valid);
    $display ("----------------------------------------------------------------------");
  end
end

endmodule