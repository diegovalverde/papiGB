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

	//CPU
	input wire        iCpuReadRequest,
	input wire [15:0] iCpuAddr,
	input wire        iCpuWe,
	input wire [7:0]  iCpuData,
	output wire [7:0] oData,

	//GPU
	input wire        iGpuReadRequest,
	input wire [15:0] iGpuAddr,
	output wire [3:0] oGpu_RegSelect,
	output wire       oGpu_RegWe,
	output wire [7:0] oGPU_RegData,

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
	wire [15:0] wAddr, wVmemReadAddr;
	wire wInBios, wInCartridgeBank0, wWeZeroPage, wWeVRam, wCPU_GPU_Sel;

	//Choose who has Memory access at this point in time: GPU or CPU
	//Simply check MSb from STAT mode. Also check to see if LCD is ON
	assign wCPU_GPU_Sel = ( iGPU_LCDC[7] & iGPU_STAT[1]  ) ? 1'b1 : 1'b0 ;
	assign wAddr =  iCpuAddr;
	assign wVmemReadAddr = ( wCPU_GPU_Sel ) ? iGpuAddr[12:0] : iCpuAddr[12:0];
	assign oGPU_RegData = iCpuData;


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
 .iReadAddress0( wVmemReadAddr[12:0]  ),
 .iWriteAddress( wAddr[12:0]  ),
 .iDataIn(       iCpuData        ),
 .oDataOut0( wReadVmem        )
);

//A high-speed area of 128 bytes of RAM.
//Will use FPGA internal mem since most of the interaction between
//the program and the GameBoy hardware occurs through use of this page of memory.
RAM_SINGLE_READ_PORT # ( .DATA_WIDTH(8), .ADDR_WIDTH(7), .MEM_SIZE(128) ) ZERO_PAGE
(
 .Clock( iClock ),
 .iWriteEnable( wWeZeroPage   ),
 .iReadAddress0( wAddr[6:0]   ),
 .iWriteAddress( wAddr[6:0]   ),
 .iDataIn(       iCpuData        ),
 .oDataOut0( wZeroPageDataOut )
);

assign oGpu_RegSelect = wAddr[3:0];

///  READ .///
MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MEMREAD_LCD_REGISTERS
(
	.Sel( wAddr[3:0]),
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
	.Sel( wAddr[6:4]),                    //FF00-FF7F
	.I0( wJoyPadAndTimers            ),   //F-0     wAddr[6:4] = 000
	.I1( wSoundRegisters_Group0      ),   //1F-F    wAddr[6:4] = 001
	.I2( wSoundRegisters_Group1      ),   //2F-20   wAddr[6:4] = 010
	.I3( wSoundRegisters_WavePattern ),   //3F-30   wAddr[6:4] = 011
	.I4( wLCDRegisters               ),   //4F-40   wAddr[6:4] = 100
	.I5( 8'b0                        ),
	.I6( 8'b0                        ),
	.I7( 8'b0                        ),
	.O( wIORegisters )
);



MUXFULLPARALELL_2SEL_GENERIC # (8) MUX_MEMREAD_IO_ZERPAGE_INTERRUPTS
(
	.Sel( wAddr[7:6]),
	.I0( wIORegisters     ),    //FF00-FF7F     wAddr[7:6] = 00
	.I1( wIORegisters     ),    //FF00-FF7F     wAddr[7:6] = 01
	.I2( wZeroPageDataOut ),	//FF80-FFFF     wAddr[7:6] = 10
	.I3( wZeroPageDataOut ),	//FF80-FFFF     wAddr[7:6] = 11
	.O(  wZIOData )

);

MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MEMREAD_L
(
	.Sel( wAddr[11:8] ),
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
	.Sel( wAddr[15:12] ),
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
assign wWeZeroPage = ( iCpuWe && wAddr[15:12] == 4'hf && wAddr[11:8] == 4'hf && (wAddr[7:6] == 2'h2 || wAddr[7:6] == 2'h3) ) ? 1'b1 : 1'b0 ;
assign wWeVRam     = ( iCpuWe && (wAddr[15:12] == 4'h8 || wAddr[15:12] == 4'h9 ) ) ? 1'b1 : 1'b0;
assign oGpu_RegWe  = ( iCpuWe && wAddr[15:4] == 12'hff4 ) ? 1'b1 : 1'b0;

assign wReadCartridgeBank0 = (wInBios) ? wBiosData : rCartridgeBank0[wAddr];



assign wInBios           = (wAddr & 16'hff00) ? 1'b0 : 1'b1; //0x000 - 0x0100, also remember to use 0xff50, this unmaps bios ROM
assign wInCartridgeBank0 = (wAddr & 16'hc000) ? 1'b0 : 1'b1; //0x100 - 0x3fff

endmodule
