SECTION "sec", ROM0
DS $100
        ld  a, 10
        ld  d, 10
        add a, d
        ;the value expected is 20
        push af
