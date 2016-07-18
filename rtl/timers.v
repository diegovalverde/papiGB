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
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1303'd1, USA.
//
////////////////////////////////////////////////////////////////////////////////////
module timers
(
 input wire iClock,
 input wire iReset,
 input wire [7:0] iOpcode,
 input wire iTick,
 input wire iIsCb,
 output wire oInterrupt0x50

);

wire wBaseClock;
wire wBaseClockDivider[7:0];



    wire [47:0] wClockIncrementRow, wClockIncrementRowCB, wClockIncrementRowBasic;
    wire [2:0]  wClockIncrement;


    MUXFULLPARALELL_4SEL_GENERIC #(48) MUX_CLOCK_STEP_1
    (
        .Sel(iOpcode[7:4]),
    /*000*/    .I0( {3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd5, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*016*/    .I1( {3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd3, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*032*/    .I2( {3'd2, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*048*/    .I3( {3'd2, 3'd3, 3'd2, 3'd2, 3'd3, 3'd3, 3'd3, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*064*/    .I4( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*080*/    .I5( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*096*/    .I6( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*112*/    .I7( {3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*128*/    .I8( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*144*/    .I9( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*160*/    .I10({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*176*/    .I11({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    /*192*/    .I12({3'd2, 3'd3, 3'd3, 3'd4, 3'd3, 3'd4, 3'd2, 3'd4, 3'd2, 3'd4, 3'd3, 3'd0, 3'd3, 3'd6, 3'd2, 3'd4}),
    /*208*/    .I13({3'd2, 3'd3, 3'd3, 3'd0, 3'd3, 3'd4, 3'd2, 3'd4, 3'd2, 3'd4, 3'd3, 3'd0, 3'd3, 3'd0, 3'd2, 3'd4}),
    /*224*/    .I14({3'd3, 3'd3, 3'd2, 3'd0, 3'd0, 3'd4, 3'd2, 3'd4, 3'd4, 3'd1, 3'd4, 3'd0, 3'd0, 3'd0, 3'd2, 3'd4}),
    /*240*/    .I15({3'd3, 3'd3, 3'd2, 3'd1, 3'd0, 3'd4, 3'd2, 3'd4, 3'd3, 3'd2, 3'd4, 3'd1, 3'd0, 3'd0, 3'd2, 3'd4}),
        .O(wClockIncrementRowBasic)
    );


    assign wClockIncrementRow = (iIsCb) ? wClockIncrementRowCB : wClockIncrementRowBasic;


    MUXFULLPARALELL_4SEL_GENERIC #(3) MUX_CLOCK_STEP_2
    (
        .Sel(iOpcode[3:0]),
        .I15(  wClockIncrementRow[2:0]),
        .I14(  wClockIncrementRow[5:3]),
        .I13(  wClockIncrementRow[8:6]),
        .I12(  wClockIncrementRow[11:9]),
        .I11(  wClockIncrementRow[14:12]),
        .I10(  wClockIncrementRow[17:15]),
        .I9(  wClockIncrementRow[20:18]),
        .I8(  wClockIncrementRow[23:21]),
        .I7(  wClockIncrementRow[26:24]),
        .I6(  wClockIncrementRow[29:27]),
        .I5( wClockIncrementRow[32:30]),
        .I4( wClockIncrementRow[35:33]),
        .I3( wClockIncrementRow[38:36]),
        .I2( wClockIncrementRow[41:39]),
        .I1( wClockIncrementRow[44:42]),
        .I0( wClockIncrementRow[47:45]),
        .O(wClockIncrement)
    );




    MUXFULLPARALELL_4SEL_GENERIC #(48) MUX_CLOCK_STEP_1_CB
    (
        .Sel(iOpcode[7:4]),
        .I0({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I1({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I2({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I3({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I4({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2}),
        .I5({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2}),
        .I6({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2}),
        .I7({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd3, 3'd2}),
        .I8({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I9({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I10({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I11({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I12({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I13({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I14({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .I15({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd4, 3'd2}),
        .O(wClockIncrementRowCB)

    );

wire [7:0] wDiv,wTima;
assign wTima =  8'b0;  //TODO Fix this!

assign wDiv = (rMTime << 2);

  reg  [7:0]  rMTime;
  reg         rIncrementBTime;
  wire [7:0]  wBClock; //Base clock

   always @ (posedge iClock)
   begin
      if (iReset)
      begin
        rMTime = 8'b0;
      end
      else
      begin
        if (iTick)
          {rIncrementBTime,rMTime} = rMTime + {4'b0,wClockIncrement[2:0]};
      end
   end //always


    UPCOUNTER_POSEDGE # (8) BCLOCK
   (
   .Clock( iClock ),
   .Reset( iReset ),
   .Initial( 8'b0 ),
   .Enable( iTick & rIncrementBTime ),
   .Q( wBClock )
   );



endmodule
