SECTION "sec", ROM0
DS $100
        ld  a, $81
        ld  l, $0F
        add a, l
        ;the value expected is $90 with flags H=1
        push af
