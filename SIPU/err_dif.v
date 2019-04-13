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
  reg [7:0]error_dif;
  
  always@(posedge clk or posedge rst) begin
	if(rst) begin
	  q <= 8'b0;
	end
	else if(!en) begin
	  pixel[addr] <= d;
	  q <= pixel[addr];
	end
  end
  
  always@(*) begin
    if(en) begin
      if((pixel[`Cen]) < 8'd128) begin
        pixel[`Cen]=8'd0;
        error_dif=pixel[`Cen]-8'd0;
        pixel[`Right] = (8'd255-pixel[`Right]>=(error_dif>>1) - (error_dif>>4))?(pixel[`Right] + (error_dif>>1) - (error_dif>>4)):8'd255;
        pixel[`LowL] = (8'd255-pixel[`LowL]>=(error_dif>>3) + (error_dif>>4))?(pixel[`LowL] + (error_dif>>3) + (error_dif>>4)):8'd255;
        pixel[`LowC] = (8'd255-pixel[`LowC]>=(error_dif>>2) + (error_dif>>4))?(pixel[`LowC] + (error_dif>>2) + (error_dif>>4)):8'd255;
        pixel[`LowR] = (8'd255-pixel[`LowR]>=(error_dif>>4))?(pixel[`LowR] + (error_dif>>4)):8'd255;
      end
      else begin
        pixel[`Cen]=8'd255;
        error_dif=8'd255-pixel[`Cen];
        pixel[`Right] = (pixel[`Right]>=(error_dif>>4)-(error_dif>>1))?(pixel[`Right] - (error_dif>>1) + (error_dif>>4)):8'd0;
        pixel[`LowL] = (pixel[`LowL]>=(error_dif>>3) + (error_dif>>4))?(pixel[`LowL] - (error_dif>>3) - (error_dif>>4)):8'd0;
        pixel[`LowC] = (pixel[`LowC]>=(error_dif>>2) + (error_dif>>4))?(pixel[`LowC] - (error_dif>>2) - (error_dif>>4)):8'd0;
        pixel[`LowR] = (pixel[`LowR]>=(error_dif>>4))?(pixel[`LowR] - (error_dif>>4)):8'd0;
      end
   end
  end
  
endmodule
// ------------------ the end of code ------------------ //
