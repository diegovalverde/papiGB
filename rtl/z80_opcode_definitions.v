
//  00
`define  NOP     8'h0
`define  LDBCnn  8'h1
`define  LDBCmA  8'h2
//  `define  INCBC;

//  `define  INCr_b;
//  `define  DECr_b;
//  `define  LDrn_b;
//  `define  RLCA;

//  `define  LDmmSP;
//  `define  ADDHLBC;
//  `define  LDABCm;
//  `define  DECBC;

//  `define  INCr_c;
//  `define  DECr_c;
//  `define  LDrn_c;
//  `define  RRCA;

//  10
//  `define  DJNZn;
//  `define  LDDEnn;
//  `define  LDDEmA;
//  `define  INCDE;
//  `define
//  `define  INCr_d;
//  `define  DECr_d;
//  `define  LDrn_d;
//  `define  RLA;
//  `define
//  `define  JRn;
//  `define  ADDHLDE;
//  `define  LDADEm;
//  `define  DECDE;
//  `define
//  `define  INCr_e;
//  `define  DECr_e;
//  `define  LDrn_e;
//  `define  RRA;
//  `define
//  20
    `define  JRNZn  8'h20
    `define  LDHLnn 8'h21
//  `define  LDHLIA;
//  `define  INCHL;
//  `define
//  `define  INCr_h;
//  `define  DECr_h;
//  `define  LDrn_h;
//  `define  DAA;
//  `define
//  `define  JRZn;
//  `define  ADDHLHL;
//  `define  LDAHLI;
//  `define  DECHL;
//  `define
//  `define  INCr_l;
//  `define  DECr_l;
//  `define  LDrn_l;
//  `define  CPL;
//  `define
//  30
  `define  JRNCn   8'h30
  `define  LDSPnn  8'h31
  `define  LDHLDA  8'h32
//  `define  INCSP;
//  `define
//  `define  INCHLm;
//  `define  DECHLm;
//  `define  LDHLmn;
//  `define  SCF;
//  `define
//  `define  JRCn;
//  `define  ADDHLSP;
//  `define  LDAHLD;
//  `define  DECSP;
//  `define
//  `define  INCr_a;
//  `define  DECr_a;
//  `define  LDrn_a;
//  `define  CCF;
//  `define
//  40
//  `define  LDrr_bb;
//  `define  LDrr_bc;
//  `define  LDrr_bd;
//  `define  LDrr_be;

//  `define  LDrr_bh;
//  `define  LDrr_bl;
//  `define  LDrHLm_b;
//  `define  LDrr_ba;
//  `define
//  `define  LDrr_cb;
//  `define  LDrr_cc;
//  `define  LDrr_cd;
//  `define  LDrr_ce;

//  `define  LDrr_ch;
//  `define  LDrr_cl;
//  `define  LDrHLm_c;
//  `define  LDrr_ca;
//  `define
//  50
//  `define  LDrr_db;
//  `define  LDrr_dc;
//  `define  LDrr_dd;
//  `define  LDrr_de;
//  `define
//  `define  LDrr_dh;
//  `define  LDrr_dl;
//  `define  LDrHLm_d;
//  `define  LDrr_da;
//  `define
//  `define  LDrr_eb;
//  `define  LDrr_ec;
//  `define  LDrr_ed;
//  `define  LDrr_ee;
//  `define
//  `define  LDrr_eh;
//  `define  LDrr_el;
//  `define  LDrHLm_e;
//  `define  LDrr_ea;
//  `define
//  60
//  `define  LDrr_hb;
//  `define  LDrr_hc;
//  `define  LDrr_hd;
//  `define  LDrr_he;

//  `define  LDrr_hh;
//  `define  LDrr_hl;
//  `define  LDrHLm_h;
//  `define  LDrr_ha;

//  `define  LDrr_lb;
//  `define  LDrr_lc;
//  `define  LDrr_ld;
//  `define  LDrr_le;
//  `define
//  `define  LDrr_lh;
//  `define  LDrr_ll;
//  `define  LDrHLm_l;
//  `define  LDrr_la;

