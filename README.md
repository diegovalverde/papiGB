![alt text](https://travis-ci.org/diegovalverde/papiGB.svg?branch=master)

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

Once the simulation completes, the following ASCII files are generated under the sim/ folder:

* pgb_cpu.log : Z80 macro instructions and their corresponding micro-code flows
* pgb_gpu.log:      GPU micro code dump
* generated_frames/*.ppm   : PPM representation of the video buffer frames at the time the simulation ended. (Open it with gimp)
* papi_vram_8000_8fff.dump : Memory dump for the Tile set region 0
* papi_vram_9800_9bff.dump : Memory dump for the Tile map region 0
* tb_simple_dzcpu : Simulation testbench executable

Simulations will not automatically generate a VCD dump file.
To generate a VCD dump do:

`make DUMPTYPE=vcd`

##Simulation Options
To control additional simulation options, use the SIMFLAGS flag. Valid values are:

* -DSTOP_AFTER_FIRST_FRAME : The simulation will stop once the first frame has been generated under the sim/generated_frames/ folder
* -DENABLE_CPU_LOG : Enables pgb_cpu.log generation (enabled by default)
* -DENABLE_GPU_LOG : Enables pgb_cpu.log generation (enabled by default)


Example:

The following line will stop the simulation after the first frame, will generate GPU log, but will not generate CPU log.

`make SIMFLAGS="-DSTOP_AFTER_FIRST_FRAME -DENABLE_GPU_LOG"`

##Looking at simulation results

`cd sim/`

`make view`

##Cleaning up simulation files.
This also erases the vcd and the log files!

`make clean`
