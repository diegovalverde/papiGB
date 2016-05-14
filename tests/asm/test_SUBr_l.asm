SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld  a, $00
        ld 	l, $0B
        sub a, l
        ;Expected: A = $F5, Flags Z=0, N=1, H=0, C=0
        ; AF = $F540
        push af
