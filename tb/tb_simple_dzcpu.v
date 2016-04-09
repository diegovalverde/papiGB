`timescale 1ns / 1ps
`include "../rtl/aDefinitions.v"
`include "../rtl/gpu_definitions.v"
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
  reg rResetDone;
	wire [15:0] wFramBufferData, wFrameBufferAddress;
	wire wFramBufferWe;
	reg [15:0] rCurrentTileRow;

	// Instantiate the Unit Under Test (UUT)
	pGB uut (
		.iClock(iClock),
		.iReset(iReset),
		.oFrameBufferWe( wFramBufferWe ),
		.oFrameBufferData( wFramBufferData ),
		.oFrameBufferAddr( wFrameBufferAddress )

	);


//Instantiate a dummy frame buffer. In real life this goes in the LCD board

reg [15:0] rFrameBuffer[8191:0];
integer log, glog, i,Pc, vram_log_8000_8fff, vram_log_9800_9bff;
integer frame_count = 0, k, frame;
reg rSimulationDone;


	//---------------------------------------------
	//generate the clock signal here
	always begin
		#`CLOCK_CYCLE  iClock =  ! iClock;

	end
	//---------------------------------------------
  //Update writes to the framebuffer
  always @ ( posedge iClock )
	begin

  		if ( wFramBufferWe )
			begin
				 rFrameBuffer[ wFrameBufferAddress ] = wFramBufferData;

			end
end //always

  reg [255:1] FrameDumpName;
	integer FrameDumpCount = 0;

  always @ ( posedge iClock )
	begin


			if ( wFrameBufferAddress == 16'd8191 && wFramBufferWe == 1'b1)//8191
			begin

			    $swrite(FrameDumpName,"generated_frames/frame.%01d.ppm",FrameDumpCount);
					frame = $fopen(FrameDumpName);
					$fwrite(frame,"P2\n");
					$fwrite(frame,"256 256\n");
					$fwrite(frame,"4\n");

					$fwrite(frame,"#SCY %04x SCX %04x LY %04x wSC_Tile %04x\n",
					uut.GPU.oSCY,     uut.GPU.oSCX,   			uut.GPU.oLY, uut.GPU.wSC_Tile);

					for (k = 0; k < 8191; k=k+1)
					begin
					  rCurrentTileRow = rFrameBuffer[k];

						$fwrite(frame, "%01x %01x %01x %01x %01x %01x %01x %01x  ",
						rCurrentTileRow[15:14],
						rCurrentTileRow[13:12],
						rCurrentTileRow[11:10],
						rCurrentTileRow[9:8],
						rCurrentTileRow[7:6],
						rCurrentTileRow[5:4],
						rCurrentTileRow[3:2],
						rCurrentTileRow[1:0]);

						if ((k+1) % 32 == 0)
								$fwrite(frame,"\n#%d\n",k/32);


					end

					$fclose(frame);
					FrameDumpCount = FrameDumpCount + 1;

					`ifdef STOP_AFTER_FIRST_FRAME
							$fwrite(log,"**** First fram complete. Stopping Simulation **** \n");
				  		rSimulationDone = 1;
					`endif
			end
  end



