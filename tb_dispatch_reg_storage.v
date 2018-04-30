module tb_dispatch_reg_storage();

reg clock;
reg reset;

reg reg_insert;
reg[4:0] reg_rs1;
reg[4:0] reg_rs2;
reg[4:0] reg_rW;
reg[3:0] reg_indexIns;

reg reg_delete;
reg[3:0] reg_indexDel;

reg[4:0] reg_indexRead;
wire[14:0] reg_outRead;

dispatch_reg_storage #(0, 5, 4) reg_stg(
  .clock(clock),
  .reset(reset),
  
  .reg_insert(reg_insert),
  .reg_rs1(reg_rs1),
  .reg_rs2(reg_rs2),
  .reg_rW(reg_rW),
  .reg_indexIns(reg_indexIns),
  
  .reg_delete(reg_delete),
  .reg_indexDel(reg_indexDel),
  
  .reg_indexRead(reg_indexRead),
  .reg_outRead(reg_outRead)
);

always #1 clock = ~clock;

initial begin
  clock = 0;
  reset = 1;
  reg_insert = 0;
  reg_rs1 = 0;
  reg_rs2 = 0;
  reg_rW = 0;
  reg_indexIns = 0;
  reg_delete = 0;
  reg_indexDel = 0;
  reg_indexRead = 0;
  
  #5 reset = 0;
  $display("----START----");
  repeat (1) @ (posedge clock);
  reg_insert = 1;
  reg_rs1 = 5'b01010;
  reg_rs2 = 5'b10101;
  reg_rW = 5'b11100;
  reg_indexIns = 0;
  
  repeat (1) @ (posedge clock);
  reg_insert = 0;
  reg_indexRead = 0;
  
  
end
endmodule