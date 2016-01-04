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
	  0 : oUop = {  `nop,  `null, `null, `null };
    1 : oUop = {  `wrl,  `bg_buffer_block_sel, 10'd31 };
    2 : oUop = {  `wrl,  `r1, 10'hff };                            //r1 : tile_idx
    3 : oUop = {  `wrl,  `state, `SCANLINE_VRAM_READ };
    4 : oUop = {  `add,  `r2, `bgmoffset, `bg_col_offset };
    5 : oUop = {  `add,  `vmem_addr, `r1, `r2 };
		6 : oUop = { `rvmem, `null, `null, `null };
		7 : oUop = { `shl, `r3, `vmem_data, 5'd4 };
    8 : oUop = {  `inc,  `r1 , `r1, `null };
		9 : oUop = {  `add,  `r3, `vmem_data_shl_4, `ly_mod_8 };
    10 : oUop = {  `add,  `vmem_addr, `r3, `bgtoffset }; 
    11 : oUop = { `rvmem, `null, `null, `null };
    12 : oUop = {  `wrr,  `bh, `vmem_data, `null };
    13 : oUop = {  `inc,  `vmem_addr, `vmem_addr ,`null  };
    14 : oUop = { `rvmem, `null, `null, `null };
    15: oUop = {  `wrr,  `bl, `vmem_data, `null };
    16: oUop = {  `wbg,  `null,`null, `null};                                   //Write 8 pixels to the background buffer in parallel
    17: oUop = {  `dec,  `bg_buffer_block_sel, `bg_buffer_block_sel, `null };
    18: oUop = {  `jnz ,  5'd4, `null, `null };
		19: oUop = {  `inc ,  `ly, `ly, `null };
		20: oUop = {  `wrl,  `bg_buffer_block_sel, 10'd31 };
		21: oUop = {  `jnz ,  5'd4, `null, `null };
	endcase
end

endmodule
