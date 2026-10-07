
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(seq_item,scoreboard)item_collected_export;
  seq_item data;
  
    seq_item pkt_qu[$];
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export=new("items_collected_export",this);
  endfunction:build_phase
  
  virtual function void write(seq_item trans_collected);
    `uvm_info(get_type_name(),$sformatf(" Value of sequence item in SCOREBOARD \n"),UVM_LOW)
    trans_collected.print();
    
      pkt_qu.push_back(trans_collected);
  endfunction:write
  
  virtual task run_phase(uvm_phase phase);
    seq_item seq;
    forever begin
      wait(pkt_qu.size()>0);
      seq=pkt_qu.pop_front();
      
      if(seq.A+seq.B == seq.Sum) begin
        `uvm_info(get_type_name(),$sformatf(" TEST PASS "),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf(" Value of A = %0d", seq.A),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf(" Value of B = %0d", seq.B),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf(" Value of Sum = %0d", seq.Sum),UVM_LOW)
        $display("-----------------------------------------------------------------------------");
      end
      else begin
        `uvm_info(get_type_name(),$sformatf(" TEST FAILED  "),UVM_LOW)
        end
      end
   
  endtask : run_phase
endclass : scoreboard