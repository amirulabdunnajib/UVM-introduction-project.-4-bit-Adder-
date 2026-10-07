`define MON_IF vif.monitor_cb

class monitor extends uvm_monitor;
  
virtual add_if vif;
    `uvm_component_utils(monitor)
  
  uvm_analysis_port#(seq_item)item_collected_port;
  seq_item trans_collected;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    trans_collected=new();
    item_collected_port=new("item_collected_port", this);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if)::get(this,"","vif",vif))
    `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase  
  
  virtual task run_phase(uvm_phase phase);
    forever begin
  
      @(posedge vif.MONITOR.clk);
      trans_collected.A = `MON_IF.A;
      trans_collected.B = `MON_IF.B;
            @(posedge vif.MONITOR.clk);
      trans_collected.Sum = `MON_IF.Sum;
      $display("Values in trans_collected in monitor");
      trans_collected.print();
            @(posedge vif.MONITOR.clk);
      item_collected_port.write(trans_collected);
    end
  endtask: run_phase
  
endclass: monitor