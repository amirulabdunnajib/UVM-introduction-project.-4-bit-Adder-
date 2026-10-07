`timescale 1ns/1ps

`include "uvm_macros.svh"

import uvm_pkg::*;


// --------------------------------------------------
// Files in dependency order
// --------------------------------------------------

`include "adder.sv"
`include "interface.sv"

`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"

`include "driver.sv"
`include "monitor.sv"

`include "scoreboard.sv"
`include "coverage.sv"

`include "agent.sv"
`include "environment.sv"

`include "adder_test.sv"


module top;

  logic clk;
  logic reset;


  // --------------------------------------------------
  // Interface
  // --------------------------------------------------

  add_if intf (
      .clk   (clk),
      .reset (reset)
  );


  // --------------------------------------------------
  // DUT
  // --------------------------------------------------

  ADDER dut (
      .clk   (clk),
      .reset (reset),
      .A     (intf.A),
      .B     (intf.B),
      .Sum   (intf.Sum)
  );


  // --------------------------------------------------
  // Clock
  // 10 ns period
  // --------------------------------------------------

  initial begin

    clk = 0;

    forever #5 clk = ~clk;

  end


  // --------------------------------------------------
  // Reset
  // --------------------------------------------------

  initial begin

    reset = 1;

    repeat (2)
      @(posedge clk);

    reset = 0;

  end


  // --------------------------------------------------
  // UVM
  // --------------------------------------------------

  initial begin


    // Driver gets DRIVER modport.
    uvm_config_db #(virtual add_if.DRIVER)::set(
        null,
        "uvm_test_top.ENV.agt.drv",
        "vif",
        intf
    );


    // Monitor gets MONITOR modport.
    uvm_config_db #(virtual add_if.MONITOR)::set(
        null,
        "uvm_test_top.ENV.agt.mon",
        "vif",
        intf
    );


    run_test("test");

  end


endmodule
