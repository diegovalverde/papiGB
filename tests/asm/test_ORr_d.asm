SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld sp, $FFFE
        ld  a, $00
        ld  d, $ff
        or a, d
        ;the value expected is $67 with flasgs Z=1
        ;af=$ff00
        push af
