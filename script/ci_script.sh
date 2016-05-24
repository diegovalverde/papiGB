#!/bin/sh

#
# Do not allow pushing unless the memory checks are passing
#

cd sim/

#ANDr_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2020" pgb_cpu.log
then
	echo "Test test_ANDr_a.dump passed"
else
	echo "Test test_ANDr_a.dump failed"
	exit 1
fi

#ANDr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2820" pgb_cpu.log
then
	echo "Test test_ANDr_b.dump passed"
else
	echo "Test test_ANDr_b.dump failed"
	exit 1
fi

#ANDr_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 5220" pgb_cpu.log
then
	echo "Test test_ANDr_c.dump passed"
else
	echo "Test test_ANDr_c.dump failed"
	exit 1
fi

#ANDr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6720" pgb_cpu.log
then
	echo "Test test_ANDr_d.dump passed"
else
	echo "Test test_ANDr_d.dump failed"
	exit 1
fi

#ANDr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 00a0" pgb_cpu.log
then
	echo "Test test_ANDr_e.dump passed"
else
	echo "Test test_ANDr_e.dump failed"
	exit 1
fi

#ADDr_h
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2e20" pgb_cpu.log
then
	echo "Test test_ADDr_h.dump passed"
else
	echo "Test test_ADDr_h.dump failed"
	exit 1
fi



#ADDr_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9020" pgb_cpu.log
then
	echo "Test test_ADDr_l.dump passed"
else
	echo "Test test_ADDr_l.dump failed"
	exit 1
fi

#ADDr_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1420" pgb_cpu.log
then
	echo "Test test_ADDr_c.dump passed"
else
	echo "Test test_ADDr_c.dump failed"
	exit 1
fi

#ADDr_e
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0090" pgb_cpu.log
then
	echo "Test test_ADDr_e.dump passed"
else
	echo "Test test_ADDr_e.dump failed"
	exit 1
fi


#INCr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0100" pgb_cpu.log
then
	echo "Test test_INCr_b.dump passed"
else
	echo "Test test_INCr_b.dump failed"
	exit 1
fi

#DECBC
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_DECBC.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL cafd" pgb_cpu.log
then
	echo "Test test_DECBC.dump passed"
else
	echo "Test test_DECBC.dump failed"
	exit 1
fi


#DECDE
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_DECDE.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL cafd" pgb_cpu.log
then
	echo "Test test_DECDE.dump passed"
else
	echo "Test test_DECDE.dump failed"
	exit 1
fi

#DECHL
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_DECHL.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL cafd" pgb_cpu.log
then
	echo "Test test_DECHL.dump passed"
else
	echo "Test test_DECHL.dump failed"
	exit 1
fi

#DECSP
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_DECSP.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL caf9" pgb_cpu.log
then
	echo "Test test_DECSP.dump passed"
else
	echo "Test test_DECSP.dump failed"
	exit 1
fi

#INCBC
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCBC.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL cafe" pgb_cpu.log
then
	echo "Test test_INCBC.dump passed"
else
	echo "Test test_INCBC.dump failed"
	exit 1
fi

#INCDE
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCDE.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0000" pgb_cpu.log
then
	echo "Test test_INCDE.dump passed"
else
	echo "Test test_INCDE.dump failed"
	exit 1
fi

#INCHL
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCHL.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0100" pgb_cpu.log
then
	echo "Test test_INCHL.dump passed"
else
	echo "Test test_INCHL.dump failed"
	exit 1
fi

#INCSP
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_INCSP.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL ffff" pgb_cpu.log
then
	echo "Test test_INCSP.dump passed"
else
	echo "Test test_INCSP.dump failed"
	exit 1
fi

#ORr_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8000" pgb_cpu.log
then
	echo "Test test_ORr_a.dump passed"
else
	echo "Test test_ORr_a.dump failed"
	exit 1
fi

#ORr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL bb00" pgb_cpu.log
then
	echo "Test test_ORr_b.dump passed"
else
	echo "Test test_ORr_b.dump failed"
	exit 1
