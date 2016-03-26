SECTION "sec", ROM0
DS $100
        ld  c, 9
        inc c
        ;the value expected is 10
        push bc
