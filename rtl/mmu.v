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
module mmu
(
	input wire iClock,
	input wire iReset,
	input wire [15:0] iAddr,
	input wire        iWe,
	input wire [7:0]  iData,
	output wire [7:0] oData

);
	wire [7:0] wBiosData;
	wire wInBios, wInCartridgeBank0;

	bios BIOS
	(
		.iClock( iClock ),
		.iAddr( iAddr[7:0] ),
		.oData( wBiosData  )
	);

	reg [7:0] rCartridgeBank0[511:0]; 	//TODO: This has to go into SRAM!!!
	reg [7:0] rvMem[8192:0];			//TODO: This has to go into SRAM!!!


	always @ (posedge iClock)
	begin


		if (iWe)
		begin
			if (iAddr[15:13] == 3'b100)		//8000 - 9FFFF
				rvMem[iAddr[12:0]] = iData;
		end
	end

	assign oData = (wInBios) ? wBiosData : rCartridgeBank0[iAddr];


	assign wInBios           = (iAddr & 16'hff00) ? 1'b0 : 1'b1; //0x000 - 0x0100, also remember to use 0xff50, this unmaps bios ROM
	assign wInCartridgeBank0 = (iAddr & 16'hc000) ? 1'b0 : 1'b1; //0x100 - 0x3fff

endmodule
