module reg_mux #(parameter REG=1, Width=18, RSTTYPE="SYNC") (
	input clk, en, rst,
	input [Width-1:0] d,
	output [Width-1:0] q
	);

      reg [Width-1:0] q_reg;
      wire [Width-1:0] q_next;
      generate
      	if(RSTTYPE=="SYNC") begin
      	  always @(posedge clk)
      	    if(rst)
      	      q_reg <= 0;
      	    else if(en)
      	      q_reg <= q_next;
      	  assign q_next = d;      
      	end
      	else begin
      		always @(posedge clk or posedge rst)
      	    if(rst)
      	      q_reg <= 0;
      	    else if(en)
      	      q_reg <= q_next;
      	  assign q_next = d;
      	end
      	assign q = REG ? q_reg : d;
      endgenerate

endmodule      

`timescale 1ns/1ps     
module reg_mux_tb #(parameter REG=1, Width=18, RSTTYPE="SYNC") ();
  reg clk, en, rst;
  reg [Width-1:0] d;
  wire[Width-1:0] q;

  reg_mux #(REG,Width,RSTTYPE) dut (clk, en, rst, d, q) ;

  initial begin
  	clk=0;
  	forever 
  	  #10 clk=~clk;
  end

  initial begin
  	rst=1;
  	en=0;
  	d=0;
  	@(negedge clk);
  	rst=0;
  	@(negedge clk);
  	en=1;
  	#2;
  	repeat(10) begin
  		d=$random;
  		@(negedge clk);
  	end
  	$stop;
  end
endmodule