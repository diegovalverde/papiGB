SECTION "sec", ROM0
DS $100
        ld sp, $FFFE
        ld  a, $02
        add a, a
        ;the value expected is 4
        push af
