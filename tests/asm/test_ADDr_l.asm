SECTION "sec", ROM0
DS $100
        ld  a, 8
        ld  l, 7
        add a, l
        ;the value expected is 15
        push af
