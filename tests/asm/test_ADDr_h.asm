SECTION "sec", ROM0
DS $100
        ld  a, 6
        ld  h, 3
        add a, h
        ;the value expected is 9
        push af
