SECTION "sec", ROM0
DS $100
        ld  a, 5
        ld  e, 5
        add a, e
        ;the value expected is 10
        push af
