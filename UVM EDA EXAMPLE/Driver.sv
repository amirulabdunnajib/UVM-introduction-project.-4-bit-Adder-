`define DRIV_if vif.DRIVER.driver_cb

class driver extends uvm_driver#(seq_item);
  `uvm_component_utils(driver)
  
  virtual add_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
//--------------------------------------------------------------------------
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual add_if)::get(this, "","vif",vif))
    `uvm_fatal("No_Vif", {"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
//--------------------------------------------------------------------------
  virtual task run_phase(uvm_phase phase);
    
    forever begin  //Driver-Sequencer handshake
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask: run_phase
  
//-------------------------------------------------------------------------
  
  virtual task drive();
    @(posedge vif.DRIVER.clk);
    `DRIV_if.A<=req.A;
    `DRIV_if.B<=req.B;
      @(posedge vif.DRIVER.clk);
      req.Sum<=`DRIV_if.Sum;
      @(posedge vif.DRIVER.clk);
    
  endtask: drive
  
endclass:driver 