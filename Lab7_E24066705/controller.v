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
/*`define S_FS_read_C		5'd5
`define S_FS_read_R 	5'd6
`define S_FS_read_LL	5'd7
`define S_FS_read_LC	5'd8
`define S_FS_read_LR	5'd9
`define S_err_dif		5'd10
`define S_FS_writeback_C 	5'd11
`define S_FS_writeback_R 	5'd12
`define S_FS_writeback_LL 	5'd13
`define S_FS_writeback_LC 	5'd14
`define S_FS_writeback_LR 	5'd15
`define S_branch2 		5'd16
`define S_done 		    5'd17*/
`define S_FS_read 		4'd5
`define S_err_dif		4'd6
`define S_FS_writeback 	4'd7
`define S_branch2 		4'd8
`define S_done 		    4'd9

`include "define.v"


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
  reg  		en_in_mem;
  reg [31:0]	in_mem_addr;
  reg 		en_gray;
  reg  		mux_sel;
  reg 		en_out_mem;
  reg        out_mem_read;
  reg        out_mem_write;
  reg [31:0]	out_mem_addr;
  reg  		en_err_dif;
  reg [2:0]	err_dif_addr;
  reg 		done;
  
  reg [11:0]now_dif_pix;

  always @(posedge clk or posedge rst) begin
    if (rst)
      cstate <= `S_reset;
    else
      cstate <= nstate;
  end

  always @(*)begin
    case(cstate)
      `S_reset: begin
	    nstate = `S_in_mem;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
		in_mem_addr = 0;
		mux_sel = 0;
		out_mem_addr = 0;
		err_dif_addr = 3'd0;
		now_dif_pix = 12'd1;
      end
      `S_in_mem: begin
        nstate = `S_grayscale;
        en_in_mem = 1;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
      end
      `S_grayscale: begin
	    nstate = `S_write_back;
        en_in_mem = 0;
		en_gray = 1;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
      end
      `S_write_back: begin
	      nstate = `S_branch1;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 1;
		out_mem_read = 0;
		out_mem_write = 1;
		done = 0;
      end
      `S_branch1: begin
	      if(in_mem_addr == (`size-1)) begin
		nstate = `S_FS_read;
		in_mem_addr = in_mem_addr;
		out_mem_addr = (`size - `width);
		now_dif_pix = 12'd1;
		err_dif_addr = `Cen;
		mux_sel = 1;
	      end	      
	      else begin
		      nstate = `S_in_mem;
		      in_mem_addr = in_mem_addr + 1;
		      out_mem_addr = out_mem_addr + 1;
	      end
	      //nstate = (in_mem_addr == (`size-1))?`S_FS_read_C:`S_in_mem;
		//nstate = (in_mem_addr == (`size-1))?`S_done:`S_in_mem;
		//if(in_mem_addr == 32'd786431) nstate = `S_done;
		//else nstate = `S_in_mem;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
		//in_mem_addr = in_mem_addr + 1;
		//out_mem_addr = (nstate == `S_FS_read_C)?(`size-`width):(out_mem_addr+1);
      end
	`S_FS_read: begin
		nstate = `S_err_dif;
		en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 1;
		out_mem_read = 1;
		out_mem_write = 0;
		done = 0;
	end
	`S_err_dif: begin
		nstate = `S_FS_writeback;
		en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 1;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
	end
	`S_FS_writeback: begin
		nstate = `S_branch2;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 1;
		out_mem_read = 0;
		out_mem_write = 1;
		done = 0;
	end
	`S_branch2: begin
		case(err_dif_addr) 
			`Cen:begin
				if(now_dif_pix == `width) begin
					if(out_mem_addr > `width) begin
						err_dif_addr = `LowC;
						out_mem_addr = out_mem_addr - `width;
		nstate = `S_FS_read;
					end
					else begin
						nstate = `S_done;
					end
				end
				else begin
					err_dif_addr = `Right;
					out_mem_addr = out_mem_addr + 1;
		nstate = `S_FS_read;
				end
			end
			`Right: begin
		nstate = `S_FS_read;
				if(out_mem_addr < `width) begin
					err_dif_addr = `Cen;
					out_mem_addr = out_mem_addr;
					now_dif_pix = now_dif_pix + 12'd1;
				end
				else begin
					err_dif_addr = `LowR;
					out_mem_addr = out_mem_addr - `width;
				end
			end
			`LowR: begin
		nstate = `S_FS_read;
				err_dif_addr = `LowC;
				out_mem_addr = out_mem_addr - 1;
			end
			`LowC: begin
		nstate = `S_FS_read;
				if(now_dif_pix == 12'd1) begin
					err_dif_addr = `Cen;
					out_mem_addr = out_mem_addr + `width + 1;
					now_dif_pix = now_dif_pix + 12'd1;
				end
				else begin
					err_dif_addr = `LowL;
					out_mem_addr = out_mem_addr - 1;
				end
			end
			`LowL: begin
		nstate = `S_FS_read;
				err_dif_addr = `Cen;				
				if(now_dif_pix == `width) begin
					out_mem_addr = out_mem_addr + 2 - `width;
					now_dif_pix = 12'd1;
				end
				else begin
					out_mem_addr = out_mem_addr + `width + 2;
					now_dif_pix = now_dif_pix + 12'd1;
				end
			end
		endcase
		en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
	end
      `S_done: begin
	      nstate = `S_done;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 1;
      end
      default: begin
	    nstate = `S_in_mem;
        en_in_mem = 0;
		en_gray = 0;
		en_err_dif = 0;
		en_out_mem = 0;
		out_mem_read = 0;
		out_mem_write = 0;
		done = 0;
		in_mem_addr = 0;
		mux_sel = 0;
		out_mem_addr = 0;
		err_dif_addr = 3'd0;
		now_dif_pix = 12'd1;
	end
    endcase
  end
  
  
  
endmodule
// ------------------ the end of code ------------------ //
  
  
  
  
