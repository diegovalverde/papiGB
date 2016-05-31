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

#ANDr_h
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL a020" pgb_cpu.log
then
	echo "Test test_ANDr_h.dump passed"
else
	echo "Test test_ANDr_h.dump failed"
	exit 1
fi

#ANDr_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ANDr_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2120" pgb_cpu.log
then
	echo "Test test_ANDr_l.dump passed"
else
	echo "Test test_ANDr_l.dump failed"
	exit 1
fi


#ADDn
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDn.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 00b0" pgb_cpu.log
then
	echo "Test test_ADDn.dump passed"
else
	echo "Test test_ADDn.dump failed"
	exit 1
fi


#ADDr_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0400" pgb_cpu.log
then
	echo "Test test_ADDr_a.dump passed"
else
	echo "Test test_ADDr_a.dump failed"
	exit 1
fi

#ADDr_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 00b0" pgb_cpu.log
then
	echo "Test test_ADDr_b.dump passed"
else
	echo "Test test_ADDr_b.dump failed"
	exit 1
fi

#ADDr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_ADDr_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1030" pgb_cpu.log
then
	echo "Test test_ADDr_d.dump passed"
else
	echo "Test test_ADDr_d.dump failed"
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

#LDHLmr_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL f2f1" pgb_cpu.log
then
	echo "Test test_LDHLmr_c.dump passed"
else
	echo "Test test_LDHLmr_c.dump failed"
	exit 1
fi

#LDHLmr_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1110" pgb_cpu.log
then
	echo "Test test_LDHLmr_d.dump passed"
else
	echo "Test test_LDHLmr_d.dump failed"
	exit 1
fi

#LDHLmr_e
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2322" pgb_cpu.log
then
	echo "Test test_LDHLmr_e.dump passed"
else
	echo "Test test_LDHLmr_e.dump failed"
	exit 1
fi

#LDHLmr_h
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL ffff" pgb_cpu.log
then
	echo "Test test_LDHLmr_h.dump passed"
else
	echo "Test test_LDHLmr_h.dump failed"
	exit 1
fi

#LDHLmr_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDHLmr_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL fdfc" pgb_cpu.log
then
	echo "Test test_LDHLmr_l.dump passed"
else
	echo "Test test_LDHLmr_l.dump failed"
	exit 1
fi

#LDIOnA
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDIOnA.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3534" pgb_cpu.log
then
	echo "Test test_LDIOnA.dump passed"
else
	echo "Test test_LDIOnA.dump failed"
	exit 1
fi

#LDADEm
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDADEm.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2000" pgb_cpu.log
then
	echo "Test test_LDADEm.dump passed"
else
	echo "Test test_LDADEm.dump failed"
	exit 1
fi

#LDABCm
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDABCm.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 5800" pgb_cpu.log
then
	echo "Test test_LDABCm.dump passed"
else
	echo "Test test_LDABCm.dump failed"
	exit 1
fi

#LDrHLm_a
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_a.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6000" pgb_cpu.log
then
	echo "Test test_LDrHLm_a.dump passed"
else
	echo "Test test_LDrHLm_a.dump failed"
	exit 1
fi

#LDrHLm_b
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_b.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 4800" pgb_cpu.log
then
	echo "Test test_LDrHLm_b.dump passed"
else
	echo "Test test_LDrHLm_b.dump failed"
	exit 1
fi

#LDrHLm_c
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_c.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0048" pgb_cpu.log
then
	echo "Test test_LDrHLm_c.dump passed"
else
	echo "Test test_LDrHLm_c.dump failed"
	exit 1
fi

#LDrHLm_d
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_d.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8700" pgb_cpu.log
then
	echo "Test test_LDrHLm_d.dump passed"
else
	echo "Test test_LDrHLm_d.dump failed"
	exit 1
fi

#LDrHLm_e
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_e.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 0087" pgb_cpu.log
then
	echo "Test test_LDrHLm_e.dump passed"
else
	echo "Test test_LDrHLm_e.dump failed"
	exit 1
fi


#LDrHLm_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_l.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL ff37" pgb_cpu.log
then
	echo "Test test_LDrHLm_l.dump passed"
else
	echo "Test test_LDrHLm_l.dump failed"
	exit 1
fi

#LDrHLm_l
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrHLm_h.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 37fd" pgb_cpu.log
then
	echo "Test test_LDrHLm_h.dump passed"
else
	echo "Test test_LDrHLm_h.dump failed"
	exit 1
fi

#LDrr_ab
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ab.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 5500" pgb_cpu.log
then
	echo "Test test_LDrr_ab.dump passed"
else
	echo "Test test_LDrr_ab.dump failed"
	exit 1
fi

#LDrr_aa
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_aa.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1200" pgb_cpu.log
then
	echo "Test test_LDrr_aa.dump passed"
