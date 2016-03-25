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

/////////////////////////uCode for sprite loop/////////////////////////////////////

  16: oUop = {`gwrl, `r6, 10'b100};                     // set bit 3 as 1 for next oUopp
  17: oUop = {`gand, `r3, `r6, `lcdc};                  //and bitwise for r6 and lcd if bit 2 = 1 sprites are on
  18: oUop = {`gjz,`skip_the_sprites};
  19:
  begin
   oUop = {`gwrl, `r6, 10'd0};                       //we have a maximum of 40 sprites x= 39*4 because if 4 byte descriptors
   $display("Sprites are enabled, punk!");
  end


  20:
  begin
  oUop = {`gadd, `vmem_addr, `r6, `oam_offset};     //get address of sprite

  end

  21: oUop = {`grvmem, `gnull, `gnull, `gnull};               //store vmem data loads first byte of sprite  descriptor
  22: oUop = {`gsubl,  `vmem_data, 10'd0     };               //Test to see if the sprite_y_coord is zero
  23: oUop = {`gjz,    `get_next_sprite};                     //if y coord is zero jump to next sprite

  24: oUop = {`gwrl,`r4 , 10'd16};                            //Since the sprite_y_coord was no zero, we need to substract 16 in order to obtain the real sprite_y_coord
  25: oUop = {`gsub,`sprite_y_coord ,`vmem_data,`r4};         //get y coord of the sprite
  26: oUop = {`gjz, `get_next_sprite};                        //if y coord is zero jump to next sprite

  27: oUop = {`gaddl, `vmem_addr, 10'd1};                     //get address for next byte of sprite descriptor
  28: oUop = {`grvmem, `gnull,`gnull,`gnull};
  29: oUop = {`gsubl,  `vmem_data, 10'd0     };               //Test to see if the sprite_x_coord is zero
  30: oUop = {`gjz,    `get_next_sprite};                     //if x coord is zero jump to next sprite
  31: oUop = {`gwrl,`r4 , 10'd8};
//vmem_data -8 = Xcoord of sprite, if Xcoord= 0 sprite doesnt display
  32: oUop = {`gsub, `sprite_x_coord ,`vmem_data ,`r4 };    //get x coord
  33: oUop = {`gnop,  `gnull, `gnull, `gnull};  //{`gsub, `r5, `tile_column, `vmem_data};//define tile_column
  34:
  begin
   oUop = {`gsprtt,  `r4, `sprite_x_coord, `sprite_y_coord};     //Test if the sprite is in the current tile
   $display("No more GPU code, stop here I say!\n");
   $finish();
  end
// code for checking match between sprite coords and
/*if i want max number of pixels in X

Xcoord =  cur_tile*8 + 7; this would give me the xcoord for the upper right corner of the tile (no se si existe pixel 0 o empieza desde pixel 1 la cuenta no se si es +7 u +8)

Ycoord =


/*
//Fetch sprite tile number

  3x: oUop = {`gaddl, `vmem_addr, 10'd1};//get next byte
  3x: oUop = {`grvem, `gnull,`gnull,`gnull};
  3x: oUop = {`gwrr, `sprite_tile_indx,`vmem_data_shl_4};//define sprite tile indx
  3x: oUop = {`gaddl, `vmem_addr, 10'd1};//get next byte
  3x: oUop = {`grvem, `gnull,`gnull,`gnull};
  3x: oUop = {`gwrr, `sprite_info,`vmem_data}; //define `sprite_info bits are important for effects flips and flashes

//GO read tile memory
  3x: oUop = {`gadd, `r6, `sprite_tile_indx};
  3x: oUop = {`gadd, `vmem_addr,`r6,`bgtoffset};
  4x: oUop = {`grvem,`gnull,`gnull,`gnull};
  4x: oUop = {`gwrr, `bh, `vmem_data}; //first tile high byte
  4x: oUop = {`gaddl, `vmem_addr, 10'd1};
  4x: oUop = {`grvem, `gnull,`gnull,`gnull};
  4x: oUop = {`gwrr, `bl,`vmem_data};//second tile low byte

//TODO palette logic
  4x: oUop = {  `gwbg, `gnull,`gnull, `gnull};// BH and BL go through sprite palletes and result gets saved in framebuffer
//get_next_sprite loop
  4x: oUop = {`gsubl,`r6,`10'd1};
  4x: oUop = {`gjz,`15'd20} // end of sprites go to next tile
*/
////////////////End of ucode for sprite loop////////////////////////////

//defines loop for getting the same row for the next tile
  35: oUop = { `gsubl, `r1, 10'd8191}; //limit 0x1FFF or d 8191
  36: oUop = { `gsub, `r1, `fbuffer_addr, `r8191};
  37: oUop = { `gjz, 15'h2};
  38: oUop = {  `gaddl, `cur_tile, 10'd1  };
  39: oUop = {  `gsubl, `r2, 10'd1 };
  40: oUop = {  `gjnz ,  15'd5 };
  41: oUop = {  `gaddl,  `tile_row, 10'd2  };
  42: oUop = {  `gaddl , `ly, 10'd1 };
  43: oUop = {  `gwrr,  `r1, `tile_row, `gnull };
  44: oUop = {  `gsubl,  `r1, 10'h10 };
  45: oUop = {  `gjz , 15'd3  };

//defines jump to next row of pixels
  46: oUop = {  `gsubl,  `cur_tile, 10'd32 };
  47: oUop = {  `ggoto,  15'd4 };

  endcase
end

endmodule
