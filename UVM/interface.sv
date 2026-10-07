interface add_if (
    input logic clk,
    input logic reset
);

  logic [3:0] A;
  logic [3:0] B;
  logic [4:0] Sum;

  logic valid;


  // Driver drives inputs at negedge.
  clocking driver_cb @(negedge clk);

    default input #1step output #0;

    output A;
    output B;
    output valid;

    input Sum;

  endclocking


  // Monitor also observes at negedge.
  // input #1step means it observes values BEFORE
  // the driver places the next transaction.
  clocking monitor_cb @(negedge clk);

    default input #1step output #0;

    input A;
    input B;
    input Sum;
    input valid;

  endclocking


  modport DRIVER (
    clocking driver_cb,
    input clk,
    input reset
  );


  modport MONITOR (
    clocking monitor_cb,
    input clk,
    input reset
  );


  initial begin
    A     = 0;
    B     = 0;
    valid = 0;
  end

endinterface