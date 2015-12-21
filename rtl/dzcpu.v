`timescale 1ns / 1ps
`include "collaterals.v"
`include "z80_opcode_definitions.v"
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

module dzcpu
(
	input wire         iClock,
	input wire         iReset,
	input wire [7:0]   iMCUData,oMCUData,
	output wire [15:0] oMCUAddr,
	output reg         oMCUwe
);
wire[15:0]  wPc, wRegData, wUopSrc, wX16, wInitialPc ;
wire [7:0]  wuPc, wuOpBasicFlowIdx,wuOpExtendedFlowIdx, wuOpFlowIdx, wBitMask, wX8;
wire        wIPC,wEof, wZ, wCarry;
wire [2:0]  wInsnR1, wInsnR2, wInsnOp;
wire [11:0] wUop;
wire [1:0]  wPred;
wire [3:0]  wuCmd, wMcuAdrrSel;
wire [2:0]  wUopRegReadAddr0, wUopRegReadAddr1, rUopRegWriteAddr;
wire [7:0]  wB,wC,wD, wE, wH,wL,wA, wSpL, wSpH, wFlags, wUopSrcRegData0,wUopSrcRegData1, wNextUopFlowIdx;
reg         rResetFlow,rFlowEnable, rRegWe, rSetMCOAddr, rFlagsWe, rX16We, rOverWritePc, rCarry;
reg [3:0]   rRegSelect;
reg [7:0]   rZ80Result, rFlags, rWriteSelect;
reg [15:0]  rUopDstRegData;

assign wInsnR2 = iMCUData[2:0];
assign wInsnR1 = iMCUData[5:3];
assign wInsnOp = {iMCUData[7:0],iMCUData[2:0]};
assign wUopSrc = wUop[3:0];
assign wIPC    = wUop[11];		//Increment Macro Insn program counter
assign wPred   = wUop[9:8];
assign wuCmd   = wUop[7:4];

MUXFULLPARALELL_3SEL_GENERIC # ( 1'b1 ) MUX_EOF
 (
 .Sel( wUop[10:8] ),
 .I0( 1'b0 ),.I4( 1'b1 ), .I5( wFlags[`flag_z] ), .I6( ~wFlags[`flag_z] ),
 .O( wEof )
 );

dzcpu_ucode_rom urom
(
	.iAddr( wuPc ),
	.oUop( wUop  )
);

dzcpu_ucode_lut ulut
(
	.iMop( iMCUData ),
	.oUopFlowIdx( wuOpBasicFlowIdx )
);

dzcpu_ucode_cblut ucblut
(
	.iMop( iMCUData ),
	.oUopFlowIdx( wuOpExtendedFlowIdx )
);

wire wJcbDetected;

assign wJcbDetected    = ( rFlowEnable & wuCmd == `jcb ) ? 1'b1 : 1'b0;
assign wuOpFlowIdx     = ( wJcbDetected ) ? wuOpExtendedFlowIdx : wuOpBasicFlowIdx ;
assign wNextUopFlowIdx = (iReset) ? 8'b0 : wuOpFlowIdx;

UPCOUNTER_POSEDGE # (8) UPC
(
	.Clock(   iClock                             ),
	.Reset(   iReset | rResetFlow | wJcbDetected ),
	.Initial( wNextUopFlowIdx                    ),
	.Enable(  rFlowEnable                        ),
	.Q(       wuPc                               )
);

assign wInitialPc = ( rOverWritePc ) ? rUopDstRegData : 16'b0;

UPCOUNTER_POSEDGE # (16) PC
(
	.Clock(   iClock                ),
	.Reset(   iReset | rOverWritePc ),
	.Initial( wInitialPc            ),
	.Enable(  wIPC & rFlowEnable    ),
	.Q(       wPc                   )
);

//--------------------------------------------------------
// Current State Logic //
reg [7:0]    rCurrentState,rNextState;
always @(posedge iClock )
begin
     if( iReset!=1 )
        rCurrentState <= rNextState;
   else
		rCurrentState <= `DZCPU_AFTER_RESET;
end
//--------------------------------------------------------

always @( * )
 begin
  case (rCurrentState)
  //----------------------------------------
  `DZCPU_AFTER_RESET:
  begin
  	rResetFlow = 1'b0;
  	rFlowEnable = 1'b0;

  	rNextState = `DZCPU_START_FLOW;
  end
  //----------------------------------------
  `DZCPU_START_FLOW:
  begin
  	 rResetFlow  = 1'b1;
  	 rFlowEnable = 1'b0;

  	 if (iReset)
  	 	rNextState = `DZCPU_AFTER_RESET;
  	 else
  	 	rNextState = `DZCPU_RUN_FLOW;
  end
  //----------------------------------------
  `DZCPU_RUN_FLOW:
  begin
  	rResetFlow = 1'b0;
  	rFlowEnable = 1'b1;

  	if (wEof)
  		rNextState = `DZCPU_END_FLOW;
  	else
  		rNextState = `DZCPU_RUN_FLOW;
  end
  //----------------------------------------
  `DZCPU_END_FLOW:
  begin
  	rResetFlow = 1'b0;
  	rFlowEnable = 1'b0;

  	rNextState = `DZCPU_START_FLOW;
  end
  //----------------------------------------
  default:
  begin
  	rNextState = `DZCPU_AFTER_RESET;
  end
endcase
end

reg [10:0] rRegWriteSelect;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFB ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[0], rUopDstRegData[7:0], wB );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFC ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[1], rUopDstRegData[7:0], wC );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[2], (( rRegWriteSelect[2] &  rRegWriteSelect[3])? rUopDstRegData[15:8] : rUopDstRegData[7:0]), wD );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFE ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[3], rUopDstRegData[7:0], wE );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFH ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[4], (( rRegWriteSelect[4] &  rRegWriteSelect[5])? rUopDstRegData[15:8] : rUopDstRegData[7:0]), wH );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFL ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[5], rUopDstRegData[7:0], wL );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFA ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[6], rUopDstRegData[7:0], wA );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFSPL( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[7], rUopDstRegData[7:0], wSpL );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFSPH( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[8], (( rRegWriteSelect[7] &  rRegWriteSelect[8])? rUopDstRegData[15:8] : rUopDstRegData[7:0]), wSpH );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFX8 ( iClock, iReset, rFlowEnable & rRegWe & rRegWriteSelect[9], rUopDstRegData[7:0], wX8 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 16)FFX16 ( iClock, iReset, rFlowEnable & rX16We, rUopDstRegData[15:0], wX16 );
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FFFLAGS( iClock, iReset, rFlowEnable & rFlagsWe, rFlags, wFlags );
FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 4 )FFMCUADR( iClock, iReset, rFlowEnable & rSetMCOAddr, `pc , wUop[3:0], wMcuAdrrSel );

MUXFULLPARALELL_4SEL_GENERIC # (16) MUX_MCUADR
(
	.Sel( wMcuAdrrSel),
	.I0({8'b0,wB}), .I1({8'b0,wC}), .I2({8'b0,wD}), .I3({8'b0,wE}),
	.I4({8'b0,wH}), .I5({8'b0,wL}), .I6({wH,wL}), 	.I7({8'b0,wA}),
	.I8(wPc), .I9({wSpH,wSpL}), .I10({8'b0,wX8}), .I15({wD,wE}),
	.I14( {8'hff,wC}), //Special case for LDIOCA
	.O( oMCUAddr )
);

MUXFULLPARALELL_4SEL_GENERIC # (16) MUX_REGDATA
(
	.Sel( rRegSelect),
	.I0({8'b0,wB}), .I1({8'b0,wC}), .I2({8'b0,wD}), .I3({8'b0,wE}),
	.I4({8'b0,wH}), .I5({8'b0,wL}), .I6({wH,wL}),	.I7({8'b0,wA}),
	.I8(wPc), .I9({wSpH,wSpL}), .I12({8'b0,wX8}), .I13( wX16 ), .I15({wD,wE}),
	.I14( {8'hff,wC}), //Special case for LDIOCA
	.O( wRegData )
);

MUXFULLPARALELL_4SEL_GENERIC # (8) MUX_MCUDATA_OUT
(
	.Sel( rRegSelect),
	.I0(wB), .I1(wC), .I2(wD), .I3(wE),
	.I4(wH), .I5(wL), .I6(wL), .I7(wA),
	.I8(wH), .I9({wSpH,wSpL}), .I10(wL), .I11(wA),
	.I12(wH), .I13(wX16), .I14(wL), .I15(wA),
	.O( oMCUData )
);

//Consider the special case of ldrr
//assign wWriteSelect = (wuCmd == `z801bop && iMCUData[7:6] == 2'b01  ) ? iMCUData[5:3] : wUopSrc;

always @ ( * )
begin
	case (rWriteSelect)
		`b:    rRegWriteSelect = 11'b00000000001;
		`c:    rRegWriteSelect = 11'b00000000010;
		`d:    rRegWriteSelect = 11'b00000000100;
		`e:    rRegWriteSelect = 11'b00000001000;
		`de:   rRegWriteSelect = 11'b00000001100;
		`h:    rRegWriteSelect = 11'b00000010000;
		`l:    rRegWriteSelect = 11'b00000100000;
		`hl:   rRegWriteSelect = 11'b00000110000;
		`a:    rRegWriteSelect = 11'b00001000000;
		`spl:  rRegWriteSelect = 11'b00010000000;
		`sph:  rRegWriteSelect = 11'b00100000000;
		`sp:   rRegWriteSelect = 11'b00110000000;
		`x8:   rRegWriteSelect = 11'b01000000000;
		`x16:  rRegWriteSelect = 11'b10000000000;
		default: rRegWriteSelect = 11'b0;
	endcase
end

assign wZ = (rUopDstRegData == 16'b0) ? 1'b1 : 1'b0;


always @ ( * )
begin
	case (wuCmd)
		`nop:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = `null;
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = 0;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end
		`sma:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b1;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = 16'b0;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`srm:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = `null;
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = iMCUData;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`smw:
		begin
			oMCUwe              = 1'b1;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = 16'b0;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`dec16:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rFlagsWe            = 1'b1;
			rWriteSelect        = wUopSrc;
			rFlags              = {wZ,7'b0};
			rUopDstRegData      = wRegData - 16'd1;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`inc16:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b1;
			rFlags              = {wZ,7'b0};
			rUopDstRegData      = wRegData  + 1'b1;
			rX16We              = 1'b1;
			rOverWritePc        = 1'b0;
		end


		`addx16:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = wX16 + {{8{wRegData[7]}},wRegData[7:0]};	//sign extended 2'complement
			rX16We              = 1'b1;
			rOverWritePc        = 1'b0;
		end

		`spc:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = wRegData;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b1;
		end

		`jcb:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = 16'b0;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`srx8:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = wX8;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end


		`z801bop:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = {1'b0,iMCUData[2:0]};
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rWriteSelect        = ( iMCUData[7:6] == 2'b01  ) ? iMCUData[5:3] : wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = rZ80Result;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`shl:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = {1'b0,iMCUData[2:0]};
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b1;
			rWriteSelect        = {1'b0,iMCUData[2:0]};
			rFlagsWe            = 1'b1;
			rFlags              = {wZ, 1'b0, 1'b0, wRegData[7], 4'b0};
			rUopDstRegData      = (wRegData << 1) + wFlags[`flag_c];
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end


		`bit:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = {1'b0,iMCUData[2:0]};
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b1;
			rFlags              = {wZ,7'b0};
			rUopDstRegData      = wRegData & wBitMask;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end

		`sx16r:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = wUop[3:0];
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = wRegData;
			rX16We              = 1'b1;
			rOverWritePc        = 1'b0;
		end

		default:
		begin
			oMCUwe              = 1'b0;
			rRegSelect          = `pc;
			rSetMCOAddr         = 1'b0;
			rRegWe              = 1'b0;
			rWriteSelect        = wUopSrc;
			rFlagsWe            = 1'b0;
			rFlags              = 8'b0;
			rUopDstRegData      = 16'b0;
			rX16We              = 1'b0;
			rOverWritePc        = 1'b0;
		end
	endcase
end

DECODER_MASK_3_BITS BIT_MASK( iMCUData[5:3], wBitMask );

always @ ( * )
begin
	case (iMCUData[7:3])
		5'b10100:	rZ80Result = wA & wRegData; //AND
		5'b10101:	rZ80Result = wA ^ wRegData; //XOR
		5'b01000, 5'b01001, 5'b01010, 5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111: 	rZ80Result = wRegData;      //ldrr
		default:	rZ80Result = 8'hcc;
	endcase
end

endmodule
