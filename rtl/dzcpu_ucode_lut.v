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
	output reg [8:0]  oUopFlowIdx
);







always @ ( iMop )
begin
	case ( iMop )
	`LDSPnn: oUopFlowIdx = 9'd1;
	`LDHLnn: oUopFlowIdx = 9'd5;
	`LDHLDA: oUopFlowIdx = 9'd9;
	`MAPcb:  oUopFlowIdx = 9'd13;
	`JRNZn:  oUopFlowIdx = 9'd17;
	`LDrn_c: oUopFlowIdx = 9'd23;
	`LDrn_a: oUopFlowIdx = 9'd26;
	`LDIOCA: oUopFlowIdx = 9'd29;
	`INCr_c: oUopFlowIdx = 9'd32;
	`LDHLmr_a: oUopFlowIdx = 9'd33;
	`LDIOnA: oUopFlowIdx = 9'd36;
	`LDDEnn: oUopFlowIdx = 9'd43;
	`LDADEm: oUopFlowIdx = 9'd94;
	`CALLnn: oUopFlowIdx = 9'd49;
	`LDrn_b: oUopFlowIdx = 9'd60;
	`PUSHBC: oUopFlowIdx = 9'd63;
	`RLA:    oUopFlowIdx = 9'd70;	//TODO: Make sure this is OK!
	`POPBC:  oUopFlowIdx = 9'd71;
	`DECr_b: oUopFlowIdx = 9'd300;
	`LDHLIA: oUopFlowIdx = 9'd78;
	`INCHL:  oUopFlowIdx = 9'd82;
	`RET:    oUopFlowIdx = 9'd252;//8'd83;
	`INCDE:  oUopFlowIdx = 9'd89;
	`CPn:    oUopFlowIdx = 9'd90;
	`LDmmA: oUopFlowIdx  = 9'd98;
	`DECr_a: oUopFlowIdx = 9'd47;
	`DECr_c: oUopFlowIdx = 9'd48;
	`JRZn:   oUopFlowIdx = 9'd106;
	`LDrn_l: oUopFlowIdx = 9'd112;
	`JRn:    oUopFlowIdx = 9'd115;
	`INCr_b: oUopFlowIdx = 9'd161;
	`LDrn_e: oUopFlowIdx = 9'd121;
	`LDAIOn: oUopFlowIdx = 9'd124;
	`INCr_h: oUopFlowIdx = 9'd312;
	`SUBr_b: oUopFlowIdx = 9'd132;
	`DECr_d: oUopFlowIdx = 9'd135;
	`LDrn_d: oUopFlowIdx = 9'd136;
	`JPnn:   oUopFlowIdx = 9'd139;
	`LDrn_h: oUopFlowIdx = 9'd146;
	`LDAHLI: oUopFlowIdx = 9'd149;
	`LDHLmn: oUopFlowIdx = 9'd154;
	`NOP:    oUopFlowIdx = 9'd162;
  `DI:     oUopFlowIdx = 9'd163;
  `INCr_d: oUopFlowIdx = 9'd164;
  `INCr_e: oUopFlowIdx = 9'd250; //8'd165;
  `DECr_e: oUopFlowIdx = 9'd166;
  `DECDE:  oUopFlowIdx = 9'd168;
  `DECr_h: oUopFlowIdx = 9'd170;
  `DECHL:  oUopFlowIdx = 9'd172;
  `INCr_a: oUopFlowIdx = 9'd302;
	`INCSP:  oUopFlowIdx = 9'd304;
	`DECSP:  oUopFlowIdx = 9'd306;
	`INCr_l: oUopFlowIdx = 9'd308;
	`DECr_l: oUopFlowIdx = 9'd310;
	`ADDr_a: oUopFlowIdx = 9'd175;
	`ADDr_b: oUopFlowIdx = 9'd178;
	`SUBr_c: oUopFlowIdx = 9'd181;
	`ADDr_c: oUopFlowIdx = 9'd184;
	`ADDr_d: oUopFlowIdx = 9'd187;
	`ADDr_e: oUopFlowIdx = 9'd190;
	`ADDr_h: oUopFlowIdx = 9'd193;
	`ADDr_l: oUopFlowIdx = 9'd196;
	`SUBr_d: oUopFlowIdx = 9'd199;
	`SUBr_e: oUopFlowIdx = 9'd202;
	`SUBr_h: oUopFlowIdx = 9'd205;
	`SUBr_l: oUopFlowIdx = 9'd208;
	`SUBr_a: oUopFlowIdx = 9'd211;
	`PUSHDE: oUopFlowIdx = 9'd214;
	`PUSHHL: oUopFlowIdx = 9'd220;
	`POPDE:  oUopFlowIdx = 9'd226;
	`POPHL:  oUopFlowIdx = 9'd232;
	`LDHLmr_b: oUopFlowIdx = 9'd238;
	`LDHLmr_c: oUopFlowIdx = 9'd241;
	`LDHLmr_d: oUopFlowIdx = 9'd244;
	`LDDEmA:   oUopFlowIdx = 9'd247;
	`PUSHAF:   oUopFlowIdx = 9'd261;
	`POPAF:    oUopFlowIdx = 9'd267;
	`LDBCnn:   oUopFlowIdx = 9'd273;
	`INCBC:    oUopFlowIdx = 9'd83;
	`LDAmm:    oUopFlowIdx = 9'd280;
	`ANDn:     oUopFlowIdx = 9'd85;
	`CALLNZnn: oUopFlowIdx = 9'd289;
	`ADDn:     oUopFlowIdx = 9'd314;
	`SUBn:     oUopFlowIdx = 9'd319;
	`CPr_c:    oUopFlowIdx = 9'd324;
	`LDrHLm_b: oUopFlowIdx = 9'd327;
	`LDrHLm_c: oUopFlowIdx = 9'd331;
	`LDrHLm_d: oUopFlowIdx = 9'd335;
	`XORHL:    oUopFlowIdx = 9'd339;
	`ADCn:     oUopFlowIdx = 9'd345;
	`ADDHLDE:  oUopFlowIdx = 9'd351;
	`JRNCn:    oUopFlowIdx = 9'd354;
	`XORn:     oUopFlowIdx = 9'd359;
	`RRA:     oUopFlowIdx = 9'd363;
	//`DECBC:  oUopFlowIdx = 8'd164; //OK

	default:
			 oUopFlowIdx = 9'd278;
	endcase
