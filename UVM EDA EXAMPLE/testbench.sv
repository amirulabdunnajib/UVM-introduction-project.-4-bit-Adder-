`include "uvm_macros.svh"
import uvm_pkg::*;
`include "interface.sv"
`include "test.sv"

module tbench_top;
   
  //clock and reset signal declaration
  bit clk;
  bit reset;
   
  //clock generation
  always #5 clk = ~clk;
   
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  add_if intf(clk,reset);
  
  ADDER DUT (
   			  .clk(intf.clk),
    		  .reset(intf.reset),
    		  .A(intf.A),
    		  .B(intf.B),
    		  .Sum(intf.Sum));
  
  initial begin
    uvm_config_db#(virtual add_if)::set(uvm_root::get(),"*","vif",intf);
    $dumpfile("dump.vcd"); $dumpvars;
  end
   
  initial begin
    run_test("test");
  end
endmodule
