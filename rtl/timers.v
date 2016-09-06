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

`define TIMER_AFTER_RESET   0
`define TIMER_WAIT_FOR_TICK 1
`define TIMER_INC           2
`define TIMER_INC_BTAKEN    3
`define TIMER_INC_BTAKEN_NOT_EOF 4
`define TIMER_WAIT_EOF           5

`define DIV_OF_WAIT 0
`define DIV_OF_INC  1


module timers
(
 input wire iClock,
 input wire iReset,
 input wire [7:0] iOpcode,
 input wire iEof,
 input wire iBranchTaken,
 input wire iInterrupt,

 input wire        iMcuWe,
 input wire [3:0]  iMcuRegSelect, //control register select comes from cpu
 input wire [7:0]  iMcuWriteData, //what does the cpu want to write


 output wire [7:0] oDiv,         //0xFF04
 output wire [7:0] oTima,        //0xFF05
 output wire [7:0] oModulo,      //0xFF06
 output wire [7:0] oTac,         //0xFF07




 output wire oInterrupt0x50

);


wire [7:0] wMcuRegWriteSelect;
assign wMcuRegWriteSelect = (1 << iMcuRegSelect);


////////////////////////////////////////////////
//
// Register 0xFF04:  Divider  Counts up at a fixed 16384Hz;
// reset to 0 whenever written to
//
////////////////////////////////////////////////

 UPCOUNTER_POSEDGE # (8) DIV
