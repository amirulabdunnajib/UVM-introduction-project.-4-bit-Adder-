class seq_item extends uvm_sequence_item;

  `uvm_object_utils(seq_item)

  rand bit [3:0] a;
  rand bit [3:0] b;

       bit [4:0] sum;


  function new(string name = "seq_item");

    super.new(name);

  endfunction

endclass