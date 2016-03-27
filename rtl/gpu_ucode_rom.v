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
  output reg [`GPU_UOP_SZ-1:0]  oUop
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
      gwfbuffer

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

//Frame buffer render main loop. Ie. current_tile = 0
  2: oUop = { `gwrr, `cur_tile, `scy_shl_5__plus_scx, `gnull };//which tile am I on, (oScy >>3) <<5 + oScx)

//Next tile loop
  3: oUop = { `gwrr, `tile_row, `scy_tile_row_offset, `gnull}; // which tile row am I on,

//
  4: oUop = { `gwrl,  `r2, 12'd32 };//assign a literal to r2, 32 tiles

//Current tile render loop
  5: oUop = { `gadd,  `vmem_addr, `bgmoffset, `cur_tile };// adds current tile with bg offset to get vmem adress to know where to read
  6: oUop = { `grvmem, `gnull, `gnull, `gnull };//reads vmem and stores in vmem_data
  7: oUop = { `gwrr, `r3, `vmem_addr, `gnull };// store vmem adress in r3
  8: oUop = { `gadd,  `r1,`vmem_data_shl_4, `tile_row };//add tile row with vmem data shifted left by 4
  9: oUop = { `gadd,  `vmem_addr, `r1, `bgtoffset };// get address for tile memory with r1 and BG tile offset
  10: oUop = { `grvmem, `gnull, `gnull, `gnull };//read from tile memory stores in vmem data
  11: oUop = {  `gwrr,   `bh, `vmem_data, `gnull };// save in BH for high byte
  12: oUop = {  `gaddl,  `vmem_addr, 12'd1  };// get adress for BL adding one to current adress, reads next byte
  13: oUop = {  `grvmem, `gnull, `gnull, `gnull }; // save in vmem data
  14: oUop = {  `gwrr,   `bl, `vmem_data, `gnull };//save in BL for low byte
  15: oUop = {  `gwfbuffer,   `gnull,`gnull, `gnull};// BH and BL go through bg pallete and result gets saved in framebuffer

/////////////////////////uCode for sprite loop/////////////////////////////////////

  16: oUop = {`gwrl, `r6, 12'b100};                     // set bit 3 as 1 for next oUopp
  17: oUop = {`gand, `r3, `r6, `lcdc};                  //and bitwise for r6 and lcd if bit 2 = 1 sprites are on
  18: oUop = {`gjz,`skip_the_sprites};
  19:
  begin
   oUop = {`gwrl, `r6, 12'd0};                       //we have a maximum of 40 sprites x= 39*4 because if 4 byte descriptors

  end


  20: oUop = {`gadd, `vmem_addr, `r6, `oam_offset};     //get address of sprite
  21: oUop = {`grvmem, `gnull, `gnull, `gnull};               //store vmem data loads first byte of sprite  descriptor
  22: oUop = {`gsubl,  `vmem_data, 12'd0};               //Test to see if the sprite_y_coord is zero
  23: oUop = {`gjz, `get_next_sprite};                     //if y coord is zero jump to next sprite
  24: oUop = {`gwrl,`r4 , 12'd16};                            //Since the sprite_y_coord was no zero, we need to substract 16 in order to obtain the real sprite_y_coord
  25: oUop = {`gsub,`sprite_y_coord ,`vmem_data,`r4};         //get y coord of the sprite
  26: oUop = {`gaddl, `vmem_addr, 12'd1};                     //get address for next byte of sprite descriptor
  27: oUop = {`grvmem, `gnull,`gnull,`gnull};
  28: oUop = {`gsubl,  `vmem_data, 12'd0};               //Test to see if the sprite_x_coord is zero
  29: oUop = {`gjz,    `get_next_sprite};                     //if x coord is zero jump to next sprite
  30: oUop = {`gwrl,`r4 , 12'd8};
  31: oUop = {`gsub, `sprite_x_coord ,`vmem_data ,`r4 };    //get x coord
  32: oUop = {`gnop,  `gnull, `gnull, `gnull};  //{`gsub, `r5, `tile_column, `vmem_data};
  33: oUop = {`gsprtt,  `r4, `sprite_x_coord, `sprite_y_coord};     //Test if the sprite is in the current tile
  34: oUop = {`gjz,    `get_next_sprite};
//Fetch sprite tile number
  35: oUop = {`gaddl, `vmem_addr, 12'd1};//get next byte sprite index
  36: oUop = {`grvmem, `gnull,`gnull,`gnull};
  37: oUop = {`gadd, `r4 ,`vmem_data_shl_4,`sprite_current_row_offset}; //define sprite tile index shifted by 4 to the left would get added with bgomffset for tile memory read
  38: oUop = {`gaddl, `vmem_addr, 12'd1};//get next byte sprite options
  39: oUop = {`grvmem, `gnull,`gnull,`gnull};
  40: oUop = {`gwrr, `sprite_info,`vmem_data}; //define `sprite_info bits are important for effects flips and flashes
