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

	integer log,i,Pc, vram_log;
	reg rSimulationDone;


//-----------------------------------------------------------------
	always @ (posedge iClock)
	begin
		wait(iReset != 1);


		if (rSimulationDone == 1'b1)
		begin
			vram_log = $fopen("papi_vram_8000_8fff.dump");
			$display("Stopping Simulation and dumping memory");
			$fwrite(log,"\n\n=== PAGEZERO MEMORY ===\n\n");
			for (i = 16'hff80; i <= 16'hffff; i = i + 1)
			begin
				if (i % 16 == 0)
					$fwrite(log,"\n %h : ", i );

				$fwrite(log,"%02h ",uut.MMU.ZERO_PAGE.Ram[i-16'hff80]);
			end

			//Dump the VMEM
			$fwrite(log,"\n\n=== VIDEO MEMORY ===\n\n");
			for (i = 16'h8000; i <= 16'h9fff; i = i + 1)
			begin

				if (i % 16 == 0)
				begin
					$fwrite(log,"\n %h : ", i );
					if ( i <= 16'h8fff)
						$fwrite(vram_log,"\n %h : ", i );
				end

				$fwrite(log,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);
				if ( i <= 16'h8fff)
					$fwrite(vram_log,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);
			end
			$fwrite(log,"Simulation ended at time %dns\n", $time);
			$fclose( log );
			$fclose( vram_log );
			$finish();
		end

	end
//-----------------------------------------------------------------
	initial begin
		// Initialize Inputs
		log = $fopen("pgb.log");
		$dumpfile("tb_simple_dzcpu.vcd");
		$dumpvars(0,tb_simple_dzcpu);
		$fwrite(log,"Simulation started at time %dns\n", $time);

		rSimulationDone = 0;
		iClock = 0;
		iReset = 0;

		//Add dummy game cartrige header
		uut.MMU.rCartridgeBank0[16'h100] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h101] = 8'hc3;
		uut.MMU.rCartridgeBank0[16'h102] = 8'h50;
		uut.MMU.rCartridgeBank0[16'h103] = 8'h01;
		uut.MMU.rCartridgeBank0[16'h104] = 8'hce;	//Start of LOGO
		uut.MMU.rCartridgeBank0[16'h105] = 8'hed;
		uut.MMU.rCartridgeBank0[16'h106] = 8'h66;
		uut.MMU.rCartridgeBank0[16'h107] = 8'h66;
		uut.MMU.rCartridgeBank0[16'h108] = 8'hcc;
		uut.MMU.rCartridgeBank0[16'h109] = 8'h0d;
		uut.MMU.rCartridgeBank0[16'h10a] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h10b] = 8'h0b;
		uut.MMU.rCartridgeBank0[16'h10c] = 8'h03;
		uut.MMU.rCartridgeBank0[16'h10d] = 8'h73;
		uut.MMU.rCartridgeBank0[16'h10e] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h10f] = 8'h83;

		uut.MMU.rCartridgeBank0[16'h110] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h111] = 8'h0c;
		uut.MMU.rCartridgeBank0[16'h112] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h113] = 8'h0d;
		uut.MMU.rCartridgeBank0[16'h114] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h115] = 8'h08;
		uut.MMU.rCartridgeBank0[16'h116] = 8'h11;
		uut.MMU.rCartridgeBank0[16'h117] = 8'h1f;
		uut.MMU.rCartridgeBank0[16'h118] = 8'h88;
		uut.MMU.rCartridgeBank0[16'h119] = 8'h89;
		uut.MMU.rCartridgeBank0[16'h11A] = 8'h00;
		uut.MMU.rCartridgeBank0[16'h11B] = 8'h0E;
		uut.MMU.rCartridgeBank0[16'h11C] = 8'hDC;
		uut.MMU.rCartridgeBank0[16'h11D] = 8'hCC;
		uut.MMU.rCartridgeBank0[16'h11E] = 8'h6E;
		uut.MMU.rCartridgeBank0[16'h11F] = 8'hE6;

		uut.MMU.rCartridgeBank0[16'h120] = 8'hdd;
		uut.MMU.rCartridgeBank0[16'h121] = 8'hdd;
		uut.MMU.rCartridgeBank0[16'h122] = 8'hd9;
		uut.MMU.rCartridgeBank0[16'h123] = 8'h99;
		uut.MMU.rCartridgeBank0[16'h124] = 8'hbb;
		uut.MMU.rCartridgeBank0[16'h125] = 8'hbb;
		uut.MMU.rCartridgeBank0[16'h126] = 8'h67;
		uut.MMU.rCartridgeBank0[16'h127] = 8'h63;

		uut.MMU.rCartridgeBank0[16'h128] = 8'h6e;
		uut.MMU.rCartridgeBank0[16'h129] = 8'h0e;
		uut.MMU.rCartridgeBank0[16'h12A] = 8'hec;
		uut.MMU.rCartridgeBank0[16'h12B] = 8'hcc;
		uut.MMU.rCartridgeBank0[16'h12C] = 8'hdd;
		uut.MMU.rCartridgeBank0[16'h12D] = 8'hdc;
		uut.MMU.rCartridgeBank0[16'h12E] = 8'h99;
		uut.MMU.rCartridgeBank0[16'h12F] = 8'h9f;

		uut.MMU.rCartridgeBank0[16'h130] = 8'hbb;
		uut.MMU.rCartridgeBank0[16'h131] = 8'hb9;
		uut.MMU.rCartridgeBank0[16'h132] = 8'h33;
		uut.MMU.rCartridgeBank0[16'h133] = 8'h3e;
		uut.MMU.rCartridgeBank0[16'h134] = 8'h54;
		uut.MMU.rCartridgeBank0[16'h135] = 8'h45;
		uut.MMU.rCartridgeBank0[16'h136] = 8'h54;
		uut.MMU.rCartridgeBank0[16'h137] = 8'h52;


		// Wait 100 ns for global reset to finish
		#100;
		iReset = 1;
		#10
		iReset = 0;

		// Add stimulus here
		//#500
		#5000000
		$fwrite(log, "Simulation reached MAX time %hns",$time);
		rSimulationDone = 1;
	end

	always @ ( posedge iClock )
	begin
		wait(iReset != 1);

		if (uut.DZCPU.wPc == 16'h04a)	//This instructrion finishes copying the little (R)
			rSimulationDone = 1;


//	  if ($time == 1699905)
//	  begin
//	  	$display("reached MAX stable time!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//			rSimulationDone = 1;
//      end

		if (uut.DZCPU.rCurrentState == `DZCPU_START_FLOW)
		begin
			Pc = uut.DZCPU.wPc;
			case (uut.DZCPU.wuOpFlowIdx)
			1: $fwrite(log,"=== LDSPnn === \n");
			5: $fwrite(log,"=== LDHLnn === \n");
			9: $fwrite(log,"=== LDHLDA === \n");
			13:  $fwrite(log,"=== MAPcb === \n");
			17:  $fwrite(log,"=== JRNZn === \n");
			23: $fwrite(log,"=== LDrn_c === \n");
			26: $fwrite(log,"=== LDrn_a === \n");
			29: $fwrite(log,"=== LDIOCA === \n");
			32: $fwrite(log,"=== INCr_c === \n");
			33: $fwrite(log,"=== LDHLmr_a === \n");
			36: $fwrite(log,"=== LDIOnA  === \n");
			43: $fwrite(log,"=== LDDEnn  === \n");
			47: $fwrite(log,"=== LDADEm  === \n");
			50: $fwrite(log,"=== CALLnn ===\n");
			60: $fwrite(log,"=== LDrn_b ===\n");
			63: $fwrite(log,"=== PUSHBC ===\n");
			70: $fwrite(log,"=== RLA ===\n");
			71: $fwrite(log,"=== POPBC ===\n");
			77:$fwrite(log,"=== DECr_b ===\n");
			78: $fwrite(log,"=== LDHLIA ===\n");
			82: $fwrite(log,"=== INCHL ===\n");
			83: $fwrite(log,"=== RET ===\n");
			89: $fwrite(log,"=== INCDE ===\n");
			90: $fwrite(log,"=== CPn ===\n");
			default:
				$fwrite(log,"=== Unknown Flow. Insns %h\n",uut.DZCPU.iMCUData);
			endcase
		end

		if (uut.DZCPU.rFlowEnable)
		begin
			$fwrite(log,"%05dns [DZCPU] %d  .",$time, uut.DZCPU.wuPc);
			case (uut.DZCPU.wuCmd)
				`nop: $fwrite(log,"nop \n");
				`sma: $fwrite(log,"sma %h\n", uut.DZCPU.oMCUAddr);
				`srm: $fwrite(log,"srm %h %h\n", uut.DZCPU.wUopSrc, uut.DZCPU.iMCUData);
				`jcb: $fwrite(log,"jcb %h \n", uut.DZCPU.iMCUData);
				`smw: $fwrite(log,"smw %h %h\n", uut.DZCPU.oMCUAddr, uut.DZCPU.oMCUData);
				`bit: $fwrite(log,"bit %h & %b\n", uut.DZCPU.wRegData, uut.DZCPU.wBitMask);
				`addx16:$fwrite(log,"addx16 %h += %h\n", uut.DZCPU.wX16, uut.DZCPU.wRegData);
				`spc: $fwrite(log,"spc %h\n", uut.DZCPU.wRegData);
				`sx16r: $fwrite(log,"sx16r %h\n", uut.DZCPU.wRegData);
				`sx8r: $fwrite(log,"sx8r %h\n", uut.DZCPU.wRegData);
				`inc16:$fwrite(log,"inc16 %h\n", uut.DZCPU.wRegData);
				`dec16: $fwrite(log,"dec16 %h\n", uut.DZCPU.wRegData);
				`srx8:$fwrite(log,"srx8 %h\n", uut.DZCPU.wRegData);
				`shl: $fwrite(log,"shl %h << 1 + %h\n", uut.DZCPU.wRegData, uut.DZCPU.wFlags[`flag_c] );
				`subx16: $fwrite(log,"subx16 %h -= %h\n", uut.DZCPU.wX16, uut.DZCPU.wRegData);

				`z801bop:
				begin
					case (uut.DZCPU.iMCUData[7:3])
						5'b10100:	$fwrite(log,"%05dns a &= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );
						5'b10101:	$fwrite(log,"%05dns a ^= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );

					endcase
				end
				default:
				begin
					$fwrite(log,"unknow uop %d\n", uut.DZCPU.wuCmd);
					rSimulationDone = 1;
				end
			endcase
		end

		if (uut.MMU.iWe)
		begin
			$fwrite(log,"%05dns [MMU] ", $time);

			if (uut.MMU.iAddr >= 16'hff00 && uut.MMU.iAddr <= 16'hff7f )
				$fwrite(log," [IO] ");

			if (uut.MMU.iAddr >= 16'hff10 && uut.MMU.iAddr <= 16'hff23 )
				$fwrite(log," [SOUND] ");

			if (uut.MMU.iAddr >= 16'hff40 && uut.MMU.iAddr <= 16'hff4B )
				$fwrite(log," [LCD] ");

			if (uut.MMU.iAddr >= 16'hff80 && uut.MMU.iAddr <= 16'hffff )
				$fwrite(log," [PAGEZERO] ");

			if (uut.MMU.iAddr >= 16'h8000 && uut.MMU.iAddr <= 16'h87ff )
				$fwrite(log," [VMEM Tiles 0] ");

			if (uut.MMU.iAddr >= 16'h8800 && uut.MMU.iAddr <= 16'h8fff )
				$fwrite(log," [VMEM Tiles 1] ");


			 $fwrite(log,"Writting %h @ %h\n", uut.MMU.iData,uut.MMU.iAddr);
		end


		if (uut.DZCPU.wEof )
		begin
			$fwrite(log,"\n          %04s %04s %02s %02s %02s %02s %02s %02s %02s %02s\n", "PC", "SP", "B", "C", "D" ,"E", "H", "L", "A", "Flags");
			$fwrite(log,"[regs] %04x %04x %02x %02x %02x %02x %02x %02x %02x %b\n", Pc, {uut.DZCPU.wSpH,uut.DZCPU.wSpL}, uut.DZCPU.wB, uut.DZCPU.wC, uut.DZCPU.wD, uut.DZCPU.wE ,uut.DZCPU.wH, uut.DZCPU.wL, uut.DZCPU.wA, uut.DZCPU.wFlags);
			$fwrite(log,"\n\n\n");
		end
	end

endmodule

