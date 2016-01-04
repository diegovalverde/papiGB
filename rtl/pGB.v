`timescale 1ns / 1ps
`include "aDefinitions.v"

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
module pGB
(

input wire iClock,
input wire iReset

);

wire [15:0] wdZCPU_2_MMU_Addr, wGPU_2_MCU_Addr;
wire [7:0]  wdZCPU_2_MMU_WriteData, wMMU_ReadData;
wire        wdZCPU_2_MMU_We, wdZCPU_2_MMU_ReadRequest;

wire[7:0] wGPU_2_MCU_LCDC;
wire[7:0] wGPU_2_MCU_STAT;
wire[7:0] wGPU_2_MCU_SCY;
wire[7:0] wGPU_2_MCU_SCX;
wire[7:0] wGPU_2_MCU_LY;
wire[7:0] wGPU_2_MCU_LYC;
wire[7:0] wGPU_2_MCU_DMA;
wire[7:0] wGPU_2_MCU_BGP;
wire[7:0] wGPU_2_MCU_OBP0;
wire[7:0] wGPU_2_MCU_OBP1;
wire[7:0] wGPU_2_MCU_WY;
wire[7:0] wGPU_2_MCU_WX;
wire[15:0] wGpuAddr, wGPU_RegData;
wire[4:0] wGpu_RegSelect;
wire wGpu_RegWe, wGPU_2_MCU_ReadRequest;



dzcpu  DZCPU
(
	.iClock( iClock ),
	.iReset( iReset ),
	.iMCUData( wMMU_ReadData ),
	.oMCUAddr( wdZCPU_2_MMU_Addr      ),
	.oMCUwe( wdZCPU_2_MMU_We ),
	.oMCUData( wdZCPU_2_MMU_WriteData ),
	.oMcuReadRequest( wdZCPU_2_MMU_ReadRequest )
);


mmu MMU
(
	.iClock( iClock ),
	.iReset( iReset ),

	//CPU
	.iCpuReadRequest( wdZCPU_2_MMU_ReadRequest ),
	.iGpuReadRequest( wGPU_2_MCU_ReadRequest ),
	.iCpuAddr(  wdZCPU_2_MMU_Addr ),
	.iCpuWe(    wdZCPU_2_MMU_We   ),
	.iCpuData(  wdZCPU_2_MMU_WriteData ),
	.oData(  wMMU_ReadData ),

	.iGpuAddr( wGPU_2_MCU_Addr      ),
	.oGPU_RegData( wGPU_RegData     ),
	.oGpu_RegSelect( wGpu_RegSelect ),
	.oGpu_RegWe( wGpu_RegWe         ),

	.iGPU_LCDC( wGPU_2_MCU_LCDC ),
	.iGPU_STAT( wGPU_2_MCU_STAT ),
	.iGPU_SCY(  wGPU_2_MCU_SCY  ),
	.iGPU_SCX(  wGPU_2_MCU_SCX  ),
	.iGPU_LY(   wGPU_2_MCU_LY   ),
	.iGPU_LYC(  wGPU_2_MCU_LYC  ),
	.iGPU_DMA(  wGPU_2_MCU_DMA  ),
	.iGPU_BGP(  wGPU_2_MCU_BGP  ),
	.iGPU_OBP0( wGPU_2_MCU_OBP0 ),
	.iGPU_OBP1( wGPU_2_MCU_OBP1 ),
	.iGPU_WY(   wGPU_2_MCU_WY   ),
	.iGPU_WX(   wGPU_2_MCU_WX   )
);

gpu GPU
(
  .iClock( iClock ),
  .iReset( iReset ),
  //.oFramBufferWe(),
  //.oFramBufferData(),
  //.oFramBufferAddr(),
  .oMcuAddr( wGPU_2_MCU_Addr ),
	.oMcuReadRequest( wGPU_2_MCU_ReadRequest ),
  .iMcuRegSelect( wGpu_RegSelect),
  .iMcuWriteData( wGPU_RegData ),
	.iMcuReadData(  wMMU_ReadData ),
  .iMcuWe( wGpu_RegWe ),
  .oSTAT( wGPU_2_MCU_STAT ),
  .oLCDC( wGPU_2_MCU_LCDC ),
  .oSCY(  wGPU_2_MCU_SCY  ),
  .oSCX(  wGPU_2_MCU_SCX  ),
  .oLY(   wGPU_2_MCU_LY   ),
  .oLYC(  wGPU_2_MCU_LYC  ),
  .oDMA(  wGPU_2_MCU_DMA  ),
  .oBGP(  wGPU_2_MCU_BGP  ),
  .oOBP0( wGPU_2_MCU_OBP0 ),
  .oOBP1( wGPU_2_MCU_OBP1 ),
  .oWY(   wGPU_2_MCU_WY   ),
  .oWX(   wGPU_2_MCU_WX   )
);

endmodule
