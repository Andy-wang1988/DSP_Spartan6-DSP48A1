module mux_z (
	input [1:0] opmode32,
	input [47:0] c_reg,
	input [47:0] P_reg,
	input [47:0] pcin,
	input [47:0] zero,
	output reg [47:0] mux_out);

    always @(*) 
      case(opmode32)
        0: mux_out=zero;
        1: mux_out=pcin;
        2: mux_out=P_reg;
        3: mux_out=c_reg;
      endcase
endmodule
