SECTION "sec", ROM0
DS $100
        ld  l, 33
        inc l
        ;the value expected is 34
        push hl
