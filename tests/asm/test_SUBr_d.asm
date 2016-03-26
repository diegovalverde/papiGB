SECTION "sec", ROM0
DS $100
        ld  a, 50
        ld 	d, 10
        sub a, d
        ;the value expected is 40
        push af