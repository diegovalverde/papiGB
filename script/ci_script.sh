#!/bin/sh

#
# Do not allow pushing unless the memory checks are passing
#

cd sim/

#INCr_b
make clean && make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0100" pgb_cpu.log
then
	echo "Test test_INCr_b.dump passed"
else
	echo "Test test_INCr_b.dump failed"
	exit 1
fi

#DECBC
make clean && make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_DECBC.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL cafd" pgb_cpu.log
then
	echo "Test test_DECBC.dump passed"
else
	echo "Test test_DECBC.dump failed"
	exit 1
fi


make clean  >/dev/null 2>&1
echo "-I- Running simulation test1 BIOS (be patient...) "
make DUMPTYPE=none SIMFLAGS="-DSTOP_AFTER_FIRST_FRAME -DLCD_SCXY_DISABLED -DENABLE_CPU_LOG -DENABLE_GPU_LOG" >/dev/null 2>&1

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

echo "-I- Running simulation test2 Zelda Main Menu (be patient...) "

make clean && make SIMFLAGS="-DDISABLE_CPU -DLOAD_VMEM_DUMP -DVMEM_DUMP_PATH='\"resources/zelda_menu_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10000000" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/zelda_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- Running simulation test3 Tetris Main Menu (be patient...) "


make clean && make SIMFLAGS="-DDISABLE_CPU -DLOAD_VMEM_DUMP -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10010000"  >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi

echo "-I- Running Simulation test4 Tetris Main Menu Sprites..."


make clean && make SIMFLAGS="-DDISABLE_CPU  -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"'  -DOAM_DUMP_PATH='\"resources/tetris_oam_fe00_fe9f.dump\"'  -DENABLE_GPU_LOG -DENABLE_CPU_LOG -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10011100" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer_sprites_1.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- All tests passed. Pushing to git repository"
exit 0
