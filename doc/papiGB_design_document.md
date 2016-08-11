 <img align="Right" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Game-Boy-FL.png/1200px-Game-Boy-FL.png" alt="Game-Boy-FL.png" width=100>
 
Welcome to papiGB! 
===================


**papiGB** is an open source project  intended to replicate the behavior of the original Nintendo Game Boy.
This guide is intended to walk you through the different parts of the system, providing an overview to understand and contribute to individual project blocks.
papiGB project is hosted on github, this document has been created using StackEdit <i class="icon-provider-stackedit"></i>.

----------

### Table of contents


[TOC]

Why writing RTL  design from scratch?
------------------------------------------------------
In a word: **because it is lots of fun** <i class="icon-smile"></i>!

Besides, nothing compared to the bragging right of playing your favorite game and knowing that deep inside you understand every single signal, and clock, every multiplexer and Flip Flop such allowing Samus to make that next jump!

![enter image description here](https://i.kinja-img.com/gawker-media/image/upload/s--Xg20nBOw--/c_fit,fl_progressive,q_80,w_636/18j155mo6qfwspng.png)

Submitting issues and getting help
-------------------------------------------------

Installing the project
------------------------------
#### Project dependencies and recommended tool chain

####Cloning the repository

####Running your first simulation and checking results


> **Note:**

> - Make clean deletes all of the log files under the **/sim** folder, you may want to create a backup if you really need those for later.



Project directory structure
-------------------------------------

**papiGB** stores the design and simularton files a series of directories.

- <i class="icon-folder-open"></i> rtl/ :
- <i class="icon-folder-open"></i> tb/ :
- <i class="icon-folder-open"></i> doc/ :
- <i class="icon-folder-open"></i> sim/ :
- <i class="icon-folder-open"></i> scripts/ :
- <i class="icon-folder-open"></i> tests/ :
 - <i class="icon-folder-open"></i> /asm/ :

Running a simulation
------------------------------

In order to run a simulation the **Makefile** under the sim folder is used.

####Using the **Makefile** SIMFLAGS

The **Makefile** SIMFLAGS allows you to set the values of many flags in order to change the behavior of the simulation. the -DSIMFLAGS consists of a string which the make command passes to the icarus RTL simulator. 
For example, the following make invocation will set the CPU register B=0 at the beginning of the simulation:
> $ make SIMFLAGS=" -DREG_B=0"


- -R

The CPU: **dzCPU!**
---------------------------

The original GB CPU was an 8bit Sharp LR35902, which is sort of a Z80
processor specially modified by Nintendo. Essentially, Nintendo took some
opcodes out of the instruction set and added some opcodes of their own. The
Z80 is very similar to an 8080 processor from the early 90s, in the sense
that it has a CISC instruction set. In other words, it features lots of
complex instructions, and each individual instruction does lots of things.
Furthermore, decoding the Z80 instruction set may be a challenging task since
the instruction width varies from single BYTE instruction up to 5 BYTE
instructions. Also instructions take multiple clock cycles to execute and the
time to fetch data from main memory (SRAM) adds additional latency to
individual Z80 instructions.
The dZCPU! uses a micro-code approach to mimic the original Z80 CISC
instruction set. The following diagram illustrates the overall processor
architecture.

**Insert drawing here **

Figure 1 shows the basic blocks of the dZCPU!. Essentially, each time a Z80
macro insn is fetched from the MMU, the index to a mirco-code is obtained
from an uCode Look-up-table block. The ucode flow corresponding to that macro
instruction is executed and the next macro instruction is fetched.