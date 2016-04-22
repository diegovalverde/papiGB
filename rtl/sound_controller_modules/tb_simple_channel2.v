//Dummy tb for sound channel 4.
//Tb is only  for debug this module. 

`timescale 1ns / 1ps
`include "aDefinitions.v"
`include "collaterals.v"
`include "SoundControllerChannel2.v"

module tb;
  
  reg clk;
  reg rst;
  wire [4:0] out;

  reg [15:0] sound2_regL;
  reg [15:0] sound2_regH;
  
  always begin
    #`CLOCK_CYCLE clk = ~clk;
  end
  
  SoundCtrlChannel2 # () scc2 (
    .iClock(clk),
    .iReset(rst),
    .iREG_SOUND2CNT_L(sound2_regL),
    .iREG_SOUND2CNT_H(sound2_regH),
    .oOut(out)
  );

  initial begin
    $dumpfile("dump_sound_channel2.vcd");
    $dumpvars();

    $monitor ("time \t %0d \t sound2 \t %0d", $time, out);
    clk = 0;
    rst = 1'b0;
    #10 rst = 1'b1;

    sound2_regL = 16'hF71F; 
    sound2_regH = 16'h03BC; //Freq =400Hz 
    #20; 
    rst = 1'b0;
    #100000000;

    sound2_regL = 16'hA31F; 
    sound2_regH = 16'hC6F9; //Freq =400Hz 
    #20;
    sound2_regH = 16'h46F9; //Freq =400Hz 
    #100000000;

    sound2_regL = 16'h1F1F; 
    sound2_regH = 16'h82E2; //Freq =400Hz 
    #20;
    sound2_regH = 16'h02E2; //Freq =400Hz 
    #50000000;

    sound2_regL = 16'h171F; 
    #50000000;

    $finish;
  end
  
endmodule
