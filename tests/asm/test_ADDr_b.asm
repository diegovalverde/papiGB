SECTION "sec", ROM0
DS $100
        ld  a, 5
        ld  b, 7
        add a, b
        ;the value expected is 12
        push af
