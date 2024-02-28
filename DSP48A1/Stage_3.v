module stage_3  #(parameter RSTTYPE="SYNC", PREG=1, 
	CARRYOUTREG=1, OPMODE_REG=1)
  (
  	input [47:0] DAB,
  	input [35:0] m_reg,
  	input [1:0] opmode10,
  	input [47:0] c_reg,
  	input [47:0] pcin,
  	input [1:0] opmode32,
  	input opmode7, cin, clk,
  	input CECARRYIN, CEOPMODE, CEP,
  	input RSTCARRYIN, RSTOPMODE, RSTP,
  	output [35:0] M,
  	output CARRYOUT, CARRYOUTF,
  	output [47:0] P, PCOUT);

    wire [47:0] mux_x, mux_z;
    wire [1:0] opmode10_reg, opmode32_reg;
    wire opmode7_reg;
    wire carryout_next;
    wire [47:0] P_next;

    reg_mux #(.REG(OPMODE_REG), .Width(2), .RSTTYPE(RSTTYPE))
    op10__reg (clk, CEOPMODE, RSTOPMODE, opmode10, opmode10_reg);

    reg_mux #(.REG(OPMODE_REG), .Width(2), .RSTTYPE(RSTTYPE))
    op32__reg (clk, CEOPMODE, RSTOPMODE, opmode32, opmode32_reg);

    reg_mux #(.REG(OPMODE_REG), .Width(1), .RSTTYPE(RSTTYPE))
    op7__reg (clk, CEOPMODE, RSTOPMODE, opmode7, opmode7_reg);

    mux_x mux_xx(opmode10_reg, DAB, P, m_reg, 48'b0, mux_x);

	  mux_z mux_zz(opmode32_reg, c_reg, P, pcin, 48'b0, mux_z);

	  post_add_sub post_add_sub( cin, opmode7_reg, mux_x, mux_z, P_next, carryout_next);

	  reg_mux #(.REG(PREG), .Width(48), .RSTTYPE(RSTTYPE))
    p__reg (clk, CEP, RSTP, P_next, P);

    reg_mux #(.REG(CARRYOUTREG), .Width(1), .RSTTYPE(RSTTYPE))
    carryout__reg (clk, CECARRYIN, RSTCARRYIN, carryout_next, CARRYOUT);

    assign M = m_reg;
    assign CARRYOUTF = CARRYOUT;
    assign PCOUT = P;

endmodule    

`timescale 1ns/1ps
module stage_3_tb
#(parameter RSTTYPE="SYNC", PREG=1, 
  CARRYOUTREG=1, OPMODE_REG=1)
  ();
    reg [47:0] DAB;
    reg [35:0] m_reg;
    reg [1:0] opmode10;
    reg [47:0] c_reg;
    reg [47:0] pcin;
    reg [1:0] opmode32;
    reg opmode7, cin, clk ;
    reg CECARRYIN, CEOPMODE, CEP;
    reg RSTCARRYIN, RSTOPMODE, RSTP;
    wire [35:0] M;
    wire CARRYOUT, CARRYOUTF;
    wire [47:0] P, PCOUT;

    stage_3 dut (
    DAB,
    m_reg,
    opmode10,
    c_reg,
    pcin,
    opmode32,
    opmode7, cin, clk,
    CECARRYIN, CEOPMODE, CEP,
    RSTCARRYIN, RSTOPMODE, RSTP,
    M,
    CARRYOUT, CARRYOUTF,
    P, PCOUT);

  initial begin
    clk=0;
    forever 
      #10 clk=~clk;
  end

  initial begin
    {RSTCARRYIN, RSTOPMODE, RSTP}=3'b111;
    {CECARRYIN, CEOPMODE, CEP}=3'b111;
    @(negedge clk);
    {RSTCARRYIN, RSTOPMODE, RSTP}=3'b000;

    repeat(100) begin
      DAB=$random;
      m_reg=$random;
      opmode10=$random;
      c_reg=$random;
      pcin=$random;
      opmode32=$random;
      opmode7=$random;
      cin=$random;
      @(negedge clk);
    end
    $stop;
  end

endmodule  