fi

#ORr_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL ff00" pgb_cpu.log
then
	echo "Test test_ORr_c.dump passed"
else
	echo "Test test_ORr_c.dump failed"
	exit 1
fi

#ORr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0080" pgb_cpu.log
then
	echo "Test test_ORr_d.dump passed"
else
	echo "Test test_ORr_d.dump failed"
	exit 1
fi

#ORr_e
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1100" pgb_cpu.log
then
	echo "Test test_ORr_e.dump passed"
else
	echo "Test test_ORr_e.dump failed"
	exit 1
fi


#ORr_h
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL ef00" pgb_cpu.log
then
	echo "Test test_ORr_h.dump passed"
else
	echo "Test test_ORr_h.dump failed"
	exit 1
fi

#ORr_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ORr_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0080" pgb_cpu.log
then
	echo "Test test_ORr_l.dump passed"
else
	echo "Test test_ORr_l.dump failed"
	exit 1
fi

#XORr_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0080" pgb_cpu.log
then
	echo "Test test_XORr_a.dump passed"
else
	echo "Test test_XORr_a.dump failed"
	exit 1
fi

#XORr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9300" pgb_cpu.log
then
	echo "Test test_XORr_b.dump passed"
else
	echo "Test test_XORr_b.dump failed"
	exit 1
fi

#XORr_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL bd00" pgb_cpu.log
then
	echo "Test test_XORr_c.dump passed"
else
	echo "Test test_XORr_c.dump failed"
	exit 1
fi

#XORr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0080" pgb_cpu.log
then
	echo "Test test_XORr_d.dump passed"
else
	echo "Test test_XORr_d.dump failed"
	exit 1
fi

#XORr_e
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0100" pgb_cpu.log
then
	echo "Test test_XORr_e.dump passed"
else
	echo "Test test_XORr_e.dump failed"
	exit 1
fi

#XORr_h
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 4f00" pgb_cpu.log
then
	echo "Test test_XORr_h.dump passed"
else
	echo "Test test_XORr_h.dump failed"
	exit 1
fi

#XORr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_XORr_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0080" pgb_cpu.log
then
	echo "Test test_XORr_l.dump passed"
else
	echo "Test test_XORr_l.dump failed"
	exit 1
fi

#LDHLDA
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLDA.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1515" pgb_cpu.log
then
	echo "Test test_LDHLDA.dump passed"
else
	echo "Test test_LDHLDA.dump failed"
	exit 1
fi

#LDIOCA
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDIOCA.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8525" pgb_cpu.log
then
	echo "Test test_LDIOCA.dump passed"
else
	echo "Test test_LDIOCA.dump failed"
	exit 1
fi

#LDHLmr_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9594" pgb_cpu.log
then
	echo "Test test_LDHLmr_a.dump passed"
else
	echo "Test test_LDHLmr_a.dump failed"
	exit 1
fi

#LDHLmr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 504f" pgb_cpu.log
then
	echo "Test test_LDHLmr_b.dump passed"
else
	echo "Test test_LDHLmr_b.dump failed"
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

make clean >/dev/null 2>&1
make SIMFLAGS="-DDISABLE_CPU -DLOAD_VMEM_DUMP -DVMEM_DUMP_PATH='\"resources/zelda_menu_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10000000" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/zelda_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- Running simulation test3 Tetris Main Menu (be patient...) "


make clean >/dev/null 2>&1
make SIMFLAGS="-DDISABLE_CPU -DLOAD_VMEM_DUMP -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10010000"  >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi

echo "-I- Running Simulation test4 Tetris Main Menu Sprites..."


make clean >/dev/null 2>&1
make SIMFLAGS="-DDISABLE_CPU  -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"'  -DOAM_DUMP_PATH='\"resources/tetris_oam_fe00_fe9f.dump\"'  -DENABLE_GPU_LOG -DENABLE_CPU_LOG -DSTOP_AFTER_FIRST_FRAME -DFORCE_LCDC=8\'b10011100" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer_sprites_1.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- All tests passed. "
exit 0