(
.Clock(iClock),
.Reset(iReset),
.Initial(8'd211),
.Enable( rIncDiv ),
.Q( oDiv )
);


////////////////////////////////////////////////
//
// Register 0xFF05: Counter (Tima)  Counts up at the specified rate
// Triggers INT 0x50 when going 255->0
//
////////////////////////////////////////////////
reg       rIncTima;             //Set to indicate Tima is to be incremented by 1
assign    oInterrupt0x50 = ( oTima == 8'd255 && rIncTima ) ? 1'b1 : 1'b0;
wire [7:0] wTimaInitialvalue;
assign wTimaInitialvalue = (iReset) ? 8'b0 : oModulo ;


 UPCOUNTER_POSEDGE # (8) TIMA
(
.Clock(    iClock                   ),
.Reset(    iReset | oInterrupt0x50  ),
.Initial(  wTimaInitialvalue        ),
.Enable(   rIncTima                 ),
.Q(        oTima                    )
);


////////////////////////////////////////////////
//
// Register 0xFF06:  Modulo  When Tima overflows to 0,
// it's reset to start at Modulo
//
////////////////////////////////////////////////

reg [7:0] rModulo;
assign oModulo = rModulo;

////////////////////////////////////////////////
///
///  Register 0xFF07: Timer control (rTac)
//   Bits  Function  Details
//   0-1  Speed      00: 4096Hz
//                  01: 262144Hz
//                  10: 65536Hz
//                  11: 16384Hz
//   2    Running    1 to run timer, 0 to stop
//   3-7  Unused
///////////////////////////////////////////////
wire [7:0] wSpeed;


FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 )FF_TAC
( iClock, iReset,iMcuWe & wMcuRegWriteSelect[7] , iMcuWriteData, oTac );



MUXFULLPARALELL_2SEL_GENERIC # ( 8 ) MUX_SPEED
 (
 .Sel( oTac[1:0] ),
 .I0(  8'd1024   ),
 .I1(  8'd16     ),
 .I2(  8'd64     ),
 .I3(  8'd256    ),
 .O(   wSpeed    )
 );


wire wBaseClock, wIsCb,  wDivOverflow;
reg  rIsBranch, rIncDiv;
wire wBaseClockDivider[7:0];




    wire [47:0] wClockIncrementRow, wClockIncrementRowCB;
    wire [47:0] wClockIncrementRowBasic,wClockIncrementRowBranch,wClockIncrementRow_Pre, wClockIncrementRow_Pre_Pre;
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

    always @ (*)
    begin
      case (iOpcode)
        8'h20,8'h28,8'h30,8'h38,8'hc0,8'hc2,8'hc4,8'hc8,
        8'hca,8'hcc,8'hd0,8'hd2,8'hd4,8'hd8,8'hda,8'hdc:
          rIsBranch = 1'b1;
        default:
          rIsBranch = 1'b0;
      endcase
    end


    assign wIsCb = (iOpcode == 8'hCB) ? 1'b1 : 1'b0;
    assign wClockIncrementRow_Pre = (rTimerSel == 1'b1) ? wClockIncrementRowBranch : wClockIncrementRowBasic;
    assign wClockIncrementRow = (wIsCb) ? wClockIncrementRowCB : wClockIncrementRow_Pre;



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

MUXFULLPARALELL_4SEL_GENERIC #(48) MUX_CLOCK_STEP_1_BRANCHES
(
    .Sel(iOpcode[7:4]),
    .I0({3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd5, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I1({3'd1, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd3, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I2({3'd3, 3'd3, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1, 3'd3, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I3({3'd3, 3'd3, 3'd2, 3'd2, 3'd3, 3'd3, 3'd3, 3'd1, 3'd3, 3'd2, 3'd2, 3'd2, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I4({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I5({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I6({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I7({3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I8({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I9({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I10({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I11({3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd2, 3'd1}),
    .I12({3'd5, 3'd3, 3'd4, 3'd4, 3'd6, 3'd4, 3'd2, 3'd4, 3'd5, 3'd4, 3'd4, 3'd0, 3'd6, 3'd6, 3'd2, 3'd4}),
    .I13({3'd5, 3'd3, 3'd4, 3'd0, 3'd6, 3'd4, 3'd2, 3'd4, 3'd5, 3'd4, 3'd4, 3'd0, 3'd6, 3'd0, 3'd2, 3'd4}),
    .I14({3'd3, 3'd3, 3'd2, 3'd0, 3'd0, 3'd4, 3'd2, 3'd4, 3'd4, 3'd1, 3'd4, 3'd0, 3'd0, 3'd0, 3'd2, 3'd4}),
    .I15({3'd3, 3'd3, 3'd2, 3'd1, 3'd0, 3'd4, 3'd2, 3'd4, 3'd3, 3'd2, 3'd4, 3'd1, 3'd0, 3'd0, 3'd2, 3'd4}),
    .O(wClockIncrementRowBranch)

);


wire[7:0] wDelta;
assign wDelta = (iInterrupt) ? wClockIncrement + 8'd20 : wClockIncrement;

wire [7:0] wDiv,wTima;
assign wTima =  8'b0;  //TODO Fix this!
reg rTimerSel, rIncTimer;

assign {wDivOverflow,wDiv} = (rMTime << 2);

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
        if (rIncTimer )
          {rIncrementBTime,rMTime} = rMTime + {4'b0,wDelta[3:0]};


      end
   end //always


   //--------------------------------------------------------
   // Current State Logic //
   reg [7:0]    rCurrentState,rNextState;

   always @(posedge iClock )
   begin
        if( iReset!=1 )
           rCurrentState <= rNextState;
      else
           rCurrentState <= `TIMER_AFTER_RESET;
   end
   //--------------------------------------------------------

   always @( * )
    begin
     case (rCurrentState)
     //----------------------------------------
     `TIMER_AFTER_RESET:
     begin
       rTimerSel   = 1'b0;
       rIncTimer   = 1'b0;

       rNextState = `TIMER_WAIT_FOR_TICK;
     end
     //----------------------------------------
     `TIMER_WAIT_FOR_TICK:
     begin
     rTimerSel   = 1'b0;
     rIncTimer   = 1'b0;

      if ( iInterrupt )
          rNextState = `TIMER_INC_BTAKEN;
      else if (rIsBranch & iBranchTaken & iEof)
          rNextState = `TIMER_INC_BTAKEN;
      else if (rIsBranch & iBranchTaken & ~iEof)
          rNextState = `TIMER_INC_BTAKEN_NOT_EOF;
      else if (iEof)
          rNextState = `TIMER_INC;
      else
          rNextState = `TIMER_WAIT_FOR_TICK;
     end
     //----------------------------------------
     `TIMER_INC:
     begin
        rTimerSel   = 1'b0;
        rIncTimer   = 1'b1;

       rNextState = `TIMER_WAIT_FOR_TICK;
     end
     //----------------------------------------
     `TIMER_INC_BTAKEN:
     begin
        rTimerSel   = 1'b1;
        rIncTimer   = 1'b1;

      if (~iInterrupt)
        rNextState = `TIMER_WAIT_FOR_TICK;
      else
        rNextState = `TIMER_WAIT_EOF;
     end
     //----------------------------------------
   `TIMER_INC_BTAKEN_NOT_EOF:
     begin
        rTimerSel   = 1'b1;
        rIncTimer   = 1'b1;

        if (iEof)
          rNextState = `TIMER_WAIT_FOR_TICK;
        else
          rNextState = `TIMER_WAIT_EOF;

     end
     //----------------------------------------
     `TIMER_WAIT_EOF:
     begin
        rTimerSel   = 1'b1;
        rIncTimer   = 1'b0;

        if (iEof)
            rNextState = `TIMER_WAIT_FOR_TICK;
        else
            rNextState = `TIMER_WAIT_EOF;
     end
     //----------------------------------------
     default:
     begin
         rTimerSel   = 1'b0;
         rIncTimer   = 1'b0;

         rNextState = `TIMER_AFTER_RESET;
     end
     //----------------------------------------
     endcase
  end //always


//--------------------------------------------------------
// Current State Logic //
reg [2:0]    rCurrentState_Of,rNextState_Of;

always @(posedge iClock )
begin
     if( iReset!=1 )
        rCurrentState_Of <= rNextState_Of;
   else
        rCurrentState_Of <= `TIMER_AFTER_RESET;
end
//--------------------------------------------------------

always @( * )
 begin
  case (rCurrentState_Of)
  //----------------------------------------
  `DIV_OF_WAIT:
  begin

    rIncDiv   = 1'b0;

    if (wDiv[7])
        rNextState_Of = `DIV_OF_INC;
    else
        rNextState_Of = `DIV_OF_WAIT;

  end
  //----------------------------------------
  `DIV_OF_INC:
  begin
      rIncDiv   = ~wDiv[7];

      if (~wDiv[7])
        rNextState_Of = `DIV_OF_WAIT;
      else
        rNextState_Of = `DIV_OF_INC;
  end
  //---------------------------------------
  default:
  begin
      rIncDiv   = 1'b0;

      rNextState_Of = `DIV_OF_WAIT;
  end
  //--------------------------------------
  endcase
end //always

endmodule
