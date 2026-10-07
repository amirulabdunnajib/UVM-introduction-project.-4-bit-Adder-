
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class env extends uvm_env;
  
  agent agnt;
  scoreboard scb;
   my_cov cov;
  
  `uvm_component_utils(env)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agnt=agent::type_id::create("agnt",this);
    scb=scoreboard::type_id::create("scb",this);
    cov=my_cov::type_id::create("cov",this);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    agnt.monitor1.item_collected_port.connect(scb.item_collected_export);
    agnt.monitor1.item_collected_port.connect(cov.analysis_export); 
  endfunction: connect_phase
    
 endclass:env
    
    