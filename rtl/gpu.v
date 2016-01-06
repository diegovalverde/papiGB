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
module gpu
(
  input wire iClock,
  input wire iReset,

  output wire          oFramBufferWe,
  output wire [7:0]   oFramBufferData,
  output wire [15:0]  oFramBufferAddr,

  output wire [15:0] oMcuAddr,
  output reg        oMcuReadRequest,
  input wire [3:0]  iMcuRegSelect,
  input wire [7:0]  iMcuWriteData,
  input wire [7:0]  iMcuReadData,
  input wire        iMcuWe,


  output wire [7:0]  oSTAT,
  output wire [7:0]  oLCDC,
  output wire [7:0]  oSCY,
  output wire [7:0]  oSCX,
  output wire [7:0]  oLY,
  output wire [7:0]  oLYC,
  output wire [7:0]  oDMA,
  output wire [7:0]  oBGP,
  output wire [7:0]  oOBP0,
  output wire [7:0]  oOBP1,
  output wire [7:0]  oWY,
  output wire [7:0]  oWX

);
//TODO: These assigns are temporary to humor the synthesis tool
assign oFramBufferData = iMcuReadData;
assign oFramBufferAddr = oMcuAddr;
assign oFramBufferWe   = iMcuWe;

wire [20:0] wRegWriteSelect;
wire [15:0] wOp0, wOp1, wR0, wR1, wR2, wR3;
wire [7:0] wBh, wBl, wState, wIp, wInitialPc;
wire [15:0] wBGTileOffset, wBGTileMapOffset, wBGColOffset, wBGBufferBlockSel;
wire [7:0] wRegSelect;
wire [1:0] wBgPixel0,wBgPixel1,wBgPixel2,wBgPixel3,wBgPixel4,wBgPixel5,wBgPixel6,wBgPixel7;
wire [19:0] wUop;
wire wZ, wRegWe, wGpuActive;
reg [15:0] rResult;
reg rRegWe, rBgBufferWe, rJump;