//  70
//  `define  LDHLmr_b;
//  `define  LDHLmr_c;
//  `define  LDHLmr_d;
//  `define  LDHLmr_e;
//  `define
//  `define  LDHLmr_h;
//  `define  LDHLmr_l;
//  `define  HALT;
//  `define  LDHLmr_a;
//  `define
//  `define  LDrr_ab;
//  `define  LDrr_ac;
//  `define  LDrr_ad;
//  `define  LDrr_ae;
//  `define
//  `define  LDrr_ah;
//  `define  LDrr_al;
//  `define  LDrHLm_a;
//  `define  LDrr_aa;
//  `define
//  80
//  `define  ADDr_b;
//  `define  ADDr_c;
//  `define  ADDr_d;
//  `define  ADDr_e;
//  `define
//  `define  ADDr_h;
//  `define  ADDr_l;
//  `define  ADDHL;
//  `define  ADDr_a;
//  `define
//  `define  ADCr_b;
//  `define  ADCr_c;
//  `define  ADCr_d;
//  `define  ADCr_e;
//  `define
//  `define  ADCr_h;
//  `define  ADCr_l;
//  `define  ADCHL;
//  `define  ADCr_a;
//  `define
//  90
//  `define  SUBr_b;
//  `define  SUBr_c;
//  `define  SUBr_d;
//  `define  SUBr_e;
//  `define
//  `define  SUBr_h;
//  `define  SUBr_l;
//  `define  SUBHL;
//  `define  SUBr_a;
//  `define
//  `define  SBCr_b;
//  `define  SBCr_c;
//  `define  SBCr_d;
//  `define  SBCr_e;
//  `define
//  `define  SBCr_h;
//  `define  SBCr_l;
//  `define  SBCHL;
//  `define  SBCr_a;
//  `define
//  A0
//  `define  ANDr_b;
//  `define  ANDr_c;
//  `define  ANDr_d;
//  `define  ANDr_e;

//  `define  ANDr_h;
//  `define  ANDr_l;
//  `define  ANDHL;
//  `define  ANDr_a;

//  `define  XORr_b;
//  `define  XORr_c;
//  `define  XORr_d;
//  `define  XORr_e;

//  `define  XORr_h;
//  `define  XORr_l;
//  `define  XORHL;
//  `define  XORr_a;

//  B0
//  `define  ORr_b;
//  `define  ORr_c;
//  `define  ORr_d;
//  `define  ORr_e;

//  `define  ORr_h;
//  `define  ORr_l;
//  `define  ORHL;
//  `define  ORr_a;

//  `define  CPr_b;
//  `define  CPr_c;
//  `define  CPr_d;
//  `define  CPr_e;

//  `define  CPr_h;
//  `define  CPr_l;
//  `define  CPHL;
//  `define  CPr_a;
//  `define
//C0
  `define  RETNZ 8'hC0
  `define  POPBC 8'hC1
  `define  JPNZnn 8'hC2
  `define  JPnn   8'hC3

  `define  CALLNZnn  8'hC4
  `define  PUSHBC    8'hC5
  `define  ADDn      8'hC6
  `define  RST00     8'hC7

  `define  RETZ   8'hC8
  `define  RET    8'hC9
  `define  JPZnn  8'hCA
  `define  MAPcb  8'hCB

