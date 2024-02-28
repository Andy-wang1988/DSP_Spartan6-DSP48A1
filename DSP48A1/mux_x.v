module mux_x (
	input [1:0] opmode10,
	input [47:0] DAB,
	input [47:0] P_reg,
	input [35:0] m_reg,
	input [47:0] zero,
	output reg [47:0] mux_out);

    always @(*) 
      case(opmode10)
        0: mux_out=zero;
        1: mux_out={12'b0, m_reg};
        2: mux_out=P_reg;
        3: mux_out=DAB;
      endcase
endmodule