end



endmodule




module dzcpu_ucode_cblut
(
	input  wire[7:0]  iMop,
	output reg [8:0]  oUopFlowIdx
);







always @ ( iMop )
begin
	case ( iMop )
		8'h7C: oUopFlowIdx = 9'd16;		//BIT7
		8'h11: oUopFlowIdx = 9'd69;		//RLr_b

	default:
			oUopFlowIdx = 9'd0;
	endcase
end



endmodule




module dzcpu_ucode_rom
(
	input  wire[8:0]  iAddr,
	output reg [13:0]  oUop
);
always @ ( iAddr )
begin
	case ( iAddr )
	//Regular 1 Byte mOp
		0: oUop = { `inc_eof_fu, `z801bop , `a };
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
	//MAPcb 0xCB
		13: oUop = { `inc, `sma, `pc   };
		14: oUop = { `op,  `nop, `null };
		15: oUop = { `inc, `jcb, `null };
	//BIT
		16: oUop = { `eof_fu, `bit, `null };
	//JRNZ
		17: oUop = { `inc, `sma, `pc   };
		18: oUop = { `op,  `nop, `null };
		19: oUop = { `inc_eof_z,  `srm, `x8 }; 	//If z return else x8 = MEM[pc]
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
	//INCr_c
		32: oUop = {`inc_eof_fu, `inc16, `c };
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
	//DECr_a
		47:	oUop = { `inc_eof_fu, `dec16,    `a  };
	//DECr_c
		48:	oUop = { `inc_eof_fu, `dec16,    `c  };
	//CALLnn
		49: oUop = { `inc, `dec16,  `sp  };
		50: oUop = { `inc, `sx16r,  `hl  };
		51: oUop = { `op , `srm,    `l   }; //l = MEM[pc] = literal
		52: oUop = { `inc, `srm,    `h   }; //l = MEM[pc] = literal
		53: oUop = { `op,  `sma,    `sp  };
		54: oUop = { `op,  `smw,    `pch };	//MEM[sp] = pc[7:0]
		55: oUop = { `op,  `dec16,  `sp  };
		56: oUop = { `op , `smw,    `pc  };	//MEM[sp+1] = pc[15:8]
		57: oUop = { `op , `spc,    `hl  };
		58: oUop = { `op, `srx16,  `hl  };
		59: oUop = { `eof ,`sma,   `pc   };
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
		69: oUop = { `eof_fu, `shl,  `null  };
	//RLA
		70: oUop = { `inc_eof_fu, `shl,  `null  };
	//POPBC
		71: oUop = { `op, `sma,    `sp   };
		72: oUop = { `op ,`inc16,  `sp   };
		73: oUop = { `op ,`srm,    `c    };
		74: oUop = { `op ,`srm,    `b    };
		75: oUop = { `inc ,`inc16,  `sp  };
		76: oUop = { `eof, `sma,    `pc  };
	//UNUSED
		77:	oUop = { `inc_eof_fu, `dec16,    `b  };
	//LDHLIA
		78: oUop = {`op, `sma, `hl  };
		79: oUop = {`op, `smw, `a    };
		80: oUop = { `inc ,`inc16,  `hl };
		81: oUop = {`eof, `sma, `pc  };
	//INCHL
		82: oUop = { `inc_eof ,`inc16,  `hl };
	//INCBC
	  83: oUop = { `update_flags ,`inc16,  `bc   };		//flags might be wrong for 16bits
		84: oUop = { `inc_eof, `nop, `null  };

	//ANDn
		85: oUop = { `inc, `sma,  `pc };
		86: oUop = { `op, `nop , `null };
		87: oUop = { `update_flags ,`anda,    `idata  };
		88: oUop = { `inc_eof ,`nop,    `null  };

	//INCDE
		89: oUop = { `inc_eof, `inc16, `de };
	//CPn
		90: oUop = { `inc, `sx16r, `a };
		91: oUop = { `op, `nop, `null };
		92: oUop = { `op, `srm, `x8   };
		93: oUop = { `inc_eof_fu, `subx16, `x8   };	//x16 = x16 - x8 -> a = a - lit
//LDADEm
		94: oUop = {`inc, `sma, `de  };
		95: oUop = {`op, `nop, `null };
		96: oUop = {`op, `srm, `a    };
		97: oUop = {`eof, `sma, `pc  };
//LDmmA
		98: oUop = {`inc, `sx16r,  `hl };
		99: oUop = {`inc,  `sma,   `pc };
		100: oUop = {`op,   `srm,   `l  };
		101: oUop = {`op,   `srm,   `h  };
		102: oUop = {`op,   `sma,   `hl };
		103: oUop = {`op,   `smw,   `a  };
		104: oUop = {`inc,  `sma,   `pc };
		105: oUop = {`eof,  `srx16, `hl };
//JRZn
		106: oUop = { `inc, `sma, `pc   };
		107: oUop = { `op,  `nop, `null };
		108: oUop = { `inc_eof_nz, `srm, `x8 }; 	//If not z return else x8 = MEM[pc]
		109: oUop = { `op,  `sx16r, `pc };  		//x16 = pc
		110: oUop = { `op,`addx16, `x8  };       //x16 = x16 + sign_extend{8'b0,x8}
		111: oUop = { `eof, `spc, `x16  };  		//pc = x16
//LDrn_l
		112: oUop = {`inc, `sma, `pc     };
		113: oUop = { `inc,  `nop, `null };
		114: oUop = {`eof, `srm,  `l     };
