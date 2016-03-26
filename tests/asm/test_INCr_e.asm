SECTION "sec", ROM0
DS $100
        ld  e, 5
        inc e
        ;the value expected is 6
        push de
