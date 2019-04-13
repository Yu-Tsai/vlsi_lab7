//*************************************************                     
//** Author: LPHP Lab                               
//** Project: Simple image processor
//**    			- error diffusion
//*************************************************

`include "define.v"

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
  reg [7:0] pixel[2:0];
  reg [7:0] q;
  
  always@(posedge clk or posedge rst) begin
    if(rst) q <= 8'b0;
	else if(!en) begin
	  pixel[addr] <= d;
	  q <= pixel[addr];
	end
  end
  
  always@(*) begin
    if(en) begin
	  if(C_pixel<8'd128)begin
        Out_C_pixel=8'd0;
        error_dif=C_pixel-8'd0;
        Out_R_pixel = (8'd255-R_pixel>=(error_dif>>1) - (error_dif>>4))?(R_pixel + (error_dif>>1) - (error_dif>>4)):8'd255;
        Out_LL_pixel = (8'd255-LL_pixel>=(error_dif>>3) + (error_dif>>4))?(LL_pixel + (error_dif>>3) + (error_dif>>4)):8'd255;
        Out_LC_pixel = (8'd255-LC_pixel>=(error_dif>>2) + (error_dif>>4))?(LC_pixel + (error_dif>>2) + (error_dif>>4)):8'd255;
        Out_LR_pixel = (8'd255-LR_pixel>=(error_dif>>4))?(LR_pixel + (error_dif>>4)):8'd255;
      end
      else begin
        Out_C_pixel=8'd255;
        error_dif=8'd255-C_pixel;
        Out_R_pixel = (R_pixel>=(error_dif>>4)-(error_dif>>1))?(R_pixel - (error_dif>>1) + (error_dif>>4)):8'd0;
        Out_LL_pixel = (LL_pixel>=(error_dif>>3) + (error_dif>>4))?(LL_pixel - (error_dif>>3) - (error_dif>>4)):8'd0;
        Out_LC_pixel = (LC_pixel>=(error_dif>>2) + (error_dif>>4))?(LC_pixel - (error_dif>>2) - (error_dif>>4)):8'd0;
        Out_LR_pixel = (LR_pixel>=(error_dif>>4))?(LR_pixel - (error_dif>>4)):8'd0;
      end
	end
  end
  
endmodule
// ------------------ the end of code ------------------ //
