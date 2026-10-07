module ADDER (
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [4:0] Sum
);

  always_ff @(posedge clk or posedge reset) begin

    if (reset)
      Sum <= 5'b0;
    else
      Sum <= {1'b0, A} + {1'b0, B};

  end

endmodule