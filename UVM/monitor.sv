class monitor extends uvm_monitor;

  `uvm_component_utils(monitor)

  virtual add_if.MONITOR vif;

  uvm_analysis_port #(seq_item) item_collected_port;


  function new(string name, uvm_component parent);

    super.new(name, parent);

    item_collected_port =
        new("item_collected_port", this);

  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual add_if.MONITOR)::get(
        this,
        "",
        "vif",
        vif
    ))
      `uvm_fatal(
          "NO_VIF",
          "Monitor virtual interface not found"
      )

  endfunction


  virtual task run_phase(uvm_phase phase);

    seq_item trans_collected;

    wait (vif.reset == 0);

    forever begin

      @(vif.monitor_cb);

      // Ignore cycles before the driver has sent a transaction.
      if (!vif.reset && vif.monitor_cb.valid) begin

        trans_collected =
            seq_item::type_id::create("trans_collected");

        trans_collected.a =
            vif.monitor_cb.A;

        trans_collected.b =
            vif.monitor_cb.B;

        trans_collected.sum =
            vif.monitor_cb.Sum;

        item_collected_port.write(
            trans_collected
        );

      end

    end

  endtask

endclass