//JRn
		115: oUop = { `inc, `sma, `pc   };
		116: oUop = { `op,  `nop, `null };
		117: oUop = { `inc, `srm, `x8   };
		118: oUop = { `op,  `sx16r, `pc };       //x16 = pc
		119: oUop = { `op,`addx16, `x8  };       //x16 = x16 + sign_extend{8'b0,x8}
		120: oUop = { `eof, `spc, `x16  };       //pc = x16
//LDrn_e
		121: oUop = {`inc, `sma, `pc     };
		122: oUop = { `inc,  `nop, `null };
		123: oUop = {`eof, `srm,  `e     };
//LDAIOn
		124: oUop = { `inc, `sx8r, `c    };
		125: oUop = { `op,  `nop,  `null };
		126: oUop = { `op,  `srm,  `c    };
		127: oUop = { `op,   `sma, `io_c };
		128: oUop = { `op,   `srm,  `a   };
		129: oUop = { `op,   `srx8, `c   };
		130: oUop = { `inc_eof, `sma, `pc };
//UNUSED
		131: oUop = { `op, `nop, `null };
//SUBr_b
		132: oUop = { `op, `sx16r, `a       };
		133: oUop = { `update_flags, `subx16, `b      };
		134: oUop = { `inc_eof, `srx16, `a  };
