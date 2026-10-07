`include "environment.sv"
class test extends uvm_test;
  `uvm_component_utils(test)
  
  add_sequence seq;
  env ENV;
  
  function new(string name= "test", uvm_component parent=null);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    seq=add_sequence::type_id::create("seq");
    ENV=env::type_id::create("ENV",this);

  endfunction : build_phase
 
  
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      
      seq.start(ENV.agnt.sequencer1);
      
      phase.drop_objection(this);
    endtask:run_phase
  
virtual function void end_of_elaboration_phase (uvm_phase phase);
uvm_top.print_topology ();
endfunction
    
    endclass:test
    	