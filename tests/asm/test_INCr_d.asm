SECTION "sec", ROM0
DS $100
        ld  d, 99
        inc d
        ;the value expected is 100
        push de