//TODO DEFINE LOGIC FOR SpriteOPTIONS (LA FLECHA DE TETRIS NO TIENE OPTIONS ENTONCES QUIERO PROBAR DIBUJARLA SIN HACER LA PARTE
//DE OPTIONS)
//GO read tile memory

  41: oUop = {`gadd, `vmem_addr,`bgtoffset,`r4}; //by adding this two you get the address of the tile memory
  42: oUop = {`grvmem,`gnull,`gnull,`gnull};
  43: oUop = {`gwrr, `sh, `vmem_data, `gnull};                           //first tile high byte for current sprite
  44: oUop = {`gaddl, `vmem_addr, 12'd1};
  45: oUop = {`grvmem, `gnull,`gnull,`gnull};
  46: oUop = {`gwrr, `sl,`vmem_data, `gnull};                            //second tile low byte for current sprite
  47: oUop = {`gnop,  `gnull, `gnull, `gnull};//{`glsprtt, `gnull, `tile_row,`sprite_y_coord}; //test if sprite is in current row
  48: oUop = {`gjz,`get_next_sprite};
  //TODO LOGIC FOR BACKGROUND AND FOREGROUND display for sprites
  //sprite palette logic
  49: oUop = {`gwfbuffer, `gnull,`gnull, `gnull};// SH and SL go through sprite palletes and result gets saved in framebuffer

  50: oUop = {`gaddl,`r6, 12'd4};
  51: oUop = {`gsubl,`r6, 12'd156};//39*4 = 156
  52:  begin
  //$display("DRAW THE ARROW PLZ \n");
  //oUop = {`gjnz, 15'd20}; // end of sprites go to next tile
    oUop = {`gaddl,  `sprite_current_row_offset, 12'd2};           //Each sprite row is 2Bytes (8 pixles). Increment the sprite row offset by 2 for next iteration
//  $finish();
end
////////////////End of ucode for sprite loop////////////////////////////
//skip_sprites
//defines loop for getting the same row for the next tile
  53: oUop = {`ginfbaddr, `gnull, `gnull, `gnull};        //Increment the framebuffer write pointer
  54: oUop = {`gwrl, `sl, 12'd0};
  55: oUop = {`gwrl, `sh, 12'd0};
  56: //begin
  // $display("No more GPU code, stop here I say!\n");
   oUop = { `gsubl, `r1, 12'd8191}; //limit 0x1FFF or d 8191
   //$finish();
  //end
  57: oUop = { `gsub, `r1, `fbuffer_addr, `r8191};          //Did we painted all of the 32x32 tiles?
  58: oUop = { `gjz, 18'h2};                                //Yes, ok restart the loop for next frame
  59: oUop = { `gwrl,`sprite_current_row_offset, 12'd0};    //Reset the sprite roww offset to zero since we will start with a fresh tile now
  60: oUop = {  `gaddl, `cur_tile, 12'd1  };                //Time to take care of the next tile
  61: oUop = {  `gsubl, `r2, 12'd1 };                       //Is this tile the last of the 2 tiles in a tile row?
  62: oUop = {  `gjnz ,  18'd5 };                           //No, Keep rendering the  remaining rows of the current tile
  63: oUop = {  `gaddl,  `tile_row, 12'd2  };
  64: oUop = {  `gaddl , `ly, 12'd1 };
  65: oUop = {  `gwrr,  `r1, `tile_row, `gnull };
  66: oUop = {  `gsubl,  `r1, 12'h10 };
  67: oUop = {  `gjz , 18'd3  };                           //Move to next tile

   //defines jump to next row of pixels
  68: oUop = {  `gsubl,  `cur_tile, 12'd32 };  //Reset the tile index to the first tile index in the row of tiles, this is because we always start a a row of tiles from left to right (like a typewritting machine)
  69: oUop = {  `ggoto,  18'd4 };              //Move down one row

  endcase
end

endmodule
