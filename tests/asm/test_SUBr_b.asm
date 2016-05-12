SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld sp, $FFFE
        ld  a, 0
        ld 	b, 1
        sub a, b
        ;Expected A =-1. Flags Z=0, H=0, C=0.
        ; AF = FF40
        push af
