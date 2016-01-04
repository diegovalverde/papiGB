`timescale 1ns / 1ps
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



`ifndef GPU_DEFINITIONS_V
`define GPU_DEFINITIONS_V

`define nop 5'd0
`define wrl 5'd1
`define wrr 5'd2
`define add 5'd3
`define sub 5'd4
`define inc 5'd5
`define jnz  5'd6
`define wbg 5'd7
`define dec 5'd8
`define rvmem 5'd9
`define shl   5'd10

`define null                5'd0
`define ly                  5'd4
`define vmem_addr           5'd12
`define bh                  5'd13
`define bl                  5'd14
`define bg_buffer_block_sel 5'd15
`define state               5'd1
`define r0                  5'd16
`define r1                  5'd17
`define r2                  5'd18
`define r3                  5'd19
`define vmem_data           5'd20
`define bgmoffset           5'd21
`define bg_col_offset       5'd22
`define bgtoffset           5'd23
`define ly_mod_8            5'd24
`define vmem_data_shl_4     5'd25


`define SCANLINE_VRAM_READ  10'd3

`endif
