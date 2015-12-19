`timescale 1ns / 1ps
`include "../rtl/aDefinitions.v"
`include "../rtl/z80_opcode_definitions.v"
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




module tb_simple_dzcpu;

	// Inputs
	reg iClock;
	reg iReset;

	// Instantiate the Unit Under Test (UUT)
	pGB uut (
		.iClock(iClock),
		.iReset(iReset)
	);



	//---------------------------------------------
	//generate the clock signal here
	always begin
		#`CLOCK_CYCLE  iClock =  ! iClock;

	end
	//---------------------------------------------

	integer log,i;

	initial begin
		// Initialize Inputs
		log = $fopen("pgb.log");
		$dumpfile("tb_simple_dzcpu.vcd");
		$dumpvars(0,tb_simple_dzcpu);
		$fwrite(log,"Simulation started at time %dns\n", $time);


		iClock = 0;
		iReset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		iReset = 1;
		#10
		iReset = 0;

		// Add stimulus here
		//#500
		#5000000

		for (i = 0; i <= (16'h9fff-16'h8000); i = i + 1)
		begin

			if (i % 16 == 0)
				$fwrite(log,"\n %h : ", (16'h8000 + i ));

			$fwrite(log,"%02h ",uut.MMU.rvMem[i]);
		end
		$fwrite(log,"Simulation ended at time %dns\n", $time);
		$fclose( log );

		$finish();
	end

	always @ ( posedge iClock )
	begin
		wait(iReset != 1);



		if ($time == 1638695)
			$finish();

		if (uut.DZCPU.rFlowEnable)
		begin
			$fwrite(log,"%05dns %d .",$time, uut.DZCPU.wuPc);
			case (uut.DZCPU.wuCmd)
				`nop: $fwrite(log,"nop \n");
				`sma: $fwrite(log,"sma %h\n", uut.DZCPU.oMCUAddr);
				`srm: $fwrite(log,"srm %h %h\n", uut.DZCPU.wUopSrc, uut.DZCPU.iMCUData);
				`smw: $fwrite(log,"smw %h %h\n", uut.DZCPU.oMCUAddr, uut.DZCPU.oMCUData);
				`z801bop:
				begin
					case (uut.DZCPU.iMCUData[7:3])
						5'b10100:	$fwrite(log,"%05dns a &= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );
						5'b10101:	$fwrite(log,"%05dns a ^= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );
					endcase
				end
				default:
					$fwrite(log,"unknow uop %d\n", uut.DZCPU.wuCmd);
			endcase
		end

		if (uut.DZCPU.wEof )
		begin
			$fwrite(log,"%04s %04s %02s %02s %02s %02s %02s %02s %02s\n", "PC", "SP", "B", "C", "D" ,"E", "H", "L", "A");
			$fwrite(log,"%04x %04x %02x %02x %02x %02x %02x %02x %02x\n", uut.DZCPU.wPc, {uut.DZCPU.wSpH,uut.DZCPU.wSpL}, uut.DZCPU.wB, uut.DZCPU.wC, uut.DZCPU.wD, uut.DZCPU.wE ,uut.DZCPU.wH, uut.DZCPU.wL, uut.DZCPU.wA);
			$fwrite(log,"\n\n\n");
		end
	end

endmodule

