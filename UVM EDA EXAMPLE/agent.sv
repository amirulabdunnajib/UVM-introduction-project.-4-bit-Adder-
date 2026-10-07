`include "sequence_items.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "Driver.sv"
`include "monitor.sv"

class agent extends uvm_agent;
  sequencer sequencer1;
  driver driver1;
  monitor monitor1;
  
  `uvm_component_utils(agent)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    endfunction:new
    
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        
        driver1 = driver::type_id::create("driver1",this);
        sequencer1 = sequencer::type_id::create("sequencer1",this);
      
    monitor1 = monitor::type_id::create("monitor1",this);
    endfunction: build_phase
    
    function void connect_phase(uvm_phase phase);
 
        driver1.seq_item_port.connect(sequencer1.seq_item_export);

    endfunction: connect_phase
    endclass: agent
    
      