//DECr_d
		135:	oUop = { `inc_eof_fu, `dec16,    `d  };
//LDrn_d
		136: oUop = {`inc, `sma, `pc     };
		137: oUop = { `inc,  `nop, `null };
		138: oUop = {`eof, `srm,  `d     };
//JPnn
		139: oUop = {`op, `sx16r,  `hl };
		140: oUop = {`inc,  `sma,   `pc };
		141: oUop = {`inc,  `nop, `null };
		142: oUop = {`inc,   `srm,   `l  };
		143: oUop = {`op,   `srm,   `h  };
		144: oUop = {`op,   `spc,   `hl  };
		145: oUop = {`eof,  `srx16, `hl };
//LDrn_h
		146: oUop = {`inc, `sma, `pc     };
		147: oUop = { `inc,  `nop, `null };
		148: oUop = {`eof, `srm,  `h     };
//LDAHLI
		149: oUop = {`op, `sma, `hl  };
		150: oUop = {`op,  `nop, `null };
		151: oUop = {`op, `srm, `a    };
		152: oUop = { `inc ,`inc16,  `hl };
		153: oUop = {`eof, `sma, `pc  };
//LDHLmn
		154: oUop = {`inc,  `sma,   `pc };
		155: oUop = {`op,  `nop, `null };
		156: oUop = {`op,   `srm,   `x8  };
		157: oUop = {`op,   `sma,   `hl };
		158: oUop = {`op,  `nop, `null };
		159: oUop = {`op,   `smw,   `x8  };
		160: oUop = {`inc_eof,  `sma,   `pc };
//INCR_b
		161: oUop = {`inc_eof_fu, `inc16, `b };

//NOP
		162: oUop = { `inc_eof, `nop, `null };
//DI
		163: oUop = { `inc_eof, `ceti, `null }; //Disable Interruption
//INCr_d
		164: oUop = { `update_flags, `inc16, `d };
		165: oUop = { `inc_eof,  `nop, `null };
//DECr_e
		166: oUop = { `update_flags, `dec16, `e };
		167: oUop = { `inc_eof,  `nop, `null };
//DECDE
		168: oUop = { `update_flags, `dec16, `de };
		169: oUop = { `inc_eof,  `nop, `null };
//DECr_h
		170: oUop = { `update_flags, `dec16, `h };
		171: oUop = { `inc_eof,  `nop, `null };
//DECHL
		172: oUop = { `update_flags, `dec16, `hl };
		173: oUop = { `inc_eof,  `nop, `null };
//UNUSED
		174: oUop = { `inc_eof,  `nop, `null };
//ADDr_a
		175: oUop = { `op, `sx16r, `a       };
		176: oUop = { `update_flags, `addx16, `a };
		177: oUop = { `inc_eof, `srx16, `a  };
//ADDr_b
		178: oUop = { `op, `sx16r, `a       };
		179: oUop = { `update_flags, `addx16, `b };
		180: oUop = { `inc_eof, `srx16, `a  };
//SUBr_c
		181: oUop = { `op, `sx16r, `a       };
		182: oUop = { `update_flags, `subx16, `c      };
		183: oUop = { `inc_eof, `srx16, `a  };

//ADDr_c
		184: oUop = { `op, `sx16r, `a       };
		185: oUop = { `update_flags, `addx16, `c };
		186: oUop = { `inc_eof, `srx16, `a  };

