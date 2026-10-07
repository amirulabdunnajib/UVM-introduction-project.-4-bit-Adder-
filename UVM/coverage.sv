class my_cov extends uvm_subscriber #(seq_item);

  `uvm_component_utils(my_cov)

  seq_item tr;


  covergroup my_coverage;

    option.comment = "Coverage for an Adder";


    // Every A value: 0-15
    val_A: coverpoint(tr.a)
    {
      bins a_values[16] = {[0:15]};
    }


    // Every B value: 0-15
    val_B: coverpoint(tr.b)
    {
      bins b_values[16] = {[0:15]};
    }


    // Every legal sum: 0-30
    val_sum: coverpoint(tr.sum)
    {
      bins sum_values[31] = {[0:30]};

      illegal_bins impossible_sum = {31};
    }


    // Carry / no carry
    val_carry: coverpoint(tr.sum[4])
    {
      bins no_carry = {0};
      bins carry    = {1};
    }


    // 16 x 16 = 256 combinations
    combi: cross val_A, val_B;

  endgroup : my_coverage


  function new(string name, uvm_component parent);

    super.new(name, parent);

    my_coverage = new();

  endfunction


  virtual function void write(seq_item t);

    tr = t;

    my_coverage.sample();

  endfunction


  virtual function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info(
        "COVERAGE",
        $sformatf(
            "FINAL COVERAGE = %0.2f %%",
            my_coverage.get_coverage()
        ),
        UVM_LOW
    )

  endfunction

endclass