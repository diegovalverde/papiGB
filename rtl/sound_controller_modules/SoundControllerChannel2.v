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
// Sound module, channel 2. Squate waves with variable timer, frequency and envelope functions.
////////////////////////////////////////////////////////////////////////////////////


module SoundCtrlChannel2 //parameters
  (
    input wire		iClock,			//CPU CLOCK, 4194304Hz
    input wire		iReset,
    input wire [15:0]	iREG_SOUND2CNT_L,
    input wire [15:0]	iREG_SOUND2CNT_H,
    output reg [4:0]	oOut 
  );

	reg [5:0] rLength;
	reg [1:0] rDutyCycle;
	reg rEvelopeMode;
	reg [3:0] rInitialValue;

	reg [10:0] rSoundFrequency;
	reg rTimedMode;
	reg rSoundReset;


	reg rTone;
	reg [15:0] rFreqCounter;

	reg [3:0] rStep;
	reg [18:0] rStepTime;
	reg [18:0] rStepCounter;

 	reg [19:0] rLengthCounter;
 	reg rLengthComplete; 	//1 IF SOUND IS OFF BY TIMER, 0 IF SOUND IS ON BY TIMER

 	wire [4:0] up_value, down_value;

  	always @(posedge iClock) begin
		if (iReset || rSoundReset) begin
			//REGISTER LOAD

	  		rLength <= iREG_SOUND2CNT_L[5:0];
	  		rDutyCycle <= iREG_SOUND2CNT_L[7:6];
			rStepTime <= (65536*iREG_SOUND2CNT_L[10:8]);
			rEvelopeMode <= iREG_SOUND2CNT_L[11];
			rInitialValue <= iREG_SOUND2CNT_L[15:12];

	  		rSoundFrequency <= iREG_SOUND2CNT_H[10:0];
			rTimedMode <= iREG_SOUND2CNT_H[14];
			rSoundReset <= iREG_SOUND2CNT_H[15];						
					
			//TONE REGISTERS
			rFreqCounter <= (16*(2048-iREG_SOUND2CNT_H[10:0]));
			rTone <= 0;
		
			//STEP REGISTERS
			rStep <= iREG_SOUND2CNT_L[15:12];
			rStepCounter <= (65536*iREG_SOUND2CNT_L[10:8]);
		
			//LENGTH REGISTERS
	 		rLengthCounter <= (16384*iREG_SOUND2CNT_L[5:0]);
	 		rLengthComplete <= (iREG_SOUND2CNT_L[5:0]==0); //DISABLE CHANNEL IF LENGTH IS ZERO

		end

		else begin

			rEvelopeMode <= iREG_SOUND2CNT_L[11];
			rInitialValue <= iREG_SOUND2CNT_L[15:12];
			rSoundReset <= iREG_SOUND2CNT_H[15];

			//TONE GENERATOR
			if (rFreqCounter == 0 ) begin
				rTone <= ~rTone;
				rFreqCounter <=(16*(2048-rSoundFrequency));
			end
			else begin
				rFreqCounter <= rFreqCounter-1;
			end

			//STEP GENERATOR
			if (rStepTime != 0) begin
				if(rStepCounter == 0) begin
					if(rEvelopeMode) begin //ENVELOPE INCREASES
						rStep <= ((rStep == 4'hF) ? rStep : rStep+1); //INCREASES ONLY IF STEP IF LOWER THAN TOP VALUE
					end
					else begin //ENVELOPE DECREASES
						rStep <= ((rStep == 4'h0) ? rStep : rStep-1); //DECREASES ONLY IF STEP IF LOWER THAN BOTTOM VALUE
					end
					rStepCounter <= rStepTime;
				end
				else begin
					rStepCounter <= rStepCounter-1;	
				end
			end
			else begin
				rLengthComplete = 1'b1;
			end
	
			//LENGTH COUNTER
			if (rLengthCounter != 0) begin
				if(~rLengthComplete) begin
					rLengthCounter <= rLengthCounter-1;
				end
			end
			else begin // rLengthCounter == 0
				rLengthComplete <= rTimedMode; //0 FOR CONTINUOUS MODE, 1 FOR TIMED.
//				rStep <= rInitialValue;
				if (~rLengthComplete) begin	
					rLengthCounter <= (16384*rLength);
					rStepCounter <= rStepTime;					
				end
			end

			//RE-MAP UNIT
			if (rLengthComplete) begin
				oOut[4:0] <= 5'd15;
			end
			else begin
				if (rTone) begin
					oOut[4:0] <= up_value[4:0];
				end
				else begin
					oOut[4:0] <= down_value[4:0];
				end
			end

	  	end
	end

	assign up_value = 5'd15 + rStep;
	assign down_value = 5'd15 - rStep;
endmodule	
