module stage_2 #(parameter RSTTYPE="SYNC", MREG=1, CARRYINSEL="OPMODE5",
	CARRYINREG=1, OPMODE_REG=1)

  ( input [17:0] d_reg, b1_reg, a1_reg,
    input [47:0] c_reg,
  	input [47:0] pin,
  	input opmode5, carryin,
  	input CEM, CECARRYIN, CEOPMODE,
  	input RSTM, RSTCARRYIN, RSTOPMODE,
    input clk,
  	output [47:0] DAB,
  	output [17:0] bcout,
  	output [35:0] m_reg,
  	output carryin_reg,
  	output [47:0] c_reg_out,
  	output [47:0] pin_out);

    wire [35:0] multiplier_out;
    wire opmode5_reg;
    wire mux_carryin_out;
    
    multiplier mul_dut (b1_reg, a1_reg, multiplier_out);

    reg_mux #(.REG(MREG), .Width(36), .RSTTYPE(RSTTYPE))
    m__reg (clk, CEM, RSTM, multiplier_out, m_reg);
    
    reg_mux #(.REG(OPMODE_REG), .Width(1), .RSTTYPE(RSTTYPE))
    op5__reg (clk, CEOPMODE, RSTOPMODE, opmode5, opmode5_reg);

    mux_carryin #(.CARRYINSEL(CARRYINSEL)) mux_carryin
    (opmode5_reg, carryin, mux_carryin_out);
 
    reg_mux #(.REG(CARRYINREG), .Width(1), .RSTTYPE(RSTTYPE))
    carryin__reg (clk, CECARRYIN, RSTCARRYIN, mux_carryin_out, carryin_reg);

    assign DAB = {d_reg[11:0], a1_reg[17:0], b1_reg[17:0]};
    assign bcout = b1_reg;
    assign c_reg_out = c_reg;
    assign pin_out = pin;
endmodule

`timescale 1ns/1ps
module stage_2_tb #(parameter RSTTYPE="SYNC", MREG=1, CARRYINSEL="OPMODE5",
  CARRYINREG=1, OPMODE_REG=1) ();

    reg [17:0] d_reg, b1_reg, a1_reg, c_reg;
    reg [47:0] pin;
    reg opmode5, carryin;
    reg CEM, CECARRYIN, CEOPMODE;
    reg RSTM, RSTCARRYIN, RSTOPMODE;
    reg clk;
    wire [47:0] DAB;
    wire [17:0] bcout;
    wire [35:0] m_reg;
    wire carryin_reg;
    wire [17:0] c_reg_out;
    wire [47:0] pin_out;
  
  stage_2 #(RSTTYPE, MREG, CARRYINSEL,
  CARRYINREG, OPMODE_REG) dut

  ( d_reg, b1_reg, a1_reg, c_reg,
    pin,
    opmode5, carryin,
    CEM, CECARRYIN, CEOPMODE,
    RSTM, RSTCARRYIN, RSTOPMODE,
    clk,
    DAB,
    bcout,
    m_reg,
    carryin_reg,
    c_reg_out,
    pin_out);

  initial begin
    clk=0;
    forever 
      #10 clk=~clk;
  end

  initial begin
    {RSTM, RSTCARRYIN, RSTOPMODE}=3'b111;
    {CEM, CECARRYIN, CEOPMODE}=3'b111;
    @(negedge clk);
    {RSTM, RSTCARRYIN, RSTOPMODE}=3'b000;

    repeat(100) begin
      d_reg=$random;
      b1_reg=$random;
      a1_reg=$random;
      c_reg=$random;
      pin=$random;
      opmode5=$random;
      carryin=$random;
      @(negedge clk);
    end
    $stop;
  end
endmodule

     