//ADDr_d
		187: oUop = { `op, `sx16r, `a       };
		188: oUop = { `update_flags, `addx16, `d };
		189: oUop = { `inc_eof, `srx16, `a  };

//ADDr_e
		190: oUop = { `op, `sx16r, `a       };
		191: oUop = { `update_flags, `addx16, `e };
		192: oUop = { `inc_eof, `srx16, `a  };

//ADDr_h
		193: oUop = { `op, `sx16r, `a       };
		194: oUop = { `update_flags, `addx16, `h };
		195: oUop = { `inc_eof, `srx16, `a  };

//ADDr_l
		196: oUop = { `op, `sx16r, `a       };
		197: oUop = { `update_flags, `addx16, `l };
		198: oUop = { `inc_eof, `srx16, `a  };
//SUBr_d
		199: oUop = { `op, `sx16r, `a       };
		200: oUop = { `update_flags, `subx16, `d      };
		201: oUop = { `inc_eof, `srx16, `a  };
//SUBr_e
		202: oUop = { `op, `sx16r, `a       };
		203: oUop = { `update_flags, `subx16, `e      };
		204: oUop = { `inc_eof, `srx16, `a  };
//SUBr_h
		205: oUop = { `op, `sx16r, `a       };
		206: oUop = { `update_flags, `subx16, `h      };
		207: oUop = { `inc_eof, `srx16, `a  };
//SUBr_l
		208: oUop = { `op, `sx16r, `a       };
		209: oUop = { `update_flags, `subx16, `l      };
		210: oUop = { `inc_eof, `srx16, `a  };
//SUB_a
		211: oUop = { `op, `sx16r, `a       };
		212: oUop = { `update_flags, `subx16, `a      };
		213: oUop = { `inc_eof, `srx16, `a  };
//PUSHDE
		214: oUop = { `op, `dec16,  `sp  };
		215: oUop = { `op, `sma,    `sp  };
		216: oUop = { `op ,`smw,    `d   };
		217: oUop = { `op, `dec16,  `sp  };
		218: oUop = { `op ,`smw,     `e  };
		219: oUop = { `inc_eof ,`sma,`pc };
//PUSHHL
		220: oUop = { `op, `dec16,  `sp  };
		221: oUop = { `op, `sma,    `sp  };
		222: oUop = { `op ,`smw,    `h   };
		223: oUop = { `op, `dec16,  `sp  };
		224: oUop = { `op ,`smw,     `l  };
		225: oUop = { `inc_eof ,`sma,`pc };
//POPDE
		226: oUop = { `op, `sma,    `sp   };
		227: oUop = { `op ,`inc16,  `sp   };
		228: oUop = { `op ,`srm,    `e    };
		229: oUop = { `op ,`srm,    `d    };
		230: oUop = { `inc ,`inc16,  `sp  };
		231: oUop = { `eof, `sma,    `pc  };
//POPHL
		232: oUop = { `op, `sma,    `sp   };
		233: oUop = { `op ,`inc16,  `sp   };
		234: oUop = { `op ,`srm,    `l    };
		235: oUop = { `op ,`srm,    `h    };
		236: oUop = { `inc ,`inc16,  `sp  };
		237: oUop = { `eof, `sma,    `pc  };
//LDHLmr_b
		238: oUop = {`inc, `sma, `hl  };
		239: oUop = {`op, `smw, `b    };
		240: oUop = {`eof, `sma, `pc  };
//LDHLmr_c
		241: oUop = {`inc, `sma, `hl  };
		242: oUop = {`op, `smw, `c    };
		243: oUop = {`eof, `sma, `pc  };
//LDHLmr_d
		244: oUop = {`inc, `sma, `hl  };
		245: oUop = {`op, `smw, `d    };
		246: oUop = {`eof, `sma, `pc  };
