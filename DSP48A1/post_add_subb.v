module post_add_sub (
	input cin,
	input opmode7,
	input [47:0] x,
	input [47:0] z,
	output  [47:0] out,
	output cout);

      assign {cout,out} = opmode7? z-x+cin:z+x;

endmodule      


