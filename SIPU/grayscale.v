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
  reg [24:0]pixel;
  reg [15:0]q_tmp;
  
  always@(posedge clk or posedge rst) begin
    if(rst) q <= 8'b0;
	else if(!en) begin
	  pixel <= d;
	  q <= q_tmp[15:8];
	end
  end
  
  always@(*) begin
	if(en) begin
	  q_tmp = {(color[23:16]>>2), (color[23:16]<<6)} + {(color[23:16]>>4), (color[23:16]<<4)} + {(color[15:8]>>1), (color[15:8]<<7)} + {(color[15:8]>>4), (color[15:8]<<4)} + {(color[7:0]>>3), (color[7:0]<<5)};
	end
  end
  
endmodule
// ------------------ the end of code ------------------ //