//LDDEmA
		247: oUop = {`op, `sma, `de  };
		248: oUop = {`op, `smw, `a    };
		249: oUop = {`inc_eof, `sma, `pc    };
//INCr_e
    250:  oUop = { `update_flags, `inc16, `e };
		251:  oUop = { `inc_eof, `nop, `null };

//RET
		252: oUop = {`op ,`sma,  `sp   };
		253: oUop = {`op, `sx16r,  `hl };
		254: oUop = {`op, `inc16, `sp  };
		255: oUop = {`op,   `srm,   `l  };
		256: oUop = {`op,   `srm,   `h  };
		257: oUop = {`op,   `spc,   `hl  };
		258: oUop = {`op,  `srx16, `hl };
		259: oUop = {`op, `inc16, `sp  };
		260: oUop = { `eof ,`sma,  `pc   };

//PUSHAF
		261: oUop = { `op, `dec16,  `sp  };
		262: oUop = { `op, `sma,    `sp  };
		263: oUop = { `op ,`smw,    `a   };
		264: oUop = { `op, `dec16,  `sp  };
		265: oUop = { `op ,`smw,     `f  };
		266: oUop = { `inc_eof ,`sma,`pc };

//POPAF
		267: oUop = { `op, `sma,    `sp   };
		268: oUop = { `op ,`inc16,  `sp   };
		269: oUop = { `op ,`srm,    `f    };
		270: oUop = { `op ,`srm,    `a    };
		271: oUop = { `inc ,`inc16,  `sp  };
		272: oUop = { `eof, `sma,    `pc  };
//LDBCnn
		273: oUop = { `inc, `sma, `pc   };
		274: oUop = { `inc, `nop, `null };
	  275: oUop = { `op , `srm, `c    };
		276: oUop = { `inc_eof , `srm, `b    };
//INCBC
		277: oUop = { `inc_eof ,`inc16,  `bc };
//Z80 1 Byte op
    278: oUop = { `update_flags, `z801bop , `a };
		279: oUop = { `inc_eof, `nop , `null };
//LDAmm
	  280: oUop = { `inc, `sx16r,  `hl };
		281: oUop = { `inc, `sma , `pc };
		282: oUop = { `op ,`srm,    `l  };
		283: oUop = { `op ,`srm,    `h  };
		284: oUop = { `op, `sma ,   `hl };
		285: oUop = { `op, `nop ,   `null };	//remember to wait 1cc after sma
		286: oUop = { `op ,`srm,    `a  };
		287: oUop = { `op, `srx16,  `hl };
		288: oUop = { `inc_eof, `sma , `pc };
//CALLNZnn
		289: oUop = { `inc_eof_z, `dec16,  `sp  };
		290: oUop = { `inc, `sx16r,  `hl  };
		291: oUop = { `op , `srm,    `l   }; //l = MEM[pc] = literal
		292: oUop = { `inc, `srm,    `h   }; //l = MEM[pc] = literal
		293: oUop = { `op,  `sma,    `sp  };
		294: oUop = { `op,  `smw,    `pch };	//MEM[sp] = pc[7:0]
		295: oUop = { `op,  `dec16,  `sp  };
		296: oUop = { `op , `smw,    `pc  };	//MEM[sp+1] = pc[15:8]
		297: oUop = { `op , `spc,    `hl  };
		298: oUop = { `op, `srx16,  `hl  };
		299: oUop = { `eof ,`sma,   `pc   };
//DECr_b
		300:	oUop = { `update_flags, `dec16,    `b  };
		301:  oUop = { `inc_eof, `nop, `null};

//INCr_a
		302: oUop = { `update_flags, `inc16, `a };
		303:  oUop = { `inc_eof, `nop, `null};
//INCSP
		304: oUop = { `op, `inc16, `sp };  //increment SP
		305:  oUop = { `inc_eof, `nop, `null};
//DECSP
		306: oUop = { `update_flags, `dec16, `sp };
		307:  oUop = { `inc_eof, `nop, `null};
//INCr_l
		308: oUop = { `update_flags, `inc16, `l };
		309:  oUop = { `inc_eof, `nop, `null};
//DECr_l
		310: oUop = { `update_flags, `dec16, `l };
		311:  oUop = { `inc_eof, `nop, `null};
//INCr_h
    312: oUop = { `update_flags, `inc16, `h };
		313:  oUop = { `inc_eof, `nop, `null};
//ADDn
		314: oUop = { `inc, `sma, `pc   };
		315: oUop = { `op,  `nop, `null };
		316: oUop = { `op,  `srm, `x16 };
		317: oUop = { `update_flags,  `addx16, `a };
		318: oUop = { `inc_eof, `srx16, `a};
