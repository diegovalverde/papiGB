SECTION "sec", ROM0
DS $100
        ld sp, $FFFE
        ld  a, $f0
        ld  e, $10
        add a, e
        ;the value expected is $00 with flags Z=1 
        push af
