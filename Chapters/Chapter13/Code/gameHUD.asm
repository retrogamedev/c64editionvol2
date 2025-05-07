//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameHUD
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"

//==============================================================================
// Constants

.const HUDEnergyMax                 = 7
.const HUDDrinksMax                 = 9
.const HUDTowelsMax                 = 9
.const HUDScoreIncrease             = 5
.const HUDEnergyColumn              = 1
.const HUDBarCustomersColumn        = 11
.const HUDLoungersCustomersColumn   = 13
.const HUDNumDrinksColumn           = 17
.const HUDNumTowelsColumn           = 21
.const HUDDrinkCarryingColumn       = 9
.const HUDDrinkCarryingChar         = 81
.const HUDDrinkNotCarryingChar      = 104
.const HUDScoreColumn1              = 29
.const HUDScoreColumn2              = 30
.const HUDScoreColumn3              = 31
.const HUDHiScoreColumn1            = 36
.const HUDHiScoreColumn2            = 37
.const HUDHiScoreColumn3            = 38
.const HUDRow                       = 2
.const HUDStartColumn               = 10
.const HUDStartRow                  = 24

//==============================================================================
// Variables

bHudEnergy:             .byte HUDEnergyMax
bHudBarCustomers:       .byte 0
bHudLoungersCustomers:  .byte 0
bHudNumDrinks:          .byte HUDDrinksMax
bHudNumTowels:          .byte HUDTowelsMax
bHudDrinkCarrying:      .byte WHITE
wHudScore:              .word 0
wHudHiScore:            .word 0
tHudStartText:          .text "press fire to start"
                        .byte 0
tHudStartClearText:     .text "                   "
                        .byte 0

//==============================================================================
// Subroutines

gameHUDInit:
    lda #HUDEnergyMax
    sta bHudEnergy
    lda #HUDDrinksMax
    sta bHudNumDrinks
    lda #HUDTowelsMax
    sta bHudNumTowels
    lda #0
    sta bHudBarCustomers
    sta bHudLoungersCustomers
    sta wHudScore+1
    sta wHudScore
    rts

//==============================================================================    

gameHUDUpdate:
    jsr gameHUDUpdateEnergy
    jsr gameHUDUpdateBarCustomers
    jsr gameHUDUpdateLoungersCustomers
    jsr gameHUDUpdateNumDrinks
    jsr gameHUDUpdateNumTowels
    jsr gameHUDUpdateDrinksCarrying
    jsr gameHUDUpdateScore
    jsr gameHUDUpdateHiScore
    rts

//==============================================================================

gameHUDUpdateEnergy:
    ldx #0
    lda #HUDEnergyColumn
    sta ZeroPage9
gHUHLoop:
    txa
    cmp bHudEnergy
    bcs gHUHRed
    LIBSCREEN_SETCOLOR_S_AVV(ZeroPage9, HUDRow, GREEN)
    jmp gHUHEnd
gHUHRed:
    LIBSCREEN_SETCOLOR_S_AVV(ZeroPage9, HUDRow, RED)
gHUHEnd:
    inc ZeroPage9
    inx
    cpx #HUDEnergyMax
    bne gHUHLoop
    rts

//==============================================================================

gameHUDUpdateBarCustomers:
    lda bHudBarCustomers // Load number of bar customers
    bne gHUBCRed // If not 0, skip to red
    // Set icon to green
    LIBSCREEN_SETCOLOR_S_VVV(HUDBarCustomersColumn, HUDRow, GREEN)
    jmp gHUBCEnd // Skip to end
gHUBCRed:
    // Set icon to red
    LIBSCREEN_SETCOLOR_S_VVV(HUDBarCustomersColumn, HUDRow, RED)
gHUBCEnd:
    rts

//==============================================================================

gameHUDUpdateLoungersCustomers:
    lda bHudLoungersCustomers
    bne gHULCRed
    LIBSCREEN_SETCOLOR_S_VVV(HUDLoungersCustomersColumn, HUDRow, GREEN)
    jmp gHULCEnd
gHULCRed:
    LIBSCREEN_SETCOLOR_S_VVV(HUDLoungersCustomersColumn, HUDRow, RED)
gHULCEnd:
    rts

//==============================================================================

gameHUDUpdateNumDrinks:
    lda bHudNumDrinks
    ora #$30            // Convert to ascii
    sta ZeroPage9
    LIBSCREEN_SETCHARACTER_S_VVA(HUDNumDrinksColumn, HUDRow, ZeroPage9)
    rts

