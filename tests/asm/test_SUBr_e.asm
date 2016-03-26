SECTION "sec", ROM0
DS $100
        ld  a, 23
        ld 	e, 3
        sub a, e
        ;the value expected is 20
        push af