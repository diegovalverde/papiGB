SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld sp, $FFFE
        ld a, $15
        ld bc, $1587
        or a,a ;borra las banderas

        ld c, c
        push bc

        ;the value expected is $1587
