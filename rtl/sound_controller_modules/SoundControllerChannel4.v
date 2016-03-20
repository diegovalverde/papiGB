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
// Sound module, channel 4. White noise generation module using LFSR.
////////////////////////////////////////////////////////////////////////////////////


module SoundCtrlChannel4 //parameters
  (
    input wire        iClock,
    input wire        iReset,
    output	      oOut 
  );
  
  wire wS0S1, wS1S2, wS2S3, wS3S4, wS4S5, wS5S6, wS6S7;
  wire wClockDiv;
  wire [2:0] wClockDivFull;


  UPCOUNTER_POSEDGE # ( 3 ) UC_CH4_0 (
    .Clock(iClock),
    .Reset(iReset),
    .Initial(3'd6),
    .Enable(1),
    .Q(wClockDivFull)
  );

  assign  wClockDiv = wClockDivFull[2];


  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_0 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(oOut ^ wS6S7),
    .Q(wS0S1)
  );
  
  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_1 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),    
    .D(wS0S1),
    .Q(wS1S2)
  );

  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_2 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),    
    .D(wS1S2),
    .Q(wS2S3)
  );


  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_3 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(wS2S3),
    .Q(wS3S4)
  );

  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_4 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(wS3S4),
    .Q(wS4S5)
  );

  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_5 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(wS4S5),
    .Q(wS5S6)
  );

  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_6 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(wS5S6),
    .Q(wS6S7)
  );
  
  FFD_POSEDGE_SYNCRONOUS_RESET_INIT # ( 1 ) FF_CH4_7 (
    .Clock(wClockDiv),
    .Reset(iReset),
    .Enable(1),
    .iInitial(1),
    .D(wS6S7),
    .Q(oOut)
  );  
  
endmodule
