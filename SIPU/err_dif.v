//*************************************************                     
//** Author: LPHP Lab                               
//** Project: Simple image processor
//**    			- error diffusion
//*************************************************


module err_dif(clk,
		       rst,
			   en,
		 	   addr,
			   d,
			   q,);
// ---------------------- input  ---------------------- //
 input clk; 
 input rst;
 input en;
 input [2:0] addr;
 input [7:0] d;
// ---------------------- output ---------------------- //
 output [7:0] q;
// --------------- below is your design --------------- //

  
endmodule
// ------------------ the end of code ------------------ //
