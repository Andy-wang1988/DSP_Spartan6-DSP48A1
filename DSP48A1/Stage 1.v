module stage_1 #(
	parameter B_INPUT="DIRECT", D_REG=1,B0_REG=0,
	A0_REG=0, C_REG=1, RSTTYPE="SYNC", A1_REG=1,
	B1_REG=1, OPMODE_REG=1) 
(
	input [17:0] bcin,
	input [17:0] d, b, a, 
	input [47:0] c,
	input opmode6, opmode4,
	input CEA, CEB, CEC, CED, CEOPMODE,
	input clk,
	input RSTA, RSTB, RSTC, RSTD, RSTOPMODE,
	output [17:0] d_reg, a1_reg, b1_reg,
	output [47:0] c_reg
	);
      
      
    wire [17:0] b_cin_out;
    wire [17:0] b0_reg, a0_reg;
    wire op4_reg, op6_reg;
    wire [17:0] pre_adder_sub_out;
    wire [17:0] mux_op4_out;

    reg_mux #(.REG(D_REG), .Width(18), .RSTTYPE(RSTTYPE))
    d__reg (clk, CED, RSTD, d, d_reg);

	mux_bin #( .B_INPUT(B_INPUT)) 
	mux_bin (b, bcin,b_cin_out);

	reg_mux #( .REG(B0_REG), .Width(18), .RSTTYPE(RSTTYPE))
    b0__reg (clk, CEB, RSTB, b_cin_out, b0_reg);

    reg_mux #( .REG(A0_REG), .Width(18), .RSTTYPE(RSTTYPE))
    a0__reg (clk, CEA, RSTA, a, a0_reg);

    reg_mux #(.REG(C_REG), .Width(48), .RSTTYPE(RSTTYPE))
    C__reg (clk, CEC, RSTC, c, c_reg);

    reg_mux #(.REG(OPMODE_REG), .Width(1), .RSTTYPE(RSTTYPE))
    op6__reg (clk, CEOPMODE, RSTOPMODE, opmode6, op6_reg);

    pre_adder_sub p_a_s (op6_reg, d_reg, b0_reg, pre_adder_sub_out);

    reg_mux #(.REG(OPMODE_REG), .Width(1), .RSTTYPE(RSTTYPE))
    op4__reg (clk, CEOPMODE, RSTOPMODE, opmode4, op4_reg);

    mux_op4 mux_op4 (op4_reg, pre_adder_sub_out, b0_reg, mux_op4_out);

    reg_mux #(.REG(B1_REG), .Width(18), .RSTTYPE(RSTTYPE))
    b1__reg (clk, CEB, RSTB, mux_op4_out, b1_reg);

    reg_mux #(.REG(A1_REG), .Width(18), .RSTTYPE(RSTTYPE))
    a1__reg (clk, CEA, RSTA, a0_reg, a1_reg);


endmodule    

`timescale 1ns/1ps
module stage_1_tb  #(
	parameter B_INPUT="DIRECT", D_REG=1,B0_REG=0,
	A0_REG=0, C_REG=1, RSTTYPE="SYNC", A1_REG=1,
	B1_REG=1, OPMODE_REG=1) ();
      
    reg bcin;
	reg [17:0] d, b, a, c;
	reg opmode6, opmode4;
	reg CEA, CEB, CEC, CED, CEOPMODE;
	reg clk;
	reg RSTA, RSTB, RSTC, RSTD, RSTOPMODE;
	wire [17:0] d_reg, a1_reg, b1_reg, c_reg;

	stage_1 #(B_INPUT, D_REG, B0_REG,
	A0_REG, C_REG, RSTTYPE, A1_REG,
	B1_REG, OPMODE_REG) dut
(
	bcin,
	d, b, a, c,
	opmode6, opmode4,
	CEA, CEB, CEC, CED, CEOPMODE,
	clk,
	RSTA, RSTB, RSTC, RSTD, RSTOPMODE,
	d_reg, a1_reg, b1_reg, c_reg
	);

	initial begin
		clk=0;
		forever 
		  #10 clk=~clk;
	end

	initial begin
		{RSTA, RSTB, RSTC, RSTD, RSTOPMODE}=5'b11111;
		{CEA, CEB, CEC, CED, CEOPMODE}=5'b11111;
		@(negedge clk);
		{RSTA, RSTB, RSTC, RSTD, RSTOPMODE}=5'b00000;

		repeat(100) begin
			bcin=$random;
			d=$random;
			b=$random;
			a=$random;
			c=$random;
			opmode6=$random;
			opmode4=$random;
			@(negedge clk);
		end
		$stop;
	end
endmodule

     


