`timescale 1ns / 1ps
`include "gpu_definitions.v"
////////////////////////////////////////////////////////////////////////////////////
//
// pGB, yet another FPGA fully functional and super fun GB classic clone!
// Copyright (C) 2015-2016  Diego Valverde (diego.valverde.g@gmail.com)
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
////////////////////////////////////////////////////////////////////////////////////


module gpu_ucode_rom
(
	input  wire[7:0]  iAddr,
	output reg [19:0]  oUop
);



always @ ( iAddr )
begin
	case ( iAddr )

	/*
	    state = SCANLINE_VRAM_READ
			cur_tile = 0
1:
			tile_row = 0
2:
			bg_buffer_block_sel = 32
3:

			vmem_addr = bgmoffset + cur_tile
			grvmem
			vmem_addr = bgtoffset + tile_row + vmem_data_shl_4
			grvmem

			bh = vmem_data
			vmem_addr++
			grvmem
			bl = vmem_data
			gwbg

			cur_tile++
			bg_buffer_block_sel--
			if (bg_buffer_block_sel > 0)
					goto 3


			tile_row += 2;
		  ly++
			if (tile_row <= f)
			   cur_tile -= 32
			   goto 2;
     else
			   goto 1


	*/
	0 : oUop = {  `gnop,  `gnull, `gnull, `gnull };
	1 : oUop = {  `gwrl,  `state, `SCANLINE_VRAM_READ };
	2 : oUop = {  `gwrl,  `cur_tile, 10'd0 };
//1
  3 : oUop = {  `gwrl,  `tile_row, 10'd0 };
//2
	4 : oUop = {  `gwrl,  `bg_buffer_block_sel, 10'd32 };
//3
	5: oUop = {  `gadd,  `vmem_addr, `bgmoffset, `cur_tile };
  6: oUop = {  `grvmem, `gnull, `gnull, `gnull };

  7: oUop = {  `gadd,  `r1,        `vmem_data_shl_4, `bg_row_offset };
	8: oUop = {  `gadd,  `vmem_addr, `r1, `bgtoffset };
  9: oUop = {  `grvmem, `gnull, `gnull, `gnull };

	10:  oUop = {  `gwrr,   `bh, `vmem_data, `gnull };
	11: oUop = {  `gaddl,  `vmem_addr, 10'd1  };
	12: oUop = {  `grvmem, `gnull, `gnull, `gnull };
	13: oUop = {  `gwrr,   `bl, `vmem_data, `gnull };
	14: oUop = {  `gwbg,   `gnull,`gnull, `gnull};

	15: oUop = {  `gaddl, `cur_tile, 10'd1  };
  16: oUop = {  `gsubl, `bg_buffer_block_sel, 10'd1 };
  17: oUop = {  `gjnz ,  15'd5 };

	18: oUop = {  `gaddl,  `tile_row, 10'd2  };
	19: oUop = {  `gaddl , `ly, 10'd1 };

	20: oUop = {  `gwrr,  `r1, `tile_row, `gnull };
	21: oUop = {  `gsubl,  `r1, 10'h10 };

	22: oUop = {  `gjz , 15'd3  };
  23: oUop = {  `gsubl,  `cur_tile, 10'd32 };
	24: oUop = {  `ggoto,  15'd4 };

/*
	  0 : oUop = {  `gnop,  `gnull, `gnull, `gnull };
    1 : oUop = {  `gwrl,  `bg_buffer_block_sel, 10'd32 };
    2 : oUop = {  `gwrl,  `r1, 10'h0 };//10'hff };                            //r1 : tile_idx
    3 : oUop = {  `gwrl,  `state, `SCANLINE_VRAM_READ };
    4 : oUop = {  `gadd,  `r2, `bgmoffset, `bg_col_offset };
    5 : oUop = {  `gadd,  `vmem_addr, `r1, `r2 };
		6 : oUop = {  `grvmem, `gnull, `gnull, `gnull };
		7 : oUop = {  `gshl, `r3, `vmem_data, 5'd4 };
    8 : oUop = {  `ginc,  `r1 , `r1, `gnull };
		9 : oUop = {  `gadd,  `r3, `vmem_data_shl_4, `ly_mod_8 };
    10: oUop = {  `gadd,  `vmem_addr, `r3, `bgtoffset };
    11: oUop = {  `grvmem, `gnull, `gnull, `gnull };
    12: oUop = {  `gwrr,  `bh, `vmem_data, `gnull };
    13: oUop = {  `ginc,  `vmem_addr, `vmem_addr ,`gnull  };
    14: oUop = {  `grvmem, `gnull, `gnull, `gnull };
    15: oUop = {  `gwrr,  `bl, `vmem_data, `gnull };
    16: oUop = {  `gwbg,  `gnull,`gnull, `gnull};                                   //Write 8 pixels to the background buffer in parallel
    17: oUop = {  `gdec,  `bg_buffer_block_sel, `bg_buffer_block_sel, `gnull };
    18: oUop = {  `gjnz ,  5'd4, `gnull, `gnull };
		19: oUop = {  `ginc ,  `ly, `ly, `gnull };
		20: oUop = {  `gwrl,  `r1, 10'h0 };
		21: oUop = {  `gwrl,  `bg_buffer_block_sel, 10'd32 };
		22: oUop = {  `gjnz ,  5'd4, `gnull, `gnull };

*/
	endcase
end

endmodule
