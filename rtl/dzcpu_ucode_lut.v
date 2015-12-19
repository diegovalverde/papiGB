`timescale 1ns / 1ps
`include "z80_opcode_definitions.v"

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


module dzcpu_ucode_lut
(
	input  wire[7:0]  iMop,
	output reg [7:0]  oUopFlowIdx
);



wire [7:0] wUopFlowIdx;



always @ ( iMop )
begin
	case ( iMop )
	`LDSPnn: oUopFlowIdx = 8'd1;
	`LDHLnn: oUopFlowIdx = 8'd5;
	`LDHLDA: oUopFlowIdx = 8'd9;
	`MAPcb:  oUopFlowIdx = 8'd13;
	`JRNZn:  oUopFlowIdx = 8'd17;
	default:
			 oUopFlowIdx = 8'd0;
	endcase
end



endmodule




module dzcpu_ucode_cblut
(
	input  wire[7:0]  iMop,
	output reg [7:0]  oUopFlowIdx
);



wire [7:0] wUopFlowIdx;



always @ ( iMop )
begin
	case ( iMop )
		8'h7C: oUopFlowIdx = 8'd16;		//BIT7
	default:
			 oUopFlowIdx = 8'd0;
	endcase
end



endmodule




module dzcpu_ucode_rom
(
	input  wire[7:0]  iAddr,
	output reg [11:0]  oUop
);
always @ ( iAddr )
begin
	case ( iAddr )
	//Regular 1 Byte mOp
		0: oUop = { `inc_eof, `z801bop , `a };
	//LDSPnn
		1: oUop = { `inc, `sma, `pc   };
		2: oUop = { `inc, `nop, `null };
		3: oUop = { `op , `srm, `spl  };
		4: oUop = { `inc_eof , `srm, `sph };
	//LDHLnn
		5: oUop = { `inc, `sma, `pc   };
		6: oUop = { `inc, `nop, `null };
		7: oUop = { `op , `srm, `l    };
		8: oUop = { `inc_eof , `srm, `h    };
	//LDHLDA
		9:  oUop = { `op,  `sma,   `hl };
		10: oUop = { `op,  `smw,   `a  };
		11: oUop = { `inc, `sma,   `pc };
		12: oUop = { `eof, `dec16, `hl };
	//0xCB
		13: oUop = { `inc, `sma, `pc   };
		14: oUop = { `op,  `nop, `null };
		15: oUop = { `inc, `jcb, `null };
	//BIT
		16: oUop = { `eof, `bit, `null };
	//
		17: oUop = { `inc, `sma, `pc   };  //If not z return
		18: oUop = { `eof_z,  `nop, `null };
		19: oUop = { `inc, `srm, `x8   };  //x8 = MEM[pc]
		20: oUop = { `op,  `sx16r, `pc };  //x16 = pc
		21: oUop = { `op,`addx16, `x8  };      //x16 = x16 + sign_extend{8'b0,x8}
		22: oUop = { `eof, `spc, `x16  };  		//pc = x16




	/*
	//RETI

	inc sma shadow_addr_reg
	op  smw
	op  inc16 x16
	op  smw b
	op  inc16 x16
	op  smw c
	op  inc16 x16
	op  smw e
	op  inc16 x16
	op  smw h
	op  inc16 x16
	op  smw l
	op  inc16 x16
	op  smw spl
	op  inc16 x16
	op  smw sph
	*/
	default:
		oUop = {`op, `nop, `null };
	endcase
end


endmodule
