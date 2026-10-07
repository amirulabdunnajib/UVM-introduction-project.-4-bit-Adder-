class driver extends uvm_driver #(seq_item);

  `uvm_component_utils(driver)

  virtual add_if.DRIVER vif;


  function new(string name, uvm_component parent);

    super.new(name, parent);

  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual add_if.DRIVER)::get(
        this,
        "",
        "vif",
        vif
    ))
      `uvm_fatal(
          "NO_VIF",
          "Driver virtual interface not found"
      )

  endfunction


  virtual task run_phase(uvm_phase phase);

    // Wait until reset is released.
    wait (vif.reset == 0);

    forever begin

      seq_item_port.get_next_item(req);

      @(vif.driver_cb);

      vif.driver_cb.A     <= req.a;
      vif.driver_cb.B     <= req.b;
      vif.driver_cb.valid <= 1'b1;

      seq_item_port.item_done();

    end

  endtask

endclass