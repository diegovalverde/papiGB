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
 output wire oInterrupt0x50

);

wire wBaseClock;
wire wBaseClockDivider[7:0];



    wire [47:0] wClockIncrementRow;
    wire [2:0]  wClockIncrement;


    MUXFULLPARALELL_4SEL_GENERIC #(48) MUX_CLOCK_STEP_1
    (
        .Sel(iOpcode[7:4]),
        .I0( {3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd5, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I1( {3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd3, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I2( {3'd2, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I3( {3'd2, 3'd3, 3'd2, 3'd2, 3'd3, 3'd3, 3'd3, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I4( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I5( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I6( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I7( {3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I8( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I9( {3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I10({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I11({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
        .I12({3'd2, 3'd3, 3'd3, 3'd4, 3'd3, 3'd4, 3'd2, 3'd4, 3'd2, 3'd4, 3'd3, 3'd0, 3'd3, 3'd6, 3'd2, 3'd4}),
        .I13({3'd2, 3'd3, 3'd3, 3'd0, 3'd3, 3'd4, 3'd2, 3'd4, 3'd2, 3'd4, 3'd3, 3'd0, 3'd3, 3'd0, 3'd2, 3'd4}),
        .I14({3'd3, 3'd3, 3'd2, 3'd0, 3'd0, 3'd4, 3'd2, 3'd4, 3'd4, 3'd1, 3'd4, 3'd0, 3'd0, 3'd0, 3'd2, 3'd4}),
        .I15({3'd3, 3'd3, 3'd2, 3'd1, 3'd0, 3'd4, 3'd2, 3'd4, 3'd3, 3'd2, 3'd4, 3'd1, 3'd0, 3'd0, 3'd2, 3'd4}),
        .O(wClockIncrementRow)
    );

    MUXFULLPARALELL_4SEL_GENERIC #(3) MUX_CLOCK_STEP_2
    (
        .Sel(iOpcode[7:4]),
        .I0(  wClockIncrementRow[2:0]),
        .I1(  wClockIncrementRow[5:3]),
        .I2(  wClockIncrementRow[8:6]),
        .I3(  wClockIncrementRow[11:9]),
        .I4(  wClockIncrementRow[14:12]),
        .I5(  wClockIncrementRow[17:15]),
        .I6(  wClockIncrementRow[20:18]),
        .I7(  wClockIncrementRow[23:21]),
        .I8(  wClockIncrementRow[26:24]),
        .I9(  wClockIncrementRow[29:27]),
        .I10( wClockIncrementRow[32:30]),
        .I11( wClockIncrementRow[35:33]),
        .I12( wClockIncrementRow[38:36]),
        .I13( wClockIncrementRow[41:39]),
        .I14( wClockIncrementRow[44:42]),
        .I15( wClockIncrementRow[47:45]),
        .O(wClockIncrement)
    );
wire [7:0] wDiv;
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
