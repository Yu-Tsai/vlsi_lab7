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
  reg [7:0] pixel[4:0];
  reg [7:0] result[4:0];
  reg [7:0] q;
  reg [7:0]error_dif;
  integer i;

  always@(posedge clk or posedge rst) begin
	if(rst) begin
	  q <= 8'b0;
	  for(i = 3'd0; i <= 3'd7; i = i + 1) begin
		pixel[i] <= 0;
		result[i] <= 0;
	  end
	end
	else if(en) begin
	  pixel[addr] <= d;
	  //q <= pixel[addr];
	end
	//else  q <= pixel[addr];
  end
  
  always@(*) begin
    if(en) begin
      if((pixel[`Cen]) < 8'd128) begin
        error_dif=pixel[`Cen]-8'd0;
	result[`Cen] = 8'd0;
        result[`Right] = (8'd255-pixel[`Right]>=(error_dif>>2) + (error_dif>>3) + (error_dif>>4))?(pixel[`Right] + (error_dif>>2) + (error_dif>>3) + (error_dif>>4)):8'd255;
        result[`LowL] = (8'd255-pixel[`LowL]>=(error_dif>>3) + (error_dif>>4))?(pixel[`LowL] + (error_dif>>3) + (error_dif>>4)):8'd255;
        result[`LowC] = (8'd255-pixel[`LowC]>=(error_dif>>2) + (error_dif>>4))?(pixel[`LowC] + (error_dif>>2) + (error_dif>>4)):8'd255;
        result[`LowR] = (8'd255-pixel[`LowR]>=(error_dif>>4))?(pixel[`LowR] + (error_dif>>4)):8'd255;
      end
      else begin
        error_dif=8'd255-pixel[`Cen];
	result[`Cen] = 8'd255;
        result[`Right] = (pixel[`Right]>=(error_dif>>2) + (error_dif>>3) + (error_dif>>4))?(pixel[`Right] - (error_dif>>2) - (error_dif>>3) - (error_dif>>4)):8'd0;
        result[`LowL] = (pixel[`LowL]>=(error_dif>>3) + (error_dif>>4))?(pixel[`LowL] - (error_dif>>3) - (error_dif>>4)):8'd0;
        result[`LowC] = (pixel[`LowC]>=(error_dif>>2) + (error_dif>>4))?(pixel[`LowC] - (error_dif>>2) - (error_dif>>4)):8'd0;
        result[`LowR] = (pixel[`LowR]>=(error_dif>>4))?(pixel[`LowR] - (error_dif>>4)):8'd0;
      end
	  q = result[addr];
   end
  end

 /*always@(*) begin
   if(en) begin
     case(addr)
       `Cen: begin
       
       end
       `Right: begin
       
       end
       `LowL: begin
       
       end
       `LowC: begin
       
       end
       `LowR: begin
       
       end
     endcase
   end
 end*/
  
endmodule
// ------------------ the end of code ------------------ //
