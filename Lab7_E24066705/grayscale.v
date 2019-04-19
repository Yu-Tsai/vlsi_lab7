//*************************************************                       
//** Author: LPHP Lab                               
//** Project: Simple image processor
//**    			- Grayscale
//*************************************************


module grayscale(clk,
                 rst,
                 en,
                 d,
                 q);

// ---------------------- input  ---------------------- //
  input clk;
  input rst;
  input en;
  input [23:0]d;
  
// ---------------------- output ---------------------- //  
  output reg[7:0]q;
// --------------- below is your design --------------- //
  reg [23:0]pixel;
  reg [15:0]q_tmp;
  
  always@(posedge clk or posedge rst) begin
    if(rst)begin 
      q <= 8'b0;
      pixel <= 24'd0;
      q_tmp <= 16'd0;
    end
	else if(en) begin
	  pixel <= d;
	end
  end
  
  always@(*) begin
	if(en) begin
	  q_tmp = {(pixel[23:16]>>2), (pixel[23:16]<<6)} + {(pixel[23:16]>>4), (pixel[23:16]<<4)} + {(pixel[15:8]>>1), (pixel[15:8]<<7)} + {(pixel[15:8]>>4), (pixel[15:8]<<4)} + {(pixel[7:0]>>3), (pixel[7:0]<<5)};
	  q = q_tmp[15:8];
	end
  end
  
endmodule
// ------------------ the end of code ------------------ //
