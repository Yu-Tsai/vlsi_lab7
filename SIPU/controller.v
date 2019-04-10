//*************************************************                       
//** Author: LPHP Lab                               
//** Project: Simple image processor
//**    			- controller
//*************************************************
`define S_reset 		4'd0
`define S_in_mem 		4'd1
`define S_grayscale 	4'd2
`define S_write_back 	4'd3
`define S_branch1 		4'd4
`define S_FS_read 		4'd5
`define S_err_dif		4'd6
`define S_FS_writeback 	4'd7
`define S_branch2 		4'd8
`define S_done 		    4'd9


module controller(clk,
                  rst,
                  en_in_mem,
                  in_mem_addr,
                  en_gray,
				  mux_sel,
                  en_out_mem,
				  out_mem_read,
				  out_mem_write,
                  out_mem_addr,
				  en_err_dif,
				  err_dif_addr,
				  done
                  );

				  
// ---------------------- input  ---------------------- //
  input 		clk;
  input 		rst;
  
// ---------------------- output ---------------------- //
  output  		en_in_mem;
  output [31:0]	in_mem_addr;
  output 		en_gray;
  output  		mux_sel;
  output 		en_out_mem;
  output        out_mem_read;
  output        out_mem_write;
  output [31:0]	out_mem_addr;
  output  		en_err_dif;
  output [2:0]	err_dif_addr;
  output 		done; 
// --------------- below is your design --------------- //
  reg [3:0]cstate;
  reg [3:0]nstate;

  always @(posedge clk or posedge rst) begin
    if (rst)
      cstate <= S_reset;
    else
      cstate <= nstate;
  end

  always @(*)begin
    case(cstate)
      S_reset: begin

      end
      S_in_mem: begin

      end
      S_grayscale: begin

      end
      S_write_back: begin

      end
      S_branch1: begin

      end
      S_FS_read: begin

      end
      S_err_dif: begin

      end
      S_FS_writeback: begin

      end
      S_branch2: begin

      end
      S_done: begin

      end
    endcase
  end
  
  
  
endmodule
// ------------------ the end of code ------------------ //
  
  
  
  