//==============================================================================

gameHUDUpdateNumTowels:
    
    lda bHudNumTowels   // Convert to ascii
    ora #$30
    sta ZeroPage9
    LIBSCREEN_SETCHARACTER_S_VVA(HUDNumTowelsColumn, HUDRow, ZeroPage9)
    rts

//==============================================================================

gameHUDUpdateDrinksCarrying:
    // Player drinks carrying
    LIBSCREEN_SETCOLOR_S_VVA(HUDDrinkCarryingColumn, HUDRow, bHudDrinkCarrying)
    LIBSCREEN_SETCHARACTER_S_VVV(HUDDrinkCarryingColumn, HUDRow, HUDDrinkCarryingChar)
    lda bHudDrinkCarrying
    cmp #WHITE
    bne gHUDCNotCarryingADrink
    LIBSCREEN_SETCHARACTER_S_VVV(HUDDrinkCarryingColumn, HUDRow, HUDDrinkNotCarryingChar)
gHUDCNotCarryingADrink:
    rts

//==============================================================================

gameHUDUpdateScore:
    // -------- 1st digit --------

    lda wHudScore+1

    // get low nibble
    and #%00001111

    // convert to ascii
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDScoreColumn1, HUDRow, ZeroPage9)

    // -------- 2nd digit --------

    lda wHudScore

    // get high nibble
    and #%11110000

    // convert to ascii
    lsr
    lsr
    lsr
    lsr
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDScoreColumn2, HUDRow, ZeroPage9)

    // -------- 3rd digit --------

    lda wHudScore

    // get low nibble
    and #%00001111

    // convert to ascii
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDScoreColumn3, HUDRow, ZeroPage9)

    rts

//==============================================================================

gameHUDUpdateHiScore:
    // -------- 1st digit --------

    lda wHudHiScore+1

    // get low nibble
    and #%00001111

    // convert to ascii
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDHiScoreColumn1, HUDRow, ZeroPage9)

    // -------- 2nd digit --------

    lda wHudHiScore

    // get high nibble
    and #%11110000

    // convert to ascii
    lsr
    lsr
    lsr
    lsr
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDHiScoreColumn2, HUDRow, ZeroPage9)

    // -------- 3rd digit --------

    lda wHudHiScore

    // get low nibble
    and #%00001111

    // convert to ascii
    ora #$30 
    sta ZeroPage9

    LIBSCREEN_SETCHARACTER_S_VVA(HUDHiScoreColumn3, HUDRow, ZeroPage9)
    rts

//==============================================================================   
                 
gameHUDDecreaseEnergy:
    lda bHudEnergy
    beq gHDHEnd
    dec bHudEnergy
gHDHEnd:
    rts

//==============================================================================   

gameHUDDecreaseNumDrinks:
    lda bHudNumDrinks
    beq gHDNDEnd
    dec bHudNumDrinks
gHDNDEnd:
    rts

//==============================================================================    

gameHUDFillDrinks:
    lda #HUDDrinksMax
    sta bHudNumDrinks
    rts

//==============================================================================    

 gameHUDDecreaseNumTowels:
    lda bHudNumTowels
    beq gHDNTEnd
    dec bHudNumTowels
gHDNTEnd:
    rts

//==============================================================================

gameHUDFillTowels:
    lda #HUDTowelsMax
    sta bHudNumTowels
    rts

//==============================================================================

gameHUDIncreaseScore:
    sed // Set decimal mode
    LIBMATH_ADD16BIT_AVA(wHudScore, HUDScoreIncrease, wHudScore)
    cld // Clear decimal mode
    rts

//==============================================================================

gameHUDClearPressStart:
    LIBSCREEN_DRAWTEXT_VVA(HUDStartColumn, HUDStartRow, tHudStartClearText)
    rts

//==============================================================================

gameHUDShowPressStart:
    LIBSCREEN_DRAWTEXT_VVA(HUDStartColumn, HUDStartRow, tHudStartText)
    rts

//==============================================================================

gameHUDCalculateNewHiScore:
    lda wHudScore
    cmp wHudHiScore
    lda wHudScore+1
    sbc wHudHiScore+1

    bcc gHCNotHi

    lda wHudScore
    sta wHudHiScore
    lda wHudScore+1
    sta wHudHiScore+1
gHCNotHi:
    rts
    