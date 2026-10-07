module ADDER(input logic clk, reset,
				input logic[3:0] A,B, 
             output logic [4:0] Sum);
  

always@(posedge clk)
if(reset)
Sum=5'b0;
else
Sum=A+B;
   
endmodule
  