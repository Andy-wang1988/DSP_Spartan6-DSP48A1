module mux_carryin #(parameter CARRYINSEL="OPMODE5") (
	input opmode5,
	input carryin,
	output mux_carryin_out);

       generate
       	if(CARRYINSEL=="OPMODE5")
       	  assign mux_carryin_out = opmode5;
       	else if (CARRYINSEL=="CARRYIN")
       	  assign  mux_carryin_out = carryin;
       	else 
       	  assign mux_carryin_out = 0;    
       	
       endgenerate
endmodule
