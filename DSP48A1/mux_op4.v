module mux_op4 (
	input opmode4,
	input [17:0] add_sub,
	input [17:0] b,
	output [17:0] out);

       assign out = opmode4 ? add_sub:b;

endmodule

`timescale 1ns/1ps
module mux_op4_tb ();

  reg opmode4;
  reg [17:0] add_sub,b;
  wire [17:0] out;

  mux_op4 dut (opmode4, add_sub, b, out) ;

  initial begin
  	repeat(10) begin
  		opmode4=$random;
  		add_sub=$random;
  		b=$random;
  		#10;
  	end
  end

endmodule         
