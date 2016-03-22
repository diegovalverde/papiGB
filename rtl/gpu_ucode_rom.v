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
/////////////PSEUDO CODE FOR BETTER UNDERSTANDING////////////////////

      state = SCANLINE_VRAM_READ
      cur_tile = 0
1:
      tile_row = 0
2:
      r2 = 32
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
      r2--
      if (r2 > 0)
          goto 3


      tile_row += 2;
      ly++
      if (tile_row <= f)
         cur_tile -= 32
         goto 2;
     else
         goto 1


  */
///////////////////////////////////////////////////////////////////////////

//defines code for getting the first tile and applying color pallete to it
  0: oUop = { `gnop,  `gnull, `gnull, `gnull }; //always has to be a nop because of pc definition
  1: oUop = { `gwrl,  `state, `SCANLINE_VRAM_READ };// writes a literal to register state for cpu to know which state the GPU currently is
  2: oUop = { `gwrr, `cur_tile, `scy_shl_5__plus_scx, `gnull };//which tile am I on, (oScy >>3) <<5 + oScx)
  3: oUop = { `gwrr, `tile_row, `scy_tile_row_offset, `gnull}; // which tile row am I on,
  4: oUop = { `gwrl,  `r2, 10'd32 };//assign a literal to r2, 32 tiles
  5: oUop = { `gadd,  `vmem_addr, `bgmoffset, `cur_tile };// adds current tile with bg offset to get vmem adress to know where to read
  6: oUop = { `grvmem, `gnull, `gnull, `gnull };//reads vmem and stores in vmem_data 
  7: oUop = { `gwrr, `r3, `vmem_addr, `gnull };// store vmem adress in r3
  8: oUop = { `gadd,  `r1,`vmem_data_shl_4, `tile_row };//add tile row with vmem data shifted left by 4
  9: oUop = { `gadd,  `vmem_addr, `r1, `bgtoffset };// get address for tile memory with r1 and BG tile offset
  10: oUop = { `grvmem, `gnull, `gnull, `gnull };//read from tile memory stores in vmem data
  11: oUop = {  `gwrr,   `bh, `vmem_data, `gnull };// save in BH for high byte
  12: oUop = {  `gaddl,  `vmem_addr, 10'd1  };// get adress for BL adding one to current adress, reads next byte
  13: oUop = {  `grvmem, `gnull, `gnull, `gnull }; // save in vmem data
  14: oUop = {  `gwrr,   `bl, `vmem_data, `gnull };//save in BL for low byte
  15: oUop = {  `gwbg,   `gnull,`gnull, `gnull};// BH and BL go through bg pallete and result gets saved in framebuffer
  
//uCode for sprite loop
  16: oUop = {`gand, `r3, `r1, `lcdc}; //and bitwise for r1 and lcd if bit 2 = 1 sprites are on  
/*17: oUop = {`gjz,`skip_the_sprites};
18: oUop = {`gwrl, `r1, 10'd40};
TODO uCode for getting oamoffset

19: oUop = {`gadd, `vmem_addr, `r1, `oam_offset};
20: oUop = {`grvmem, `gnull, `gnull, `gnull};

TODO find if Y coord falls in current fb row
21: oUop = {`gsub, `r0, `vmem_data};
22: oUop = {`gjnz, `get_next_sprite}; TODO define get_next_sprite

23: oUop = {`gaddl, `vmem_addr, `10'd1};
24: oUop = {`grvmem, `gnull,`gnull,`gnull};

TODO get x coord and see if it falls on fb row
25: oUop = {`gsub, `r0, `vmem_data};
26: oUop = {`gjnz, `get_next_sprite}; TODO define get_next_sprite

Fetch sprite tile number

27: oUop = {`gaddl, `vmem_addr, 10'd1};
28: oUop = {`grvem, `gnull,`gnull,`gnull};
29: oUop = {`gwrr, `sprite_tile_indx,`vmem_data_shl_4};
30: oUop = {`gaddl, `vmem_addr, 10'd1};
31: oUop = {`grvem, `gnull,`gnull,`gnull};
32: oUop = {`gwrr, `sprite_info,`vmem_data}; TODO define `sprite_info

GO read tile memory

33: oUop = {`gadd, `r1, `sprite_tile_indx};
34: oUop = {`gadd, `vmem_addr,`r1,`bgtoffset};
35: oUop = {`grvem,`gnull,`gnull,`gnull};
36: oUop = {`gwrr, `bh, `vmem_data}; first tile high byte 
37: oUop = {`gaddl, `vmem_addr, 10'd1};
38: oUop = {`grvem, `gnull,`gnull,`gnull}
39: oUop = {`gwrr, `bl,`vmem_data}

TODO palette logic


*/  
//defines loop for getting the same row for the next tile
/*50ish might vary*/  

  17: oUop = { `gsubl, `r1, 10'd8191}; 
  18: oUop = { `gsub, `r1, `fbuffer_addr, `r8191};
  19: oUop = { `gjz, 15'h2};
  20: oUop = {  `gaddl, `cur_tile, 10'd1  };
  21: oUop = {  `gsubl, `r2, 10'd1 };
  22: oUop = {  `gjnz ,  15'd5 };
  23: oUop = {  `gaddl,  `tile_row, 10'd2  };
  24: oUop = {  `gaddl , `ly, 10'd1 };
  25: oUop = {  `gwrr,  `r1, `tile_row, `gnull };
  26: oUop = {  `gsubl,  `r1, 10'h10 };
  27: oUop = {  `gjz , 15'd3  };

//defines jump to next row of pixels 
  28: oUop = {  `gsubl,  `cur_tile, 10'd32 };
  29: oUop = {  `ggoto,  15'd4 };

  endcase
end

endmodule
