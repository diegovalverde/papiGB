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
	`LDrn_c: oUopFlowIdx = 8'd23;
	`LDrn_a: oUopFlowIdx = 8'd26;
	`LDIOCA: oUopFlowIdx = 8'd29;
	`INCr_c: oUopFlowIdx = 8'd32;
	`LDHLmr_a: oUopFlowIdx = 8'd33;
	`LDIOnA: oUopFlowIdx = 8'd36;
	`LDDEnn: oUopFlowIdx = 8'd43;
	`LDADEm: oUopFlowIdx = 8'd47;
	`CALLnn: oUopFlowIdx = 8'd50;
	`LDrn_b: oUopFlowIdx = 8'd60;
	`PUSHBC: oUopFlowIdx = 8'd63;
	`RLA:    oUopFlowIdx = 8'd70;	//TODO: Make sure this is OK!
	`POPBC:  oUopFlowIdx = 8'd71;
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
		8'h11: oUopFlowIdx = 8'd69;		//RLr_b
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
	//JRNZ
		17: oUop = { `inc, `sma, `pc   };
		18: oUop = { `op,  `nop, `null };
		19: oUop = { `inc_eof_z,  `srm, `x8 }; 	//If not z return else x8 = MEM[pc]
		20: oUop = { `op,  `sx16r, `pc };  		//x16 = pc
		21: oUop = { `op,`addx16, `x8  };       //x16 = x16 + sign_extend{8'b0,x8}
		22: oUop = { `eof, `spc, `x16  };  		//pc = x16
	//LDrn_c
		23: oUop = {`inc, `sma, `pc};
		24: oUop = { `inc,  `nop, `null };
		25: oUop = {`eof, `srm,  `c };
	//LDrn_a
		26: oUop = {`inc, `sma, `pc};
		27: oUop = { `inc,  `nop, `null };
		28: oUop = {`eof, `srm,  `a };
	//LDIOCA
		29: oUop = {`op, `sma, `io_c };
		30: oUop = {`op, `smw, `a };
		31: oUop = {`inc_eof, `sma, `pc };
	//INCR_C
		32: oUop = {`inc_eof, `inc16, `c };
	//LDHLmr_a
		33: oUop = {`inc, `sma, `hl  };
		34: oUop = {`op, `smw, `a    };
		35: oUop = {`eof, `sma, `pc  };
	//LDIOnA
		36: oUop = { `inc, `sma, `pc  };
		37: oUop = { `op ,`sx8r, `c   };
		38: oUop = { `op ,`srm, `c    };
		39: oUop = { `op, `sma, `io_c };
		40: oUop = { `op, `smw, `a    };
		41: oUop = { `inc, `srx8, `c  };
		42: oUop = { `eof, `sma, `pc  };
	//LDDEnn
		43: oUop = { `inc, `sma, `pc   };
		44: oUop = { `inc, `nop, `null };
		45: oUop = { `op , `srm, `e    };
		46: oUop = { `inc_eof , `srm, `d };
	//LDADEm
		47: oUop = {`inc, `sma, `de  };
		48: oUop = {`op, `srm, `a    };
		49: oUop = {`eof, `sma, `pc  };
	//CALLnn
		50: oUop = { `inc, `dec16, `sp  };
		51: oUop = { `op, `dec16,  `sp  }; //sp -= 2
		52: oUop = { `op ,`srm,    `x8  }; //x8 = MEM[pc] = literal
		53: oUop = { `op ,`sx16r,  `pc  };
		54: oUop = { `op ,`inc16,  `x16 };
		55: oUop = { `op ,`inc16,  `x16 }; //x16 = pc + 2
		56: oUop = { `op ,`sma,    `sp  };
		57: oUop = { `op ,`smw,    `x16 };	//MEM[sp] = pc + 2
		58: oUop = { `op ,`spc,    `x8 };
		59: oUop = { `eof ,`sma,   `pc };
	//LDrn_b
		60: oUop = { `inc, `sma, `pc   };
		61: oUop = { `inc, `nop, `null };
		62: oUop = { `eof , `srm, `b   };
	//PUSHBC
		63: oUop = { `op, `dec16,  `sp  };
		64: oUop = { `op, `sma,    `sp  };
		65: oUop = { `op ,`smw,    `b   };
		66: oUop = { `op, `dec16,  `sp  };
		67: oUop = { `op ,`smw,     `c  };
		68: oUop = { `inc_eof ,`sma,`pc };
	//RLr_r
		69: oUop = { `eof, `shl,  `null  };
	//RLA
		70: oUop = { `inc_eof, `shl,  `null  };
	//POPBC
		71: oUop = { `op, `sma,    `sp  };
		72: oUop = { `op ,`inc16,  `sp };
		73: oUop = { `op ,`srm,    `c  };
		74: oUop = { `op ,`srm,    `b  };
		75: oUop = { `inc ,`inc16,  `sp };
		76: oUop = { `eof, `sma,    `pc  };
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
