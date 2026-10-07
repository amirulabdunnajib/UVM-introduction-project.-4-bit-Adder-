class add_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(add_sequence)
    `uvm_declare_p_sequencer(sequencer)
  
  function new(string name = "add_sequence");
    super.new(name);
  endfunction
  
  virtual task body(); 
    repeat(20) begin
       req=seq_item::type_id::create("req");
      start_item(req);                //can be replaced by `uvm_do(req) macro
      assert(req.randomize());
    finish_item(req);
    end
  endtask
  
endclass
