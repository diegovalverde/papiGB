SECTION "sec", ROM0
DS $100
        ld sp, $FFFE
        ld  a, $ff
        ld  d, $11
        add a, d
        ;the value expected is D17 Hex-$11 with flags C=1 H=1
        push af
