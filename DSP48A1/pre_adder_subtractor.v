module pre_adder_sub (
	input opmode6,
	input [17:0] d,
	input [17:0] b,
	output [17:0] out );

       assign out = opmode6 ? d-b : d+b;
endmodule

`timescale 1ns/1ps
module pre_adder_sub_tb ();

  reg opmode6;
  reg [17:0] d,b;
  wire [17:0] out;

  pre_adder_sub dut (opmode6, d, b, out) ;

  initial begin
  	repeat(10) begin
  		opmode6=$random;
  		d=$random;
  		b=$random;
  		#10;
  	end
  end

endmodule  