else
	echo "Test test_LDrr_aa.dump failed"
	exit 1
fi

#LDrr_ac
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ac.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9000" pgb_cpu.log
then
	echo "Test test_LDrr_ac.dump passed"
else
	echo "Test test_LDrr_ac.dump failed"
	exit 1
fi

#LDrr_ad
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ad.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1300" pgb_cpu.log
then
	echo "Test test_LDrr_ad.dump passed"
else
	echo "Test test_LDrr_ad.dump failed"
	exit 1
fi

#LDrr_ae
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ae.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3300" pgb_cpu.log
then
	echo "Test test_LDrr_ae.dump passed"
else
	echo "Test test_LDrr_ae.dump failed"
	exit 1
fi

#LDrr_ah
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ah.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 7700" pgb_cpu.log
then
	echo "Test test_LDrr_ah.dump passed"
else
	echo "Test test_LDrr_ah.dump failed"
	exit 1
fi

#LDrr_al
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_al.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2600" pgb_cpu.log
then
	echo "Test test_LDrr_al.dump passed"
else
	echo "Test test_LDrr_al.dump failed"
	exit 1
fi

#LDrr_bb
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_bb.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9745" pgb_cpu.log
then
	echo "Test test_LDrr_bb.dump passed"
else
	echo "Test test_LDrr_bb.dump failed"
	exit 1
fi

#LDrr_bc
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_bc.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 9595" pgb_cpu.log
then
	echo "Test test_LDrr_bc.dump passed"
else
	echo "Test test_LDrr_bc.dump failed"
	exit 1
fi

#LDrr_bd
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_bd.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 4097" pgb_cpu.log
then
	echo "Test test_LDrr_bd.dump passed"
else
	echo "Test test_LDrr_bd.dump failed"
	exit 1
fi

#LDrr_be
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_be.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3597" pgb_cpu.log
then
	echo "Test test_LDrr_be.dump passed"
else
	echo "Test test_LDrr_be.dump failed"
	exit 1
fi

#LDrr_bh
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_bh.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1797" pgb_cpu.log
then
	echo "Test test_LDrr_bh.dump passed"
else
	echo "Test test_LDrr_bh.dump failed"
	exit 1
fi

#LDrr_bl
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_bl.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6597" pgb_cpu.log
then
	echo "Test test_LDrr_bl.dump passed"
else
	echo "Test test_LDrr_bl.dump failed"
	exit 1
fi

#LDrr_ba
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ba.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1597" pgb_cpu.log
then
	echo "Test test_LDrr_ba.dump passed"
else
	echo "Test test_LDrr_ba.dump failed"
	exit 1
fi

#LDrr_cb
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_cb.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8888" pgb_cpu.log
then
	echo "Test test_LDrr_cb.dump passed"
else
	echo "Test test_LDrr_cb.dump failed"
	exit 1
fi

#LDrr_cc
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_cc.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1587" pgb_cpu.log
then
	echo "Test test_LDrr_cc.dump passed"
else
	echo "Test test_LDrr_cc.dump failed"
	exit 1
fi

#LDrr_cd
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_cd.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8871" pgb_cpu.log
then
	echo "Test test_LDrr_cd.dump passed"
else
	echo "Test test_LDrr_cd.dump failed"
	exit 1
fi


#LDrr_ce
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ce.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3671" pgb_cpu.log
then
	echo "Test test_LDrr_ce.dump passed"
else
	echo "Test test_LDrr_ce.dump failed"
	exit 1
fi

#LDrr_ch
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ch.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3652" pgb_cpu.log
then
	echo "Test test_LDrr_ch.dump passed"
else
	echo "Test test_LDrr_ch.dump failed"
	exit 1
fi

#LDrr_cl
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_cl.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3612" pgb_cpu.log
then
	echo "Test test_LDrr_cl.dump passed"
else
	echo "Test test_LDrr_cl.dump failed"
	exit 1
fi

#LDrr_ca
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ca.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3615" pgb_cpu.log
then
	echo "Test test_LDrr_ca.dump passed"
else
	echo "Test test_LDrr_ca.dump failed"
	exit 1
fi

#LDrr_de
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_de.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3434" pgb_cpu.log
then
	echo "Test test_LDrr_de.dump passed"
else
	echo "Test test_LDrr_de.dump failed"
	exit 1
fi

#LDrr_db
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_db.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1182" pgb_cpu.log
then
	echo "Test test_LDrr_db.dump passed"
else
	echo "Test test_LDrr_db.dump failed"
	exit 1
fi

#LDrr_dc
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_dc.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 4734" pgb_cpu.log
then
	echo "Test test_LDrr_dc.dump passed"
else
	echo "Test test_LDrr_dc.dump failed"
	exit 1
fi

