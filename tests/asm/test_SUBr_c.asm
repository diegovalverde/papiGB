SECTION "sec", ROM0
DS $100
        ld  a, 50
        ld 	c, 62
        sub a, c
        ;the value expected is -12
        push bc