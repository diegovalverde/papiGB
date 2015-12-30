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
	input wire [15:0] iCpuAddr,
	input wire        iWe,
	input wire [7:0]  iData,
	output wire [7:0] oData,



	//IO Registers
	input wire [7:0]  iGPU_LCDC,
	input wire [7:0]  iGPU_STAT,
	input wire [7:0]  iGPU_SCY,
	input wire [7:0]  iGPU_SCX,
	input wire [7:0]  iGPU_LY,
	input wire [7:0]  iGPU_LYC,
	input wire [7:0]  iGPU_DMA,
	input wire [7:0]  iGPU_BGP,
	input wire [7:0]  iGPU_OBP0,
	input wire [7:0]  iGPU_OBP1,
	input wire [7:0]  iGPU_WY,
	input wire [7:0]  iGPU_WX


);
	wire [7:0] wBiosData, wZeroPageDataOut, wZIOData, wIORegisters,wLCDRegisters,wSoundRegisters_Group0,wSoundRegisters_Group1;
	wire [7:0] wSoundRegisters_WavePattern, wJoyPadAndTimers;
	wire wInBios, wInCartridgeBank0, wWeZeroPage, wWeVRam;


	bios BIOS
	(
		.iClock( iClock ),
		.iAddr( iCpuAddr[7:0] ),
		.oData( wBiosData  )
	);

	reg [7:0] rCartridgeBank0[511:0]; 	//TODO: This has to go into SRAM!!!
	//reg [7:0] rvMem[8192:0];			//TODO: This has to go into SRAM!!!
	wire [3:0] wMemSel_H, wMemSel_L;
	wire [7:0] wReadCartridgeBank0, wReadVmem, wReadData_L;


//TODO: This has to go into SRAM!!!
RAM_SINGLE_READ_PORT # ( .DATA_WIDTH(8), .ADDR_WIDTH(13), .MEM_SIZE(8192) ) VMEM
(
 .Clock( iClock ),
 .iWriteEnable( wWeVRam       ),
 .iReadAddress0( iCpuAddr[12:0]  ),
 .iWriteAddress( iCpuAddr[12:0]  ),
 .iDataIn(       iData        ),
 .oDataOut0( wReadVmem        )
);

//A high-speed area of 128 bytes of RAM.
//Will use FPGA internal mem since most of the interaction between
//the program and the GameBoy hardware occurs through use of this page of memory.
RAM_SINGLE_READ_PORT # ( .DATA_WIDTH(8), .ADDR_WIDTH(7), .MEM_SIZE(128) ) ZERO_PAGE
(
 .Clock( iClock ),
 .iWriteEnable( wWeZeroPage   ),
 .iReadAddress0( iCpuAddr[6:0]   ),
 .iWriteAddress( iCpuAddr[6:0]   ),
 .iDataIn(       iData        ),
 .oDataOut0( wZeroPageDataOut )
);



///  READ .///
MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MEMREAD_LCD_REGISTERS
(
	.Sel( iCpuAddr[3:0]),
	.I0( iGPU_LCDC            ),
	.I1( iGPU_STAT            ),
	.I2( iGPU_SCY             ),
	.I3( iGPU_SCX             ),
	.I4( iGPU_LY              ),
	.I5( iGPU_LYC             ),
	.I6( iGPU_DMA             ),
	.I7( iGPU_BGP             ),
	.I8( iGPU_OBP0            ),
	.I9( iGPU_OBP1            ),
	.I10( iGPU_WY             ),
	.I11( iGPU_WX             ),
	.I12( 8'b0                ),
	.I13( 8'b0                ),
	.I14( 8'b0                ),
	.I15( 8'b0                ),
	.O( wLCDRegisters )
);

MUXFULLPARALELL_3SEL_GENERIC # (8) MUX_MEMREAD_IO_REGISTERS
(
	.Sel( iCpuAddr[6:4]),                    //FF00-FF7F
	.I0( wJoyPadAndTimers            ),   //F-0     iCpuAddr[6:4] = 000
	.I1( wSoundRegisters_Group0      ),   //1F-F    iCpuAddr[6:4] = 001
	.I2( wSoundRegisters_Group1      ),   //2F-20   iCpuAddr[6:4] = 010
	.I3( wSoundRegisters_WavePattern ),   //3F-30   iCpuAddr[6:4] = 011
	.I4( wLCDRegisters               ),   //4F-40   iCpuAddr[6:4] = 100
	.I5( 8'b0                        ),
	.I6( 8'b0                        ),
	.I7( 8'b0                        ),
	.O( wIORegisters )
);



MUXFULLPARALELL_2SEL_GENERIC # (8) MUX_MEMREAD_IO_ZERPAGE_INTERRUPTS
(
	.Sel( iCpuAddr[7:6]),
	.I0( wIORegisters     ),    //FF00-FF7F     iCpuAddr[7:6] = 00
	.I1( wIORegisters     ),    //FF00-FF7F     iCpuAddr[7:6] = 01
	.I2( wZeroPageDataOut ),	//FF80-FFFF     iCpuAddr[7:6] = 10
	.I3( wZeroPageDataOut ),	//FF80-FFFF     iCpuAddr[7:6] = 11
	.O(  wZIOData )

);

MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MEMREAD_L
(
	.Sel( iCpuAddr[11:8] ),
	//ECHO
	.I0(8'b0), .I1(8'b0),
	.I2(8'b0), .I3(8'b0),
	.I4(8'b0), .I5(8'b0),
	.I6(8'b0), .I7(8'b0),
	.I8(8'b0), .I9(8'b0),
	.I10(8'b0), .I11(8'b0),
	.I12(8'b0), .I13(8'b0),
	.I14(8'b0),
	//OAM
	//.I14(ADDR_OAM),
	//Zeropage RAM, I/O, interrupts
	.I15( wZIOData ), //wZeroPageDataOut),

	.O( wReadData_L )
);

MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MEMREAD_H
(
	.Sel( iCpuAddr[15:12] ),
	//ROM Bank 0
	.I0(wReadCartridgeBank0), .I1(wReadCartridgeBank0),
	.I2(wReadCartridgeBank0), .I3(wReadCartridgeBank0),
	.I4(wReadCartridgeBank0), .I5(wReadCartridgeBank0),
	.I6(wReadCartridgeBank0), .I7(wReadCartridgeBank0),

	//VIDEO RAM
	.I8(wReadVmem), .I9(wReadVmem),

	//External RAM
	.I10(8'b0), .I11(8'b0),
	// Work RAM and Echo
	.I12( 8'b0), .I13(8'b0), .I14(8'b0),
	//Extended Regions
	.I15( wReadData_L ),

	.O( oData )
);

//ZeroPage FF80 - FFFF
assign wWeZeroPage = ( iWe && iCpuAddr[15:12] == 4'hf && iCpuAddr[11:8] == 4'hf && (iCpuAddr[7:6] == 2'h2 || iCpuAddr[7:6] == 2'h3) ) ? 1'b1 : 1'b0 ;
assign wWeVRam = ( iWe && (iCpuAddr[15:12] == 4'h8 || iCpuAddr[15:12] == 4'h9 ) ) ? 1'b1 : 1'b0;


assign wReadCartridgeBank0 = (wInBios) ? wBiosData : rCartridgeBank0[iCpuAddr];



assign wInBios           = (iCpuAddr & 16'hff00) ? 1'b0 : 1'b1; //0x000 - 0x0100, also remember to use 0xff50, this unmaps bios ROM
assign wInCartridgeBank0 = (iCpuAddr & 16'hc000) ? 1'b0 : 1'b1; //0x100 - 0x3fff

endmodule
