
interface add_if(input logic clk,reset);


  logic [3:0] A;
  logic [3:0] B;
  logic [4:0] Sum;
  
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output A;
    output B;
    input  Sum;  
  endclocking

  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input A;
    input B;
    input Sum;  
  endclocking
  
  modport DRIVER  (clocking driver_cb,input clk,reset);
  modport MONITOR (clocking monitor_cb,input clk,reset);
    
    `include "assertion.sv"
  
endinterface