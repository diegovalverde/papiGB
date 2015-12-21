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

Simulations automatically generate a VCD dump file. To suppress the dump file (faster simulation) do:

`make DUMPTYPE=none`


##Looking at simulation results

`cd sim/`

`make view`

##Cleaning up simulation files. This also erases the vcd and the log files!

`make clean`