//-----------------------------------------------------------------
	always @ (posedge iClock)
	begin
		wait(iReset != 1);


		if (rSimulationDone == 1'b1)
		begin
			vram_log_8000_8fff = $fopen("papi_vram_8000_8fff.dump");
			vram_log_9800_9bff = $fopen("papi_vram_9800_9bff.dump");

			$display("Stopping Simulation and dumping memory");

			$fwrite(log, "=== WORK MEMORY C000 - DFFFF ===\n");
			$fwrite(log,"%02x: ",16'hc000);
			for (i = 0; i <  (16'hdfff-16'hc000); i = i + 1)
			begin
					$fwrite(log,"%02x ", uut.MMU.WORK_RAM.Ram[i]);
					if ((i+1) % 16 == 0)
							$fwrite(log,"\n %h: ", (16'hc000+i+1));

			end

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
						$fwrite(vram_log_8000_8fff,"\n %h : ", i );

					if ( i >= 16'h9800 && i <= 16'h9bff)
						$fwrite(vram_log_9800_9bff,"\n %h : ", i );
				end

				$fwrite(log,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);
				if ( i <= 16'h8fff)
					$fwrite(vram_log_8000_8fff,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);

				if ( i >= 16'h9800 && i <= 16'h9bff)
					$fwrite(vram_log_9800_9bff,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);
			end

      $fwrite(log,"\n\nTEST_RET_VAL %04h\n\n", {uut.MMU.ZERO_PAGE.Ram[ 16'hfffd - 16'hff80 ],uut.MMU.ZERO_PAGE.Ram[ 16'hfffc - 16'hff80 ]} );

			$fwrite(log,"Simulation ended at time %dns\n", $time);

`ifdef ENABLE_CPU_LOG
			$fclose( log );
`endif

`ifdef ENABLE_GPU_LOG
			$fclose( glog );
`endif
			$fclose( vram_log_8000_8fff );
			$fclose( vram_log_9800_9bff );
			$finish();
		end

	end
//-----------------------------------------------------------------
	initial begin
		// Initialize Inputs

`ifdef ENABLE_CPU_LOG
		log = $fopen("pgb_cpu.log");
`endif

`ifdef ENABLE_GPU_LOG
		glog = $fopen("pgb_gpu.log");
`endif


`ifdef VMEM_DUMP_PATH
$readmemh(
	`VMEM_DUMP_PATH, uut.MMU.VMEM.Ram);

			$fwrite(glog,"\n\n=== VIDEO MEMORY FROM FILE: %s===\n\n", `VMEM_DUMP_PATH);
			for (i = 16'h8000; i <= 16'h9fff; i = i + 1)
			begin
				if (i % 16 == 0)
						$fwrite(glog,"\n %h : ", i );
				$fwrite(glog,"%02h ",uut.MMU.VMEM.Ram[i- 16'h8000]);
			end


`endif



`ifdef OAM_DUMP_PATH
  $readmemh(
	`OAM_DUMP_PATH, uut.MMU.OAM.Ram);

	$fwrite(glog,"\n\n=== OAM MEMORY FROM FILE: %s===\n\n", `OAM_DUMP_PATH);
	for (i = 16'hfe00; i <= 16'hfe9f; i = i + 1)
	begin
		if (i % 16 == 0)
				$fwrite(glog,"\n %h : ", i );
		$fwrite(glog,"%02h ",uut.MMU.OAM.Ram[i- 16'hfe00]);
	end

	$fwrite(glog,"\n\n");

`endif
		rResetDone = 1'b0;
		$dumpfile("tb_simple_dzcpu.vcd");
		$dumpvars(0,tb_simple_dzcpu);
		$fwrite(log,"Simulation started at time %dns\n", $time);

		rSimulationDone = 0;
		iClock = 0;
		iReset = 0;



		// Wait 100 ns for global reset to finish
		#100;
		iReset = 1;
		#10
		iReset = 0;


		`ifdef DISABLE_CPU
		  //Force GPU to start
			`ifdef FORCE_LCDC
				uut.GPU.FF_LCDC.Q = `FORCE_LCDC;
			`else
				//uut.GPU.FF_LCDC.Q = 8'b10010000;//tetris
				uut.GPU.FF_LCDC.Q = 8'b10000000;//zelda
			`endif
			uut.GPU.FF_SCX.Q = 8'h0;
			uut.GPU.FF_SCY.Q = 8'h0;
			uut.GPU.FF_LY.Q = 8'h0;
			uut.GPU.FFS_BGP.Q = 8'h27;
			uut.GPU.FFS_OBP0.Q = 8'he4;
			uut.GPU.FFS_OBP1.Q = 8'hc4;
		`endif

		// Add stimulus here
		//#500
		#1000
		rResetDone = 1'b1;
		//#5000000

	`ifdef SIMULATION_TIME_OUT
 		#`SIMULATION_TIME_OUT
 `else
		#500000000
	`endif

		$fwrite(log, "Simulation reached MAX time %hns",$time);
		rSimulationDone = 1;
	end


integer row_count=0;

`ifdef ENABLE_GPU_LOG
always @ ( posedge iClock )
begin


	 if (uut.GPU.wGpuActive)
	 begin
	 			$fwrite(glog,"%05dns [GPU] IP:%d  %h .",$time, uut.GPU.wIp, uut.GPU.wUop[`GPU_OP_RNG] );
	 case (uut.GPU.wUop[`GPU_OP_RNG])
			 	`gnop: $fwrite(glog, "nop  \n");
				`gwrl: $fwrite(glog, "gwrl r[%h] = %h\n",uut.GPU.wUop[`GPU_DST_RNG],uut.GPU.wUop[`GPU_LIT_RNG]);
				`gwrr: $fwrite(glog, "gwrr \n");
				`gadd: $fwrite(glog, "gadd %h + %h = %h\n", uut.GPU.wOp1, uut.GPU.wOp0, uut.GPU.rResult);
				`gsub: $fwrite(glog, "gsub %h - %h = %h\n",uut.GPU.wOp1, uut.GPU.wOp0, uut.GPU.rResult);
				`gaddl: $fwrite(glog, "gaddl %h += %h = %h\n", uut.GPU.wOp1, uut.GPU.wUop[`GPU_LIT_RNG], uut.GPU.rResult );
				`gjnz: $fwrite(glog, "gjnz \n");
				`gwfbuffer: $fwrite(glog, "gwfbuffer \n");
				`gsubl: $fwrite(glog, "gsubl %h -= %h = %h\n", uut.GPU.wOp1, uut.GPU.wUop[`GPU_LIT_RNG], uut.GPU.rResult);
				`grvmem: $fwrite(glog,"grvmem @ %h\n", uut.GPU.oMcuAddr);
				`gshl:   $fwrite(glog,"gshl  \n");
				`gand: $fwrite(glog, "gand %h & %h = %h\n", uut.GPU.wOp1, uut.GPU.wOp0, uut.GPU.rResult);
				`gjz: $fwrite(glog, "gjz \n");
				`gsprtt: $fwrite(glog, " >>> gsprtt tile_row: %d tile_idx: %d sprite [%d , %d] , tile [%d %d ] = %h\n",
													uut.GPU.wCurrentTileRow/2, uut.GPU.wCurrentTile,
				                  uut.GPU.wSpriteCoordX, uut.GPU.wSpriteCoordY,
													uut.GPU.wTileCoordX, uut.GPU.wTileCoordY, uut.GPU.wIsSpriteInCurrentTile);
		endcase

			//Print the Registers
			$fwrite(glog,"\n     %05s  %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s\n",
			"Ip",   "oAddr", "iData", "STAT",
			"LCDC", "SCY",   "SCX" ,  "LY",
			"LYC",  "DMA",   "BGP",   "BP0",
			"BP1",  "WY", "WX");
			$fwrite(glog,"[regs] %04d %04x  %02x     %02x    %02x     %02x    %02x     %02x   %02x    %02x    %02x    %02x    %02x     %02x    %02x\n",
			uut.GPU.wIp,    uut.GPU.oMcuAddr, uut.GPU.iMcuReadData, uut.GPU.oSTAT,
			uut.GPU.oLCDC,  uut.GPU.oSCY,     uut.GPU.oSCX,   			uut.GPU.oLY,
			uut.GPU.oLYC,   uut.GPU.oDMA,     uut.GPU.oBGP,         uut.GPU.oOBP0,
			uut.GPU.oOBP1, 	uut.GPU.oWY,      uut.GPU.oWX );

			$fwrite(glog, "%04s %04s %04s %04s %06s %10s %10s %10s %10s %10s %10s\n", "Sh", "Sl","Bh", "Bl", "Bsel", "cur_tile", "tile_row", "fb_addr", "vmem_data", "sprite_x", "sprite_y");
			$fwrite(glog, "0x%02x 0x%02x 0x%02x 0x%02x 0x%04x 0x%08x 0x%08x 0d%08d 0x%08x 0d%08d %08d\n",
			uut.GPU.wSh, uut.GPU.wSl,uut.GPU.wBh, uut.GPU.wBl, uut.GPU.wR2, uut.GPU.wCurrentTile, uut.GPU.wCurrentTileRow, wFrameBufferAddress, uut.GPU.iMcuReadData, uut.GPU.wSpriteCoordX, uut.GPU.wSpriteCoordY);

			$fwrite(glog, "\nBackground Tile Pixel Row:\n");
			$fwrite(glog, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
			uut.GPU.wBgPixel7,uut.GPU.wBgPixel6,uut.GPU.wBgPixel5,uut.GPU.wBgPixel4,uut.GPU.wBgPixel3,uut.GPU.wBgPixel2,uut.GPU.wBgPixel1,uut.GPU.wBgPixel0);

			$fwrite(glog, "\nSprite Tile Pixel Row:\n");
			$fwrite(glog, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
			uut.GPU.wSprtPixel7,uut.GPU.wSprtPixel6,uut.GPU.wSprtPixel5,uut.GPU.wSprtPixel4,uut.GPU.wSprtPixel3,uut.GPU.wSprtPixel2,uut.GPU.wSprtPixel1,uut.GPU.wSprtPixel0);

			$fwrite(glog, "\nFrame buffer Pixel Row:\n");
			$fwrite(glog, "%02x %02x %02x %02x %02x %02x %02x %02x\n",
			uut.GPU.wPixel7,uut.GPU.wPixel6,uut.GPU.wPixel5,uut.GPU.wPixel4,uut.GPU.wPixel3,uut.GPU.wPixel2,uut.GPU.wPixel1,uut.GPU.wPixel0);


			$fwrite(glog,"\n\n\n");


	 end //if
end //always
`endif

`ifdef ENABLE_CPU_LOG
	always @ ( posedge iClock )
	begin
		wait(iReset != 1);

		//if (uut.DZCPU.wPc == 16'he0)//16'h0fc // || uut.GPU.oLY == 8'hff)	//This instructrion finishes copying the little (R)
			//rSimulationDone = 1;


		if (uut.DZCPU.rCurrentState == `DZCPU_START_FLOW)
		begin
			Pc = uut.DZCPU.wPc;
			case (uut.DZCPU.wuOpFlowIdx)
			1:  $fwrite(log,"=== LDSPnn === %h \n", uut.DZCPU.iMCUData );
			5:  $fwrite(log,"=== LDHLnn === %h \n", uut.DZCPU.iMCUData );
			9:  $fwrite(log,"=== LDHLDA === %h \n", uut.DZCPU.iMCUData );
			13: $fwrite(log,"=== MAPcb === %h \n", uut.DZCPU.iMCUData );
			17: $fwrite(log,"=== JRNZn === %h \n", uut.DZCPU.iMCUData );
			23: $fwrite(log,"=== LDrn_c === %h \n", uut.DZCPU.iMCUData );
			26: $fwrite(log,"=== LDrn_a === %h \n", uut.DZCPU.iMCUData );
			29: $fwrite(log,"=== LDIOCA === %h \n", uut.DZCPU.iMCUData );
			32: $fwrite(log,"=== INCr_c === %h \n", uut.DZCPU.iMCUData );
			33: $fwrite(log,"=== LDHLmr_a === %h \n", uut.DZCPU.iMCUData );
			36: $fwrite(log,"=== LDIOnA  === %h \n", uut.DZCPU.iMCUData );
			43: $fwrite(log,"=== LDDEnn  === %h \n", uut.DZCPU.iMCUData );
			94: $fwrite(log,"=== LDADEm  === %h \n", uut.DZCPU.iMCUData );
			49: $fwrite(log,"=== CALLnn === %h \n", uut.DZCPU.iMCUData );
			60: $fwrite(log,"=== LDrn_b === %h \n", uut.DZCPU.iMCUData );
			63: $fwrite(log,"=== PUSHBC === %h \n", uut.DZCPU.iMCUData );
			70: $fwrite(log,"=== RLA === %h \n", uut.DZCPU.iMCUData );
			71: $fwrite(log,"=== POPBC === %h \n", uut.DZCPU.iMCUData );
			77: $fwrite(log,"=== DECr_b === %h \n", uut.DZCPU.iMCUData );
			78: $fwrite(log,"=== LDHLIA === %h \n", uut.DZCPU.iMCUData );
			82: $fwrite(log,"=== INCHL === %h \n", uut.DZCPU.iMCUData );
			252/*83*/: $fwrite(log,"=== RET === %h \n", uut.DZCPU.iMCUData );
			89: $fwrite(log,"=== INCDE === %h \n", uut.DZCPU.iMCUData );
			90: $fwrite(log,"=== CPn === %h \n", uut.DZCPU.iMCUData );
			98: $fwrite(log,"=== LDmmA === %h \n", uut.DZCPU.iMCUData );
			47: $fwrite(log,"=== DECr_a === %h \n", uut.DZCPU.iMCUData );
			48: $fwrite(log,"=== DECr_c === %h \n", uut.DZCPU.iMCUData );
			106: $fwrite(log,"=== JRZn === %h \n", uut.DZCPU.iMCUData );
			112: $fwrite(log,"=== LDrn_l  === %h \n", uut.DZCPU.iMCUData );
			115: $fwrite(log,"=== JRn  === %h \n", uut.DZCPU.iMCUData );
			161: $fwrite(log,"=== INCr_b  === %h \n", uut.DZCPU.iMCUData );
			121: $fwrite(log,"=== LDrn_e  === %h \n", uut.DZCPU.iMCUData );
			124: $fwrite(log,"=== LDAIOn  === %h \n", uut.DZCPU.iMCUData );
			131: $fwrite(log,"=== INCr_h  === %h \n", uut.DZCPU.iMCUData );
			132: $fwrite(log,"=== SUBr_b  === %h \n", uut.DZCPU.iMCUData );
			135: $fwrite(log,"=== DECr_d  === %h \n", uut.DZCPU.iMCUData );
			136: $fwrite(log,"=== LDrn_d  === %h \n", uut.DZCPU.iMCUData );
			139: $fwrite(log,"=== JPnn  === %h \n", uut.DZCPU.iMCUData );
			146: $fwrite(log,"=== LDrn_h  === %h \n", uut.DZCPU.iMCUData );
			149: $fwrite(log,"=== LDAHLI  === %h \n", uut.DZCPU.iMCUData );
			154: $fwrite(log,"=== LDHLmn  === %h \n", uut.DZCPU.iMCUData );
			162: $fwrite(log,"=== NOP  ===  \n");
			163: $fwrite(log,"=== DI  ===  \n", uut.DZCPU.iMCUData );
			164: $fwrite(log,"=== INCr_d  === %h \n", uut.DZCPU.iMCUData );
			250/*165*/: $fwrite(log,"=== INCr_e  === %h \n", uut.DZCPU.iMCUData );
			166: $fwrite(log,"=== DECr_e  === %h \n", uut.DZCPU.iMCUData );
			167: $fwrite(log,"=== DECDE  === %h \n", uut.DZCPU.iMCUData );
			168: $fwrite(log,"=== DECr_h  === %h \n", uut.DZCPU.iMCUData );
			169: $fwrite(log,"=== DECHL  === %h \n", uut.DZCPU.iMCUData );
			170: $fwrite(log,"=== INCr_a  === %h \n", uut.DZCPU.iMCUData );
			171: $fwrite(log,"=== INCSP === %h \n", uut.DZCPU.iMCUData ); //Increment SP
			172: $fwrite(log,"=== DECSP === %h \n", uut.DZCPU.iMCUData );
			173: $fwrite(log,"=== INCr_l  === %h \n", uut.DZCPU.iMCUData );
			174: $fwrite(log,"=== DECr_l  === %h \n", uut.DZCPU.iMCUData );
			175: $fwrite(log,"=== ADDr_a  === %h \n", uut.DZCPU.iMCUData );
			178: $fwrite(log,"=== ADDr_b  === %h \n", uut.DZCPU.iMCUData );
			181: $fwrite(log,"=== SUBr_c  === %h \n", uut.DZCPU.iMCUData );
			187: $fwrite(log,"=== ADDr_d  === %h \n", uut.DZCPU.iMCUData );
			190: $fwrite(log,"=== ADDr_e  === %h \n", uut.DZCPU.iMCUData );
			193: $fwrite(log,"=== ADDr_h  === %h \n", uut.DZCPU.iMCUData );
			196: $fwrite(log,"=== ADDr_l  === %h \n", uut.DZCPU.iMCUData );
			199: $fwrite(log,"=== SUBr_d  === %h \n", uut.DZCPU.iMCUData );
			202: $fwrite(log,"=== SUBr_e  === %h \n", uut.DZCPU.iMCUData );
			205: $fwrite(log,"=== SUBr_h  === %h \n", uut.DZCPU.iMCUData );
			208: $fwrite(log,"=== SUBr_l  === %h \n", uut.DZCPU.iMCUData );
			211: $fwrite(log,"=== SUBr_a  === %h \n", uut.DZCPU.iMCUData );
			214: $fwrite(log,"=== PUSHDE  === %h \n", uut.DZCPU.iMCUData );
			220: $fwrite(log,"=== PUSHHL  === %h \n", uut.DZCPU.iMCUData );
			226: $fwrite(log,"=== POPDE === %h \n", uut.DZCPU.iMCUData );
			232: $fwrite(log,"=== POPHL === %h \n", uut.DZCPU.iMCUData );
			238: $fwrite(log,"=== LDHLmr_b === %h \n", uut.DZCPU.iMCUData );
			241: $fwrite(log,"=== LDHLmr_c === %h \n", uut.DZCPU.iMCUData );
			244: $fwrite(log,"=== LDHLmr_d === %h \n", uut.DZCPU.iMCUData );
			247: $fwrite(log,"=== LDDEmA === %h \n", uut.DZCPU.iMCUData );
			261: $fwrite(log,"=== PUSHAF === %h \n", uut.DZCPU.iMCUData );
			267: $fwrite(log,"=== POPAF === %h \n", uut.DZCPU.iMCUData );
			273: $fwrite(log,"=== LDBCnn === %h \n", uut.DZCPU.iMCUData );
			83: $fwrite(log,"=== INCBC === %h \n", uut.DZCPU.iMCUData );
			280: $fwrite(log,"=== LDAmm === %h \n", uut.DZCPU.iMCUData );
			85:  $fwrite(log,"=== ANDn === %h\n", uut.DZCPU.iMCUData );
			default:
			  case (uut.DZCPU.iMCUData)

							`LDrr_ha: $fwrite(log,"=== LDrr_ha  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_da: $fwrite(log,"=== LDrr_da  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_ae: $fwrite(log,"=== LDrr_ae  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_ca: $fwrite(log,"=== LDrr_ca  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_ah: $fwrite(log,"=== LDrr_ah  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_al: $fwrite(log,"=== LDrr_al  === %h \n", uut.DZCPU.iMCUData );
							`LDrr_ab: $fwrite(log,"=== LDrr_ab  === %h \n", uut.DZCPU.iMCUData );
							`XORr_a: $fwrite(log,"=== XORr_a  === %h \n", uut.DZCPU.iMCUData );
							`ORr_b: $fwrite(log,"=== ORr_a  === %h \n", uut.DZCPU.iMCUData );
							`ORr_c: $fwrite(log,"=== ORr_c  === %h \n", uut.DZCPU.iMCUData );
							`NOP: $fwrite(log,"=== NOP  === %h \n", uut.DZCPU.iMCUData );
							default:
							begin
									if (rResetDone)
									begin
											$fwrite(log,"=== Unknown Flow. Insns %h\n",uut.DZCPU.iMCUData);
											rSimulationDone = 1'b1;
									end
							end
				endcase

			endcase
		end


		if (uut.MMU.iGpuReadRequest)
		begin
			$fwrite(log,"%dns [MMU] Gpu requesting read @ %h (%h)\n ", $time, uut.MMU.iGpuAddr, uut.MMU.wVmemReadAddr);
			$fwrite(glog,"%dns [MMU] Gpu requesting read @ %h (%h)\n ", $time, uut.MMU.iGpuAddr, uut.MMU.wVmemReadAddr);
		end



		if (uut.DZCPU.rFlowEnable)
		begin
			$fwrite(log,"%05dns [DZCPU] %d  .",$time, uut.DZCPU.wuPc);
			case (uut.DZCPU.wuCmd)
				`nop: $fwrite(log,"nop \n");
				`sma: $fwrite(log,"sma %h\n", uut.DZCPU.oMCUAddr);
				`srm:
				begin
					$fwrite(log,"srm %h %h\n", uut.DZCPU.wUopSrc, uut.DZCPU.iMCUData);
					$fwrite(log,"[MMU] reading %h @ %h\n", uut.MMU.oCpuData,uut.MMU.iCpuAddr);
				end
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
				`subx16: $fwrite(log,"subx16 %h -= %h = %h\n", uut.DZCPU.wX16, uut.DZCPU.wRegData, uut.DZCPU.rUopDstRegData);
				`srx16: $fwrite(log,"srx16 %h\n", uut.DZCPU.wRegData);
				`ceti: $fwrite(log,"ceti %h\n", uut.DZCPU.wRegData);
				`jint: $fwrite(log,"jint %h\n", uut.DZCPU.wRegData);
				`seti: $fwrite(log,"set %h\n", uut.DZCPU.wRegData);
				`z801bop:
				begin
					case (uut.DZCPU.iMCUData[7:3])
						5'b10100:	$fwrite(log,"%05dns a &= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );
						5'b10101:	$fwrite(log,"%05dns a ^= %h = %h\n", $time, uut.DZCPU.wRegData, uut.DZCPU.rZ80Result );

					endcase
				end
				default:
				begin
					$fwrite(log,"unknow uop %d Stopping Simulation\n", uut.DZCPU.wuCmd);
					rSimulationDone = 1;
				end
			endcase
		end



		if (uut.MMU.iCpuWe)
		begin
			$fwrite(log,"%05dns [MMU] ", $time);

			if (uut.MMU.iCpuAddr >= 16'hff00 && uut.MMU.iCpuAddr <= 16'hff7f )
				$fwrite(log," [IO] ");

			if (uut.MMU.iCpuAddr >= 16'hff10 && uut.MMU.iCpuAddr <= 16'hff23 )
				$fwrite(log," [SOUND] ");

			if (uut.MMU.iCpuAddr >= 16'hff40 && uut.MMU.iCpuAddr <= 16'hff4B )
				$fwrite(log," [LCD] ");

			if (uut.MMU.iCpuAddr >= 16'hff80 && uut.MMU.iCpuAddr <= 16'hffff )
				$fwrite(log," [PAGEZERO] ");

			if (uut.MMU.iCpuAddr >= 16'h8000 && uut.MMU.iCpuAddr <= 16'h87ff )
				$fwrite(log," [VMEM Tiles 0] ");

			if (uut.MMU.iCpuAddr >= 16'h8800 && uut.MMU.iCpuAddr <= 16'h8fff )
				$fwrite(log," [VMEM Tiles 1] ");

			if (uut.MMU.iCpuAddr >= 16'h9800 && uut.MMU.iCpuAddr <= 16'h9BFF)
				$fwrite(log," [VMEM TileMap 0] ");

			if (uut.MMU.iCpuAddr >= 16'h9C00 && uut.MMU.iCpuAddr <= 16'h9FFF)
				$fwrite(log," [VMEM TileMap 1] ");


			 $fwrite(log,"Writting %h @ %h\n", uut.MMU.iCpuData,uut.MMU.iCpuAddr);
		end


		if (uut.DZCPU.wEof )
		begin
			$fwrite(log,"\n             %04s %04s %02s %02s %02s %02s %02s %02s %02s %02s %02s %02s\n", "PC", "SP", "B", "C", "D" ,"E", "H", "L", "A", "F", "Flags", "x8", "x16");
			$fwrite(log,"[regs] %04x %04x %02x %02x %02x %02x %02x %02x %02x %02x %b %02x %02x\n", Pc, {uut.DZCPU.wSpH,uut.DZCPU.wSpL}, uut.DZCPU.wB, uut.DZCPU.wC, uut.DZCPU.wD, uut.DZCPU.wE ,uut.DZCPU.wH, uut.DZCPU.wL, uut.DZCPU.wA,uut.DZCPU.wF, uut.DZCPU.wFlags, uut.DZCPU.wX8, uut.DZCPU.wX16);


			$fwrite(log,"\n\n         %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s %05s\n",
			"STAT", "LCDC", "SCY",   "SCX" ,  "LY",
			"LYC",  "DMA",   "BGP",   "BP0",
			"BP1",  "WY", "WX");

			$fwrite(log,"[regs]      %02x   %02x     %02x    %02x    %02x   %02x    %02x    %02x    %02x    %02x     %02x    %02x\n",
			uut.GPU.oSTAT,  uut.GPU.oLCDC,  uut.GPU.oSCY,     uut.GPU.oSCX,   			uut.GPU.oLY,
			uut.GPU.oLYC,   uut.GPU.oDMA,     uut.GPU.oBGP,         uut.GPU.oOBP0,
			uut.GPU.oOBP1, 	uut.GPU.oWY,      uut.GPU.oWX );


			`ifdef CPU_TRACE_WORK_MEMORY

			$fwrite(log, "=== WORK MEMORY C000 - DFFFF ===\n");
			$fwrite(log,"%02h: ",16'hc000);
			for (i = 0; i <  5*16; i = i + 1)
			begin
					$fwrite(log,"%02h ", uut.MMU.WORK_RAM.Ram[i]);
					if ((i+1) % 16 == 0)
							$fwrite(log,"\n %h: ", (16'hc000+i));

			end

			for (i = 8176; i <  8176+15*16; i = i + 1)
			begin
					$fwrite(log,"*%02x ", uut.MMU.WORK_RAM.Ram[i]);
					if ((i+1) % 16 == 0)
							$fwrite(log,"\n");

			end
			`endif

			if (uut.GPU.oLY == 144)
				$fwrite(log,"[SCREEN_FRAME_COMPLETED]\n");
			$fwrite(log,"\n\n\n");

		end
	end
`endif	//ENABLE_CPU_LOG

endmodule
