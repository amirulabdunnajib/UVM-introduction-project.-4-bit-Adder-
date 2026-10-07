class test extends uvm_test;

  `uvm_component_utils(test)

  exhaustive_sequence seq;
  env ENV;


  function new(
      string name = "test",
      uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq =
        exhaustive_sequence::type_id::create(
            "seq"
        );

    ENV =
        env::type_id::create(
            "ENV",
            this
        );

  endfunction


  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);


    // Generate all 256 input combinations.
    seq.start(
        ENV.agt.seqr
    );


    // Do NOT finish until the monitor/scoreboard has
    // processed all 256 transactions.
    wait (
        (ENV.scb.pass_count +
         ENV.scb.fail_count) == 256
    );


    phase.drop_objection(this);

  endtask

endclass