//SUBn
		319: oUop = { `inc, `sma, `pc   };
		320: oUop = { `op,  `nop, `null };
		321: oUop = { `op,  `srm, `x16 };
		322: oUop = { `update_flags,  `subx16, `a };
		323: oUop = { `inc_eof, `srx16, `a};
//CPr_c
		324: oUop = { `op,  `sx16r, `a };
		325: oUop = { `update_flags,  `subx16, `c };
		326: oUop = { `inc_eof, `nop, `null};
//LDrHLm_b
		327:  oUop = { `op,  `sma,   `hl };
		328:  oUop = { `op,  `nop,   `null };
		329:  oUop = { `op,  `srm,   `b };
		330:  oUop = { `inc_eof, `sma, `pc};
//LDrHLm_c
		331:  oUop = { `op,  `sma,   `hl };
		332:  oUop = { `op,  `nop,   `null };
		333:  oUop = { `op,  `srm,   `c };
		334:  oUop = { `inc_eof, `sma, `pc};
//LDrHLm_d
		335:  oUop = { `op,  `sma,   `hl };
		336:  oUop = { `op,  `nop,   `null };
		337:  oUop = { `op,  `srm,   `d };
		338:  oUop = { `inc_eof, `sma, `pc};
//XORHL
		339:  oUop = { `op,  `sma,   `hl   };
		340:  oUop = { `op,  `nop,   `null };
		341:  oUop = { `op,  `srm,   `x16  };
		342:  oUop = { `update_flags, `xorx16, `pc};
		343:  oUop = { `op, `srx16, `a};
		344:  oUop = { `inc_eof, `sma, `pc};
//ADCn
		345:  oUop = { `inc,  `sma,   `pc   };
		346:  oUop = { `op,  `nop,   `null };
		347:  oUop = { `op,  `srm,   `x16  };
		348:  oUop = { `op,  `addx16,   `a  };
		349:  oUop = { `update_flags,  `addx16,   `carry  };
		350:  oUop = { `inc_eof, `sma, `pc};
//ADDHLDE
		351:  oUop = { `inc,  `sx16r,   `hl   };
		352:  oUop = { `update_flags,  `addx16,   `de   };
		353:  oUop = { `eof,  `srx16,   `hl   };
//JRNCn
		354:  oUop = { `inc,  `sma,   `pc   };
		355:  oUop = { `op, `xorx16, `x16 };
		356:  oUop = { `update_flags,  `addx16,   `carry  };
		357:  oUop = { `inc_eof_nz,  `srm, `x16 };
		358:  oUop = { `eof,  `sp, `x16 };
//XORn
		359: oUop = { `inc, `sma,  `pc };
		360: oUop = { `op, `sx16r , `a };
		361: oUop = { `update_flags ,`xorx16, `idata  };
		362: oUop = { `inc_eof ,`srx16,  `a  };
//RRA
		363: oUop = { `update_flags, `rrot,  `null  };
		364: oUop = { `inc_eof, `nop,  `null  };
//FLOW_ID_INT_VBLANK
/*
        163: oUop = { `op, `ceti, `null};  //Disable interruption
        164: oUop = { `inc, `dec16,  `sp  };
        165: oUop = { `inc, `sx16r,  `hl  };
        166: oUop = { `op , `srm,    `l   }; //l = MEM[pc] = literal
        167: oUop = { `inc, `srm,    `h   }; //l = MEM[pc] = literal
        168: oUop = { `op,  `sma,    `sp  };
        169: oUop = { `op,  `smw,    `pch }; //MEM[sp] = pc[7:0]
        170: oUop = { `op,  `dec16,  `sp  };
        171: oUop = { `op , `smw,    `pc  }; //MEM[sp+1] = pc[15:8]
        172: oUop = { `op , `sx16l,    8'h40  };
        173: oUop = { `op, `srx16,  `pc  };
        174: oUop = { `inc ,`sma,   `pc   };
		*/


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
