SECTION "sec", ROM0
DS $100
	ld sp, $FFFE
        ld  b, 0
        ld  c, 0
        inc b
        ; b shall be 1
        push bc
