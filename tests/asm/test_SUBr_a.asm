SECTION "sec", ROM0
DS $100
        ld  a, 20
        sub a
        ;the value expected is 0
        ;push af
