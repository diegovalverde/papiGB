SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld  a, $00 ; 0000 0000
        ld 	e, $80 ; 1000 0000
        sub a, e
        ;Expected: A=$80, Flags Z=0, N=1, H=1, C=0
        ;AF = $8060
        push af
