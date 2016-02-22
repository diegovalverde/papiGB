#!/bin/sh

#
# Do not allow pushing unless the memory checks are passing
#

cd sim/
make clean  >/dev/null 2>&1
echo "-I- Running simulation (be patient...) "
make DUMPTYPE=none SIMFLAGS="-DSTOP_AFTER_FIRST_FRAME -DLCD_SCXY_DISABLED" >/dev/null 2>&1

echo "-I- Checking Video RAM TileSet region 8000-8fff "

if ! cmp papi_vram_8000_8fff.dump reference/bios_vram_8000_8ffff.dump
then
	echo "-E- Video RAM Tile Region 8000-8fff mismatch"
	exit 1
fi


echo "-I- Checking Video RAM TileSet region 9800-9bff "

if ! cmp papi_vram_9800_9bff.dump reference/bios_vram_9800_9bff.dump
then
	echo "-E- Video RAM Tile Region 9800-9bfff mismatch"
	exit 1 
fi

echo "-I- All tests passed. Pushing to git repository"
exit 0
