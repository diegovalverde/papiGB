SECTION "sec", ROM0
DS $100
        ld  h, 3
        inc h
        ;the value expected is 4
        push hl
