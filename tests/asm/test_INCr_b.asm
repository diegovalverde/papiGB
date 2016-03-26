SECTION "sec", ROM0
DS $100
	ld sp, $FFFE
        ld  b, 0
        ld  c, 0
        inc b
        ;the value expected is 1
        push bc
