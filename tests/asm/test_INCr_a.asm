SECTION "sec", ROM0
DS $100
        ld  a, 0
        inc a
        ;the value expected is 1
        push af
