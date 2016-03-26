SECTION "sec", ROM0
DS $100
        ld  a, 23
        ld 	h, 3
        sub a, h
        ;the value expected is 20
        push af