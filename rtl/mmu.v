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
	wire [7:0] wBiosData, wZeroPageDataOut;
	wire wInBios, wInCartridgeBank0, wWeZeroPage, wWeVRam;

	parameter ADDR_NULL       = 4'b0000;
	parameter ADDR_VRAM       = 4'b0001;
	parameter ADDR_EXT_RAM    = 4'b0010;
	parameter ADDR_WORK_ECHO  = 4'b0100;
	parameter ADDR_HIGH_PAGES = 4'b1000;
	parameter ADDR_ECHO       = 4'b0001;
	parameter ADDR_OAM        = 4'b0010;
	parameter ADDR_ZERO_PAGE  = 4'b0100;

	parameter addr_vram       = 0;
	parameter addr_ext_ram    = 1;
	parameter addr_work_echo  = 2;
	parameter addr_high_pages = 3;

	bios BIOS
	(
		.iClock( iClock ),
		.iAddr( iAddr[7:0] ),
		.oData( wBiosData  )
	);

	reg [7:0] rCartridgeBank0[511:0]; 	//TODO: This has to go into SRAM!!!
	reg [7:0] rvMem[8192:0];			//TODO: This has to go into SRAM!!!
	wire [3:0] wMemSel_H, wMemSel_L;

//A high-speed area of 128 bytes of RAM.
//Will use FPGA internal mem since most of the interaction between
//the program and the GameBoy hardware occurs through use of this page of memory.
RAM_SINGLE_READ_PORT # ( .DATA_WIDTH(8), .ADDR_WIDTH(7), .MEM_SIZE(128) ) ZERO_PAGE
(
 .Clock( iClock ),
 .iWriteEnable( wWeZeroPage   ),
 .iReadAddress0( iAddr[6:0]   ),
 .iWriteAddress( iAddr[6:0]   ),
 .iDataIn(       iData        ),
 .oDataOut0( wZeroPageDataOut )
);



MUXFULLPARALELL_4SEL_GENERIC # (4) MUX_MEMSEL_H
(
	.Sel( iAddr[15:12] ),
	//ROM Bank 0
	.I0(ADDR_NULL), .I1(ADDR_NULL),
	.I2(ADDR_NULL), .I3(ADDR_NULL),
	.I4(ADDR_NULL), .I5(ADDR_NULL),
	.I6(ADDR_NULL), .I7(ADDR_NULL),

	//VIDEO RAM
	.I8(ADDR_VRAM), .I9(ADDR_VRAM),

	//External RAM
	.I10(ADDR_EXT_RAM), .I11(ADDR_EXT_RAM),
	// Work RAM and Echo
	.I12( ADDR_WORK_ECHO), .I13(ADDR_WORK_ECHO), .I14(ADDR_WORK_ECHO),
	//Extended Regions
	.I15(ADDR_HIGH_PAGES),

	.O( wMemSel_H )
);

MUXFULLPARALELL_4SEL_GENERIC # (4) MUX_MEMSEL_L
(
	.Sel( iAddr[11:8] ),
	//ECHO
	.I0(ADDR_ECHO), .I1(ADDR_ECHO),
	.I2(ADDR_ECHO), .I3(ADDR_ECHO),
	.I4(ADDR_ECHO), .I5(ADDR_ECHO),
	.I6(ADDR_ECHO), .I7(ADDR_ECHO),
	.I8(ADDR_ECHO), .I9(ADDR_ECHO),
	.I10(ADDR_ECHO), .I11(ADDR_ECHO),
	.I12(ADDR_ECHO), .I13(ADDR_ECHO),
	//OAM
	.I14(ADDR_OAM),
	//Zeropage RAM, I/O, interrupts
	.I15(ADDR_ZERO_PAGE),

	.O( wMemSel_L )
);

//ZeroPage FF80 - FFFF
assign wWeZeroPage = ( iWe & wMemSel_H[addr_high_pages] & wMemSel_L[2] & iAddr[7] ) ? 1'b1 : 1'b0;
assign wWeVRam     = ( iWe & wMemSel_H[addr_vram] ) ? 1'b1 : 1'b0;

	always @ (posedge iClock)
	begin

	if (wWeVRam)//iAddr[15:13] == 3'b100)		//8000 - 9FFFF
		rvMem[iAddr[12:0]] = iData;

	end

	assign oData = (wInBios) ? wBiosData : rCartridgeBank0[iAddr];


	assign wInBios           = (iAddr & 16'hff00) ? 1'b0 : 1'b1; //0x000 - 0x0100, also remember to use 0xff50, this unmaps bios ROM
	assign wInCartridgeBank0 = (iAddr & 16'hc000) ? 1'b0 : 1'b1; //0x100 - 0x3fff

endmodule