#LDrr_dd
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_dd.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 5234" pgb_cpu.log
then
	echo "Test test_LDrr_dd.dump passed"
else
	echo "Test test_LDrr_dd.dump failed"
	exit 1
fi

#LDrr_dh
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_dh.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3334" pgb_cpu.log
then
	echo "Test test_LDrr_dh.dump passed"
else
	echo "Test test_LDrr_dh.dump failed"
	exit 1
fi

#LDrr_dl
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_dl.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6634" pgb_cpu.log
then
	echo "Test test_LDrr_dl.dump passed"
else
	echo "Test test_LDrr_dl.dump failed"
	exit 1
fi

#LDrr_da
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_da.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 1513" pgb_cpu.log
then
	echo "Test test_LDrr_da.dump passed"
else
	echo "Test test_LDrr_da.dump failed"
	exit 1
fi

#LDrr_la
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_la.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 2115" pgb_cpu.log
then
	echo "Test test_LDrr_la.dump passed"
else
	echo "Test test_LDrr_la.dump failed"
	exit 1
fi

#LDrr_lb
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_lb.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6460" pgb_cpu.log
then
	echo "Test test_LDrr_lb.dump passed"
else
	echo "Test test_LDrr_lb.dump failed"
	exit 1
fi

#LDrr_lc
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_lc.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6470" pgb_cpu.log
then
	echo "Test test_LDrr_lc.dump passed"
else
	echo "Test test_LDrr_lc.dump failed"
	exit 1
fi

#LDrr_ld
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ld.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6480" pgb_cpu.log
then
	echo "Test test_LDrr_ld.dump passed"
else
	echo "Test test_LDrr_ld.dump failed"
	exit 1
fi

#LDrr_le
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_le.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6485" pgb_cpu.log
then
	echo "Test test_LDrr_le.dump passed"
else
	echo "Test test_LDrr_le.dump failed"
	exit 1
fi

#LDrr_lh
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_lh.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 6464" pgb_cpu.log
then
	echo "Test test_LDrr_lh.dump passed"
else
	echo "Test test_LDrr_lh.dump failed"
	exit 1
fi

#LDrr_ll
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ll.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 7902" pgb_cpu.log
then
	echo "Test test_LDrr_ll.dump passed"
else
	echo "Test test_LDrr_ll.dump failed"
	exit 1
fi

#LDrr_eb
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_eb.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3647" pgb_cpu.log
then
	echo "Test test_LDrr_eb.dump passed"
else
	echo "Test test_LDrr_eb.dump failed"
	exit 1
fi

#LDrr_ec
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ec.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 3689" pgb_cpu.log
then
	echo "Test test_LDrr_ec.dump passed"
else
	echo "Test test_LDrr_ec.dump failed"
	exit 1
fi

#LDrr_ed
make clean >/dev/null 2>&1
make SIMFLAGS="-DENABLE_CPU_LOG -DLOAD_CARTRIDGE_FROM_FILE -DCARTRIGDE_DUMP_PATH='\"../tests/asm/test_LDrr_ed.dump\"' -DSKIP_BIOS -DSIMULATION_TIME_OUT=1000" >/dev/null 2>&1

if grep -q "TEST_RET_VAL 8989" pgb_cpu.log
then
	echo "Test test_LDrr_ed.dump passed"
else
	echo "Test test_LDrr_ed.dump failed"
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
make SIMFLAGS="-DDISABLE_CPU -DLOAD_VMEM_DUMP -DVMEM_DUMP_PATH='\"resources/zelda_menu_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DREG_LCDC=8\'b10000000 -DREG_BGP=8\'h27" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/zelda_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- Running simulation test3 Tetris Main Menu (be patient...) "


make clean >/dev/null 2>&1
make SIMFLAGS="-DDISABLE_CPU -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"' -DSTOP_AFTER_FIRST_FRAME -DREG_LCDC=8\'b10010000 -DREG_BGP=8\'h27"  >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi

echo "-I- Running Simulation test4 Tetris Main Menu Sprites..."


make clean >/dev/null 2>&1
make SIMFLAGS="-DDISABLE_CPU  -DVMEM_DUMP_PATH='\"resources/tetris_vmem_8000_9fff.dump\"'  -DOAM_DUMP_PATH='\"resources/tetris_oam_fe00_fe9f.dump\"'  -DENABLE_GPU_LOG -DENABLE_CPU_LOG -DSTOP_AFTER_FIRST_FRAME -DREG_LCDC=8\'b10011100 -DREG_BGP=8\'h27" >/dev/null 2>&1

echo "-I- Checking Frame buffer PPM "

if ! cmp generated_frames/frame.0.ppm reference/tetris_menu_video_buffer_sprites_1.ppm
then
        echo "-E- Video PPM mismatch"
        exit 1
fi


echo "-I- All tests passed. "
exit 0
