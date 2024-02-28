module mux_bin #(parameter B_INPUT="DIRECT") (
	input [17:0] b,
	input [17:0] bcin,
	output [17:0] out);

       generate
       	if(B_INPUT=="DIRECT")
       	  assign out = b;
       	else if (B_INPUT=="CASCADE")
       	  assign out = bcin;
       	else 
       	  assign out = 0;    
       	
       endgenerate
endmodule

`timescale 1ns/1ps
module mux_bin_tb #(parameter B_INPUT="DIRECT") ();
  reg [17:0] b;
  reg [17:0] bcin;
  wire [17:0] out;

  mux_bin #(B_INPUT) dut (b, bcin, out);
  initial begin
  	repeat (10) begin
  		b=$random;
  		bcin=$random;
  		#10;
  	end
  	$stop;
  end	

endmodule  	