SECTION "sec", ROM0
DS $100
        ld  a, 12
        ld  c, 8
        add a, c
        ;the value expected is 20
        push af
