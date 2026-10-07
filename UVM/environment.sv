class env extends uvm_env;

  `uvm_component_utils(env)

  agent      agt;
  scoreboard scb;
  my_cov     cov;


  function new(string name, uvm_component parent);

    super.new(name, parent);

  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    agt = agent::type_id::create(
        "agt",
        this
    );

    scb = scoreboard::type_id::create(
        "scb",
        this
    );

    cov = my_cov::type_id::create(
        "cov",
        this
    );

  endfunction


  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);


    // Monitor -> Scoreboard
    agt.mon.item_collected_port.connect(
        scb.item_collected_imp
    );


    // Monitor -> Coverage
    agt.mon.item_collected_port.connect(
        cov.analysis_export
    );

  endfunction

endclass