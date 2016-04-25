SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld  sp, $FFFE
        ld  a, $FF
        inc a
        ; a = 0, Flags Z=1
        push af