assign oSTAT = { 6'b0, wState };

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LCDC( iClock, iReset, wRegWe  & wRegWriteSelect[0], iMcuWriteData, oLCDC );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFX_STAT(   iClock, iReset, wRegWe  & wRegWriteSelect[1], rResult[7:0], wState );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_SCY(  iClock, iReset, wRegWe  & wRegWriteSelect[2], iMcuWriteData, oSCY );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_SCX(  iClock, iReset, wRegWe  & wRegWriteSelect[3], iMcuWriteData, oSCX );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LY(   iClock, iReset, wRegWe  & wRegWriteSelect[4], rResult[7:0], oLY );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LYC(  iClock, iReset, wRegWe  & wRegWriteSelect[5], iMcuWriteData, oLYC );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_DMA(  iClock, iReset, wRegWe  & wRegWriteSelect[6], iMcuWriteData, oDMA );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFS_BGP(  iClock, iReset, wRegWe  & wRegWriteSelect[7], iMcuWriteData, oBGP );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFS_OBP0( iClock, iReset, wRegWe  & wRegWriteSelect[8], iMcuWriteData, oOBP0 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX_OBP1( iClock, iReset, wRegWe  & wRegWriteSelect[9], iMcuWriteData, oOBP1 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFS_WY(   iClock, iReset, wRegWe  & wRegWriteSelect[10], iMcuWriteData, oWY );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX_WX(   iClock, iReset, wRegWe  & wRegWriteSelect[11], iMcuWriteData, oWX );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 )FFX_12(   iClock, iReset, wRegWe  & wRegWriteSelect[12], rResult, oMcuAddr );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX_13(   iClock, iReset, wRegWe  & wRegWriteSelect[13], rResult[7:0], wBh );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX_14(   iClock, iReset, wRegWe  & wRegWriteSelect[14], rResult[7:0], wBl );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX_15(   iClock, iReset, wRegWe  & wRegWriteSelect[15], rResult[7:0], wBGBufferBlockSel );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 )FFX_16(   iClock, iReset, wRegWe  & wRegWriteSelect[16], rResult, wR0 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 )FFX_17(   iClock, iReset, wRegWe  & wRegWriteSelect[17], rResult, wR1 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 )FFX_18(   iClock, iReset, wRegWe  & wRegWriteSelect[18], rResult, wR2 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 )FFX_19(   iClock, iReset, wRegWe  & wRegWriteSelect[19], rResult, wR3 );


FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 )FFX_Z(   iClock, iReset, wRegWe, (rResult == 8'b0) ? 1'b1 : 1'b0, wZ );


assign wInitialPc = ( rJump ) ? wUop[14:10]: 8'b0;

UPCOUNTER_POSEDGE # (8) PC
(
  .Clock(   iClock                ),
  .Reset(   iReset | rJump        ),
  .Initial( wInitialPc            ),
  .Enable(  ~iReset & wGpuActive  ),
  .Q(       wIp                   )
);

assign wGpuActive = (oLCDC[7]) ? 1'b1 : 1'b0;
assign wRegSelect       = ( wGpuActive ) ? wUop[14:10] : iMcuRegSelect ;
assign wRegWe           = ( wGpuActive ) ? rRegWe : iMcuWe ;
assign wBGTileOffset    = ( oLCDC[4] ) ? 16'h8000 : 16'h8800;
assign wBGTileMapOffset = ( oLCDC[6] ) ? 16'h9c00 : 16'h9800;
assign wBGColOffset     =   oLY << 5;



MUXFULLPARALELL_5SEL_GENERIC # (21) MUX_REG_WE
(
  .Sel( wRegSelect[4:0] ),

  .I0( 21'b000000000000000000001),
  .I1( 21'b000000000000000000010),
  .I2( 21'b000000000000000000100),
  .I3( 21'b000000000000000001000),
  .I4( 21'b000000000000000010000),
  .I5( 21'b000000000000000100000),
  .I6( 21'b000000000000001000000),
  .I7( 21'b000000000000010000000),
  .I8( 21'b000000000000100000000),
  .I9( 21'b000000000001000000000),
  .I10(21'b000000000010000000000),
  .I11(21'b000000000100000000000),
  .I12(21'b000000001000000000000),
  .I13(21'b000000010000000000000),
  .I14(21'b000000100000000000000),
  .I15(21'b000001000000000000000),
  .I16(21'b000010000000000000000),
  .I17(21'b000100000000000000000),
  .I18(21'b001000000000000000000),
  .I19(21'b010000000000000000000),
  .I20(21'b100000000000000000000),

  .O( wRegWriteSelect )
);

//TODO: Split this into a n 8bit MUX and 16bit MUX
MUXFULLPARALELL_5SEL_GENERIC # (16) MUX_REG0
(
  .Sel( wUop[4:0] ),

  .I0( {8'h0,oLCDC} ), .I1( {8'h0,oSTAT} ), .I2( {8'h0,oSCY} ), .I3( {8'h0,oSCX} ),
  .I4( {8'h0,oLY} ),   .I5( {8'h0,oLYC} ),  .I6( {8'h0,oDMA} ), .I7( {8'h0,oBGP} ),
  .I8( {8'h0,oOBP0} ), .I9( {8'h0,oOBP1} ), .I10( {8'h0,oWY} ), .I11( {8'h0,oWX} ),
  .I12( oMcuAddr ),   .I13( wBh ),   .I14( wBl),  .I15( wBGBufferBlockSel ),
  .I16( wR0 ),   .I17( wR1 ), .I18( wR2 ), .I19( wR3 ),
  .I20( {8'h0,iMcuReadData} ), .I21( wBGTileMapOffset ), .I22( wBGColOffset ), .I23( wBGTileOffset ),
  .I24( {8'h0,6'h0,oLY[1:0]} ), .I25( {4'b0,iMcuReadData,4'b0} ), .I26( 16'b0 ), .I27( 16'b0 ),
  .I28( 16'b0 ), .I29( 16'b0 ), .I30( 16'b0 ), .I31( 16'b0 ),
  .O( wOp0 )
);

MUXFULLPARALELL_5SEL_GENERIC # (16) MUX_REG1
(
  .Sel( wUop[9:5] ),

  .I0( {8'h0,oLCDC} ), .I1( {8'h0,oSTAT} ), .I2( {8'h0,oSCY} ), .I3( {8'h0,oSCX} ),
  .I4( {8'h0,oLY} ),   .I5( {8'h0,oLYC} ),  .I6( {8'h0,oDMA} ), .I7( {8'h0,oBGP} ),
  .I8( {8'h0,oOBP0} ), .I9( {8'h0,oOBP1} ), .I10( {8'h0,oWY} ), .I11( {8'h0,oWX} ),
  .I12( oMcuAddr ),   .I13( wBh ),   .I14( wBl),  .I15( wBGBufferBlockSel ),
  .I16( wR0 ),   .I17( wR1 ), .I18( wR2 ), .I19( wR3 ),
  .I20( {8'h0,iMcuReadData} ), .I21( wBGTileMapOffset ), .I22( wBGColOffset ), .I23( wBGTileOffset ),
  .I24( {8'h0,6'h0,oLY[1:0]} ), .I25( {4'b0,iMcuReadData,4'b0} ), .I26( 16'b0 ), .I27( 16'b0 ),
  .I28( 16'b0 ), .I29( 16'b0 ), .I30( 16'b0 ), .I31( 16'b0 ),
  .O( wOp1 )
);


//Do palette background color conversion for 8 pixels in parallel
MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP0 (   .Sel( {wBh[0], wBl[0]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel0)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP1 (   .Sel( {wBh[1], wBl[1]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel1)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP2 (   .Sel( {wBh[2], wBl[2]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel2)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP3 (   .Sel( {wBh[3], wBl[3]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel3)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP4 (   .Sel( {wBh[4], wBl[4]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel4)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP5 (   .Sel( {wBh[5], wBl[5]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel5)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP6 (   .Sel( {wBh[6], wBl[6]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel6)  );

MUXFULLPARALELL_2SEL_GENERIC # (2) MUX_BGP7 (   .Sel( {wBh[7], wBl[7]} ),
  .I0( oBGP[1:0]), .I1( oBGP[3:2]), .I2( oBGP[5:4]), .I3( oBGP[7:6]) , .O( wBgPixel7)  );


wire [15:0] wFramBuffer;

RAM_SINGLE_READ_PORT # ( .DATA_WIDTH(16), .ADDR_WIDTH(3), .MEM_SIZE(32) ) BG_BUFFER
(
 .Clock( iClock ),
 .iWriteEnable(  rBgBufferWe    ),
 .iReadAddress0( 3'b0    ),
 .iWriteAddress( wBGBufferBlockSel  ),
 .iDataIn(       {wBgPixel0,wBgPixel1,wBgPixel2,wBgPixel3,wBgPixel4,wBgPixel5,wBgPixel6,wBgPixel7}  ),
 .oDataOut0( wFramBuffer        )
);




always @ ( * )
begin
  case (wUop[19:15])
   `gnop:
    begin
      rResult     = wUop[7:0];
      rRegWe      = 1'b0;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `gwbg:
    begin
      rResult     = wUop[7:0];
      rRegWe      = 1'b0;
      rBgBufferWe = 1'b1;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `gwrr:
    begin
      rResult     = wOp1;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `gwrl:
    begin
      rResult     = wUop[7:0];
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `grvmem:
    begin
      rResult     = wUop[7:0];
      rRegWe      = 1'b0;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b1;
    end

    `gadd:
    begin
      rResult     = wOp1 + wOp0 ;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end


    `gshl:
    begin
      rResult     = wOp1 << wUop[5:0]  ;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `ginc:
    begin
      rResult     = wOp1 + 1 ;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `gdec:
    begin
      rResult     = wOp1 - 1 ;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end


    `gsub:
    begin
      rResult     = wOp1 - wOp0;
      rRegWe      = 1'b1;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

    `gjnz:
    begin
      rResult     = wOp1 ;
      rRegWe      = 1'b0;
      rBgBufferWe = 1'b0;
      rJump       = ~wZ;
      oMcuReadRequest = 1'b0;
    end

    default:
    begin
      rResult     = 16'hdead ;
      rRegWe      = 1'b0;
      rBgBufferWe = 1'b0;
      rJump       = 1'b0;
      oMcuReadRequest = 1'b0;
    end

  endcase
end

gpu_ucode_rom UCODE_ROM
(
  .iAddr( wIp ),
  .oUop(  wUop)
);

endmodule
