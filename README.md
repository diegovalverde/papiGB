# papiGB
Game Boy Classic fully functional FPGA implementation from scratch

###Requirements

`sudo apt-get install iverilog gtkwave`


##Compiling code
`cd sim/`

`make compile`

##Running a simulation

`cd sim/`

`make run`

Once the simulation completes successfuly, the following ASCII files are generated under the sim/ folder:

* pgb.log : Z80 macro instructions and their corresponding micro-code flows
* papi_vram_8000_8fff.dump : Memory dump for the Tile set region 0
* papi_vram_9800_9bff.dump : Memory dump for the Tile map region 0
* tb_simple_dzcpu : Simulation testbench executable

Simulations automatically generate a VCD dump file. To suppress the dump file (faster simulation) do:

`make DUMPTYPE=none`


##Looking at simulation results

`cd sim/`

`make view`

##Cleaning up simulation files.
This also erases the vcd and the log files!

`make clean`