//  //  `define  CALLZnn;
//  //  `define  CALLnn;
//  //  `define  ADCn;
//  //  `define  RST08;
//  //  `define
//  D0
//  //  `define  RETNC;
//  //  `define  POPDE;
//  //  `define  JPNCnn;
//  //  `define  XX;
//  //  `define
//  //  `define  CALLNCnn;
//  //  `define  PUSHDE;
//  //  `define  SUBn;
//  //  `define  RST10;
//  //  `define
//  //  `define  RETC;
//  //  `define  RETI;
//  //  `define  JPCnn;
//  //  `define  XX;
//  //  `define
//  //  `define  CALLCnn;
//  //  `define  XX;
//  //  `define  SBCn;
//  //  `define  RST18;
//  //  `define
//  E0
//  //  `define  LDIOnA;
//  //  `define  POPHL;
//  //  `define  LDIOCA;
//  //  `define  XX;
//  //  `define
//  //  `define  XX;
//  //  `define  PUSHHL;
//  //  `define  ANDn;
//  //  `define  RST20;
//  //  `define
//  //  `define  ADDSPn;
//  //  `define  JPHL;
//  //  `define  LDmmA;
//  //  `define  XX;
//  //  `define
//  //  `define  XX;
//  //  `define  XX;
//  //  `define  XORn;
//  //  `define  RST28;
//  //  `define
//  F0
//  //  `define  LDAIOn;
//  //  `define  POPAF;
//  //  `define  LDAIOC;
//  //  `define  DI;
//  //  `define
//  //  `define  XX;
//  //  `define  PUSHAF;
//  //  `define  ORn;
//  //  `define  RST30;
//  //  `define
//  //  `define  LDHLSPn;
//  //  `define  XX;
//  //  `define  LDAmm;
//  //  `define  EI;
//  //  `define
//  //  `define  XX;
//  //  `define  XX;
//  //  `define  CPn;
//  //  `define  RST38
//  //  `define  ];
//  //  `define
//  //  `define  Z80._cbmap  =  [
//  CB00
//  //  `define  RLCr_b;
//  //  `define  RLCr_c;
//  //  `define  RLCr_d;
//  //  `define  RLCr_e;
//  //  `define
//  //  `define  RLCr_h;
//  //  `define  RLCr_l;
//  //  `define  RLCHL;
//  //  `define  RLCr_a;
//  //  `define
//  //  `define  RRCr_b;
//  //  `define  RRCr_c;
//  //  `define  RRCr_d;
//  //  `define  RRCr_e;
//  //  `define
//  //  `define  RRCr_h;
//  //  `define  RRCr_l;
//  //  `define  RRCHL;
//  //  `define  RRCr_a;
//  //  `define
//  CB10
//  //  `define  RLr_b;
//  //  `define  RLr_c;
//  //  `define  RLr_d;
//  //  `define  RLr_e;
//  //  `define
//  //  `define  RLr_h;
//  //  `define  RLr_l;
//  //  `define  RLHL;
//  //  `define  RLr_a;
//  //  `define
//  //  `define  RRr_b;
//  //  `define  RRr_c;
//  //  `define  RRr_d;
//  //  `define  RRr_e;
//  //  `define
//  //  `define  RRr_h;
//  //  `define  RRr_l;
//  //  `define  RRHL;
//  //  `define  RRr_a;
//  //  `define
//  CB20
//  //  `define  SLAr_b;
//  //  `define  SLAr_c;
//  //  `define  SLAr_d;
//  //  `define  SLAr_e;
//  //  `define
//  //  `define  SLAr_h;
//  //  `define  SLAr_l;
//  //  `define  XX;
//  //  `define  SLAr_a;
//  //  `define
//  //  `define  SRAr_b;
//  //  `define  SRAr_c;
//  //  `define  SRAr_d;
//  //  `define  SRAr_e;
//  //  `define
//  //  `define  SRAr_h;
//  //  `define  SRAr_l;
//  //  `define  XX;
//  //  `define  SRAr_a;
//  //  `define
//  CB30
//  //  `define  SWAPr_b;
//  //  `define  SWAPr_c;
//  //  `define  SWAPr_d;
//  //  `define  SWAPr_e;
//  //  `define
//  //  `define  SWAPr_h;
//  //  `define  SWAPr_l;
//  //  `define  XX;
//  //  `define  SWAPr_a;
//  //  `define
//  //  `define  SRLr_b;
//  //  `define  SRLr_c;
//  //  `define  SRLr_d;
//  //  `define  SRLr_e;
//  //  `define
//  //  `define  SRLr_h;
//  //  `define  SRLr_l;
//  //  `define  XX;
//  //  `define  SRLr_a;
//  //  `define
//  CB40
//  //  `define  BIT0b;
//  //  `define  BIT0c;
//  //  `define  BIT0d;
//  //  `define  BIT0e;
//  //  `define
//  //  `define  BIT0h;
//  //  `define  BIT0l;
//  //  `define  BIT0m;
//  //  `define  BIT0a;
//  //  `define
//  //  `define  BIT1b;
//  //  `define  BIT1c;
//  //  `define  BIT1d;
//  //  `define  BIT1e;
//  //  `define
//  //  `define  BIT1h;
//  //  `define  BIT1l;
//  //  `define  BIT1m;
//  //  `define  BIT1a;
//  //  `define
//  CB50
//  //  `define  BIT2b;
//  //  `define  BIT2c;
//  //  `define  BIT2d;
//  //  `define  BIT2e;
//  //  `define
//  //  `define  BIT2h;
//  //  `define  BIT2l;
//  //  `define  BIT2m;
//  //  `define  BIT2a;
//  //  `define
//  //  `define  BIT3b;
//  //  `define  BIT3c;
//  //  `define  BIT3d;
//  //  `define  BIT3e;
//  //  `define
//  //  `define  BIT3h;
//  //  `define  BIT3l;
//  //  `define  BIT3m;
//  //  `define  BIT3a;
//  //  `define
//  CB60
//  //  `define  BIT4b;
//  //  `define  BIT4c;
//  //  `define  BIT4d;
//  //  `define  BIT4e;
//  //  `define
//  //  `define  BIT4h;
//  //  `define  BIT4l;
//  //  `define  BIT4m;
//  //  `define  BIT4a;
//  //  `define
//  //  `define  BIT5b;
//  //  `define  BIT5c;
//  //  `define  BIT5d;
//  //  `define  BIT5e;
//  //  `define
//  //  `define  BIT5h;
//  //  `define  BIT5l;
//  //  `define  BIT5m;
//  //  `define  BIT5a;
//  //  `define
//  CB70
//  //  `define  BIT6b;
//  //  `define  BIT6c;
//  //  `define  BIT6d;
//  //  `define  BIT6e;
//  //  `define
//  //  `define  BIT6h;
//  //  `define  BIT6l;
//  //  `define  BIT6m;
//  //  `define  BIT6a;
//  //  `define
//  //  `define  BIT7b;
//  //  `define  BIT7c;
//  //  `define  BIT7d;
//  //  `define  BIT7e;
//  //  `define
//  //  `define  BIT7h;
//  //  `define  BIT7l;
//  //  `define  BIT7m;
//  //  `define  BIT7a;
//  //  `define
//  CB80
//  //  `define  RES0b;
//  //  `define  RES0c;
//  //  `define  RES0d;
//  //  `define  RES0e;
//  //  `define
//  //  `define  RES0h;
//  //  `define  RES0l;
//  //  `define  RES0m;
//  //  `define  RES0a;
//  //  `define
//  //  `define  RES1b;
//  //  `define  RES1c;
//  //  `define  RES1d;
//  //  `define  RES1e;
//  //  `define
//  //  `define  RES1h;
//  //  `define  RES1l;
//  //  `define  RES1m;
//  //  `define  RES1a;
//  //  `define
//  CB90
//  //  `define  RES2b;
//  //  `define  RES2c;
//  //  `define  RES2d;
//  //  `define  RES2e;
//  //  `define
//  //  `define  RES2h;
//  //  `define  RES2l;
//  //  `define  RES2m;
//  //  `define  RES2a;
//  //  `define
//  //  `define  RES3b;
//  //  `define  RES3c;
//  //  `define  RES3d;
//  //  `define  RES3e;
//  //  `define
//  //  `define  RES3h;
//  //  `define  RES3l;
//  //  `define  RES3m;
//  //  `define  RES3a;
//  //  `define
//  CBA0
//  //  `define  RES4b;
//  //  `define  RES4c;
//  //  `define  RES4d;
//  //  `define  RES4e;
//  //  `define
//  //  `define  RES4h;
//  //  `define  RES4l;
//  //  `define  RES4m;
//  //  `define  RES4a;
//  //  `define
//  //  `define  RES5b;
//  //  `define  RES5c;
//  //  `define  RES5d;
//  //  `define  RES5e;
//  //  `define
//  //  `define  RES5h;
//  //  `define  RES5l;
//  //  `define  RES5m;
//  //  `define  RES5a;
//  //  `define
//  CBB0
//  //  `define  RES6b;
//  //  `define  RES6c;
//  //  `define  RES6d;
//  //  `define  RES6e;
//  //  `define
//  //  `define  RES6h;
//  //  `define  RES6l;
//  //  `define  RES6m;
//  //  `define  RES6a;
//  //  `define
//  //  `define  RES7b;
//  //  `define  RES7c;
//  //  `define  RES7d;
//  //  `define  RES7e;
//  //  `define
//  //  `define  RES7h;
//  //  `define  RES7l;
//  //  `define  RES7m;
//  //  `define  RES7a;
//  //  `define
//  CBC0
//  //  `define  SET0b;
//  //  `define  SET0c;
//  //  `define  SET0d;
//  //  `define  SET0e;
//  //  `define
//  //  `define  SET0h;
//  //  `define  SET0l;
//  //  `define  SET0m;
//  //  `define  SET0a;
//  //  `define
//  //  `define  SET1b;
//  //  `define  SET1c;
//  //  `define  SET1d;
//  //  `define  SET1e;
//  //  `define
//  //  `define  SET1h;
//  //  `define  SET1l;
//  //  `define  SET1m;
//  //  `define  SET1a;
//  //  `define
//  CBD0
//  //  `define  SET2b;
//  //  `define  SET2c;
//  //  `define  SET2d;
//  //  `define  SET2e;
//  //  `define
//  //  `define  SET2h;
//  //  `define  SET2l;
//  //  `define  SET2m;
//  //  `define  SET2a;
//  //  `define
//  //  `define  SET3b;
//  //  `define  SET3c;
//  //  `define  SET3d;
//  //  `define  SET3e;
//  //  `define
//  //  `define  SET3h;
//  //  `define  SET3l;
//  //  `define  SET3m;
//  //  `define  SET3a;
//  //  `define
//  CBE0
//  //  `define  SET4b;
//  //  `define  SET4c;
//  //  `define  SET4d;
//  //  `define  SET4e;
//  //  `define
//  //  `define  SET4h;
//  //  `define  SET4l;
//  //  `define  SET4m;
//  //  `define  SET4a;
//  //  `define
//  //  `define  SET5b;
//  //  `define  SET5c;
//  //  `define  SET5d;
//  //  `define  SET5e;
//  //  `define
//  //  `define  SET5h;
//  //  `define  SET5l;
//  //  `define  SET5m;
//  //  `define  SET5a;
//  //  `define
//  CBF0
//  //  `define  SET6b;
//  //  `define  SET6c;
//  //  `define  SET6d;
//  //  `define  SET6e;
//  //  `define
//  //  `define  SET6h;
//  //  `define  SET6l;
//  //  `define  SET6m;
//  //  `define  SET6a;
//  //  `define
//  //  `define  SET7b;
//  //  `define  SET7c;
//  //  `define  SET7d;
//  //  `define  SET7e;
//  //  `define
//  //  `define  SET7h;
//  //  `define  SET7l;
//  //  `define  SET7m;
//  //  `define  SET7a;

