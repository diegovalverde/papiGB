SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld sp, $dff3
        ld a, $ff
        sub a, $1
        ld hl, $dff1
        call nz, label
        ld a, $cc
label:
        ld   a, [hl+]
        ld   b, [hl]
        ld c, a

        ;the value expected is bc=$0208
        push bc
