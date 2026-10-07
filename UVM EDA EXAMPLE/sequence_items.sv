//CREATING A SEQUENCE ITEM

class seq_item extends uvm_sequence_item;
  
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(A,UVM_ALL_ON)
  `uvm_field_int(B,UVM_ALL_ON)
  `uvm_field_int(Sum,UVM_ALL_ON)
  `uvm_object_utils_end
  
  rand bit[3:0] A;
  rand bit[3:0] B;
  bit[4:0] Sum;
  
  function new(string name= "seq_item");
    super.new(name);
  endfunction

  constraint cons{A inside {1,2,5};};
endclass

  