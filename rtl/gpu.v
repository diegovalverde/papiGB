`timescale 1ns / 1ps

`ifdef GPU
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
module gpu
(
	input wire iClock,
	input wire iReset,
	input wire [15:0] iAddr,
	input wire        iWe,
	input wire [7:0]  iData,
	output wire [7:0] oData

);

parameter GPU_RESET          4
parameter SCANLINE_OAM_READ  2
parameter SCANLINE_VRAM_READ 3
parameter HORIZONTAL_BLANK   0
parameter VERTICAL_BLANK     1

//--------------------------------------------------------
// Current State Logic //
reg [7:0]    rCurrentState,rNextState;
always @(posedge iClock )
begin
     if( iReset!=1 )
        rCurrentState <= rNextState;
   else
		rCurrentState <= `SCANLINE_OAM_READ;
end
//--------------------------------------------------------

addl i 0
add   addr bgOffset curCol
add   addr addr curRow
rvmem  r1 addr 		//idx = VMEM[addr]
add addr r1 tileMapOffset

loop:
rvmem  bh addr
inc addr
rvmem  bl addr
wbuffer b //h and l, it knows how to mangle each bit
inc i
jll loop i 32

//Color are single FF so I can use in parallel
//There are 4 dual read pallette, to do pallete conversion in 1 cc
//for all 8 pixels
assign Color0 = Palette0[ {bh[0],bl[0]} ]
assign Color1 = Palette0[ {bh[1],bl[1]} ]

assign Color2 = Palette0[ {bh[0],bl[0]} ]
assign Color3 = Palette0[ {bh[1],bl[1]} ]
...
assign Color7 = Palette[ {bh[7],bl[7]} ]


//Now do the sprites
add addr oamOffset curCol
rvmem x addr
inc addr
rvmem y addr
jl NEXT y curCol
j NEXT y cur

NEXT:


always @( * )
 begin
  case (rCurrentState)
  //----------------------------------------
  //Read all that you need from OAM in order to render current scanline
  SCANLINE_OAM_READ:
  begin

  end
  //----------------------------------------
  //Read all that you need from VRAM in order to render current scanline
  SCANLINE_VRAM_READ:
  begin
  end
  //----------------------------------------
  HORIZONTAL_BLANK:
  begin
  end
  //----------------------------------------
  VERTICAL_BLANK:
  begin
  end
  //----------------------------------------
  default:
  begin
  end
  //----------------------------------------


endmodule
`endif
