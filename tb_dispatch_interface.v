module tb_dispatch_interface ();

reg clock;
reg reset;
reg write;
reg[7:0] in_address;
reg[31:0] in_data;

reg read;
reg[7:0] out_address;
wire[31:0] out_data;

reg report;
  
dispatch_interface #(0, 32, 8) D_I(
  .clock(clock),
  .reset(reset),
  .read(read),
  .write(write),
  .in_address(in_address),
  .in_data(in_data),
  .out_address(out_address),
  .out_data(out_data),
  .report(report)
);

always #1 clock = ~clock;

initial begin
  $dumpfile("disp_interface.vcd");
  $dumpvars();
  clock = 0;
  reset = 1;
  read = 0;
  write = 0;
  in_address = 0;
  out_address = 0;
  report = 0;
  
  #10 reset = 0;
  $display("----Start----");
  repeat (1) @ (posedge clock);
  
  in_address <= 0;
  write <= 1;
  in_data <= 32'b0000_0001_0100_1101;
  report <= 1;
  
  repeat (1) @ (posedge clock);
  in_address <= 1;
  write <= 1;
  in_data <= 32'b0011_0011_0011_0011;
  
  repeat (1) @ (posedge clock);
  write <= 0;
  
  repeat (1) @ (posedge clock);
  read <= 1;
  out_address <= 0;
  
  repeat (1) @ (posedge clock);
  read <= 0;
  out_address <= 1;
end

endmodule