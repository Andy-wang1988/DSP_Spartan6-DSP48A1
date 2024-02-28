module top_module #(parameter B_INPUT="DIRECT", D_REG=1,B0_REG=0,
	A0_REG=0, C_REG=1, RSTTYPE="SYNC", A1_REG=1,
	B1_REG=1, OPMODE_REG=1, MREG=1, CARRYINSEL="OPMODE5",
	CARRYINREG=1,PREG=1, 
	CARRYOUTREG=1) (
	input clk, //
	input [17:0] bcin, //
	input [17:0] d, b, a, 
	input [47:0] c, //
	input [7:0] opmode, //
	input [47:0] pcin,
	input carryin, //
  	input CEA, CEB, CEC, CED, CEOPMODE,CEM, CECARRYIN, CEP,
  	input RSTA, RSTB, RSTC, RSTD, RSTOPMODE, RSTM, RSTCARRYIN, RSTP,
  	output [17:0] bcout,
	output [35:0] M,
  	output CARRYOUT, CARRYOUTF,
  	output [47:0] P, PCOUT
	);

	wire [17:0] d_reg, a1_reg, b1_reg;
	wire [47:0] c_reg ;

	stage_1 #(
	B_INPUT, D_REG, B0_REG,
	A0_REG, C_REG, RSTTYPE, A1_REG,
	B1_REG, OPMODE_REG) stage_01
(
	bcin,
	d, b, a, c,
	opmode[6], opmode[4],
	CEA, CEB, CEC, CED, CEOPMODE,
	clk,
	RSTA, RSTB, RSTC, RSTD, RSTOPMODE,
	d_reg, a1_reg, b1_reg, c_reg
	);

    wire [47:0] DAB;
    wire [35:0] m_reg;
    wire [47:0] pin_out;
    wire carryin_reg;
    wire [47:0] c_reg_out;

    stage_2 #(RSTTYPE, MREG, CARRYINSEL,
	CARRYINREG, OPMODE_REG) stage_02

  (  d_reg, b1_reg, a1_reg, c_reg,
  	pcin,
  	opmode[5], carryin,
  	CEM, CECARRYIN, CEOPMODE,
  	RSTM, RSTCARRYIN, RSTOPMODE,
    clk,
    DAB,
  	bcout,
  	m_reg,
  	carryin_reg,
  	c_reg_out,
  	pin_out);

  stage_3  #(RSTTYPE, PREG, 
	CARRYOUTREG, OPMODE_REG) stage_03
  (
  	DAB,
  	m_reg,
  	opmode[1:0],
  	c_reg_out,
  	pin_out,
  	opmode[3:2],
  	opmode[7], carryin_reg, clk,
  	CECARRYIN, CEOPMODE, CEP,
  	RSTCARRYIN, RSTOPMODE, RSTP,
  	M,
  	CARRYOUT, CARRYOUTF,
  	P, PCOUT);

endmodule

`timescale 1ns/1ps
module top_module_tb #(parameter B_INPUT="DIRECT", D_REG=1,B0_REG=0,
	A0_REG=0, C_REG=1, RSTTYPE="SYNC", A1_REG=1,
	B1_REG=1, OPMODE_REG=1, MREG=1, CARRYINSEL="OPMODE5",
	CARRYINREG=1,PREG=1, 
	CARRYOUTREG=1) ();
	reg clk; //
	reg bcin; //
	reg [17:0] d, b, a;
	reg [47:0] c; //
	reg [7:0] opmode; //
	reg [47:0] pcin;
	reg carryin; //
  	reg CEA, CEB, CEC, CED, CEOPMODE,CEM, CECARRYIN, CEP;
  	reg RSTA, RSTB, RSTC, RSTD, RSTOPMODE, RSTM, RSTCARRYIN, RSTP;
  	wire [17:0] bcout;
	wire [35:0] M;
  	wire CARRYOUT, CARRYOUTF;
  	wire [47:0] P, PCOUT;

  	top_module #(B_INPUT, D_REG, B0_REG,
	A0_REG, C_REG, RSTTYPE, A1_REG,
	B1_REG, OPMODE_REG, MREG, CARRYINSEL,
	CARRYINREG,PREG, 
	CARRYOUTREG) dut 
	(
	clk, //
	bcin, //
	d, b, a, c, //
	opmode, //
	pcin,
	carryin, //
  	CEA, CEB, CEC, CED, CEOPMODE,CEM, CECARRYIN, CEP,
  	RSTA, RSTB, RSTC, RSTD, RSTOPMODE, RSTM, RSTCARRYIN, RSTP,
  	bcout,
	M,
  	CARRYOUT, CARRYOUTF,
  	P, PCOUT);

  	initial begin
  		clk=0;
  		forever 
  		 #10 clk=~clk;
  	end 

  	initial begin
      {RSTA, RSTB, RSTC, RSTD, RSTOPMODE, RSTM, RSTCARRYIN, RSTP}=8'b1111_1111;
      {CEA, CEB, CEC, CED, CEOPMODE,CEM, CECARRYIN, CEP}=8'b1111_1111;
      @(negedge clk);
       {RSTA, RSTB, RSTC, RSTD, RSTOPMODE, RSTM, RSTCARRYIN, RSTP}=8'b0000_0000;
    repeat(100) begin
	 bcin=$random; //
	 d=$random; b=$random; a=$random; c=$random; //
	 opmode=$random; //
	 pcin=$random;
	 carryin=$random;
     repeat(4) @(negedge clk);
    end
    $stop;
  end

endmodule  
