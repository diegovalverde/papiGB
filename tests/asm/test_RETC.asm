SECTION "sec", ROM0
DS $100
        jp  $200
DS $100
        ld sp, $FFFE
        ld hl, end_label
        ld  a, $ff
        add $01
        jp  c, carry_label
        jr  end_label
carry_label:
        ld  a, $71
        jp  hl
end_label:
        ;expected $71b0
        push af
