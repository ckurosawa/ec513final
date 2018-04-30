module dispatch_reg_storage #(parameter CORE = 0, ADDRESS_WIDTH = 5, STAGES = 4)(
  clock,
  reset,
  
  reg_insert,
  reg_rs1,
  reg_rs2,
  reg_rW,
  reg_indexIns,
  
  reg_delete,
  reg_indexDel,
  
  reg_indexRead,
  reg_outRead
);
input clock;
input reset;

input reg_insert;
input[ADDRESS_WIDTH - 1:0] reg_rs1;
input[ADDRESS_WIDTH - 1:0] reg_rs2;
input[ADDRESS_WIDTH - 1:0] reg_rW;
input[STAGES - 1:0] reg_indexIns;

input reg_delete;
input[STAGES - 1:0] reg_indexDel;

input[STAGES - 1:0] reg_indexRead;
output[(ADDRESS_WIDTH * 3) - 1:0] reg_outRead;

wire[(ADDRESS_WIDTH * 3) - 1:0] write_data;
reg[(ADDRESS_WIDTH * 3) - 1:0] reg_map[0:STAGES - 1];

assign reg_outRead = reg_map[reg_indexRead];
assign write_data[(ADDRESS_WIDTH * 3) - 1:(ADDRESS_WIDTH * 2)] = reg_rs1;
assign write_data[(ADDRESS_WIDTH * 2) - 1:ADDRESS_WIDTH] = reg_rs2;
assign write_data[ADDRESS_WIDTH - 1:0] = reg_rW;

always @ (posedge clock) begin
  if(~reset) begin
    if(reg_insert) begin
      reg_map[reg_indexIns] <= write_data;
    end
    
    if(reg_delete) begin
      reg_map[reg_indexIns] <= 0;
    end
  end
end
endmodule