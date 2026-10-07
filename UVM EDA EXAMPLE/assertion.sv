property addition;
  logic [3:0] op_a,op_b;
  
  @(posedge clk)(reset==0, op_a=A , op_b=B) |=> (Sum==(op_a + op_b));
endproperty
assert property(addition);
  
  