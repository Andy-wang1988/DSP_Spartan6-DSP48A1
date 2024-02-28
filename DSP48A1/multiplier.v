module multiplier (
	input [17:0] b1_reg, a1_reg,
	output [35:0] multiplier_out );

       assign multiplier_out = b1_reg*a1_reg;

endmodule       
