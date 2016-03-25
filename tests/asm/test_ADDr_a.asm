SECTION "sec", ROM0
DS $100
        ld  a, 2
        add a, a
        ;the value expected is 4
        push af