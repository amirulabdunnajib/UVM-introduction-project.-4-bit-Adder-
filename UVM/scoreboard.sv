class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_analysis_imp #(seq_item, scoreboard)
      item_collected_imp;

  int pass_count;
  int fail_count;


  function new(string name, uvm_component parent);

    super.new(name, parent);

    item_collected_imp =
        new("item_collected_imp", this);

    pass_count = 0;
    fail_count = 0;

  endfunction


  virtual function void write(seq_item trans);

    bit [4:0] expected_sum;

    // Extend operands to 5 bits before addition.
    expected_sum =
        {1'b0, trans.a} + {1'b0, trans.b};


    if (trans.sum == expected_sum) begin

      pass_count++;

      `uvm_info(
          "SCB",
          $sformatf(
              "PASS: a=%0d b=%0d expected=%0d actual=%0d",
              trans.a,
              trans.b,
              expected_sum,
              trans.sum
          ),
          UVM_LOW
      )

    end
    else begin

      fail_count++;

      `uvm_error(
          "SCB",
          $sformatf(
              "FAIL: a=%0d b=%0d expected=%0d actual=%0d",
              trans.a,
              trans.b,
              expected_sum,
              trans.sum
          )
      )

    end

  endfunction


  virtual function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info(
        "SCB_REPORT",
        $sformatf(
            "FINAL SCOREBOARD: PASS=%0d FAIL=%0d TOTAL=%0d",
            pass_count,
            fail_count,
            pass_count + fail_count
        ),
        UVM_LOW
    )

  endfunction

endclass