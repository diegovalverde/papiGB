SECTION "sec", ROM0
DS $100
        ld  a, 20
        ld 	l, 15
        sub a, l
        ;the value expected is 5
        push af