//flags
`define flag_z 7  //zero
`define flag_n 6  //neg
`define flag_h 5  //half carry
`define flag_c 4  //carry

//Prefixed
`define op      4'b0000
`define inc_eof 4'b1100
`define inc     4'b1000
`define inc_eof_z 4'b1101
`define eof     4'b0100
`define pred_z  4'b0001
`define eof_z   4'b0101
`define eof_nz  4'b0110

`define nop      4'h0
`define sma      4'h1
`define srm      4'h2
`define jcb      4'h3
`define z801bop  4'h4
`define smw      4'h5
`define dec16    4'h6
`define bit      4'h7
`define addx16   4'h8
`define spc      4'h9
`define sx16r    4'ha
`define sx8r     4'hb
`define inc16    4'hc

`define null 4'h0



`define b     4'h0
`define c     4'h1
`define d     4'h2
`define e     4'h3
`define h     4'h4
`define l     4'h5
`define hl    4'h6
`define a     4'h7
`define pc    4'h8
`define sp    4'h9
`define flags 4'h9
`define spl   4'ha
`define sph   4'hb
`define x8    4'hc
`define x16   4'hd


`define DZCPU_AFTER_RESET 0
`define DZCPU_START_FLOW  1
`define DZCPU_RUN_FLOW    2
`define DZCPU_END_FLOW    3


