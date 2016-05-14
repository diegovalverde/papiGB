SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld  a, $A
        ld 	h, 0
        sub a, h
        ;Expected: A = $0A, Flags Z=0, N=1, H=1, C=1
        ; AF = $0A70
        push af
