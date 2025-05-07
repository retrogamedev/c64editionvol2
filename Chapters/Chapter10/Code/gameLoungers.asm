//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameLoungers
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"
#import "gamePlayer.asm"

//==============================================================================
// Constants

.const LoungersSpriteMax        = 6
.const LoungersStateWalking     = 0
.const LoungersStateWaiting     = 1
.const LoungersStateLying       = 2
.const LoungersWalkDirLeft      = 1
.const LoungersWalkDirRight     = 0
.const LoungersAnimDelay        = 7
.const LoungersStandingWait     = 7
.const LoungersLyingWait        = 8
.const LoungersNoTowel_1_1      = 201
.const LoungersNoTowel_2_1      = 202
.const LoungersNoTowel_1_2      = 203
.const LoungersNoTowel_2_2      = 204
.const LoungersNoTowel_1_3      = 205
.const LoungersNoTowel_2_3      = 206
.const LoungersTowel_1_1        = 207
.const LoungersTowel_2_1        = 208
.const LoungersTowel_1_2        = 209
.const LoungersTowel_2_2        = 210
.const LoungersTowel_1_3        = 211
.const LoungersTowel_2_3        = 212

//==============================================================================
// Variables

// arrays
bLoungersStateArray:        .byte   0,  0,  0,  0,  0,  0
bLoungersXArray:            .byte   0,  0,  0,  0,  0,  0
bLoungersYArray:            .byte   0,  0,  0,  0,  0,  0
bLoungersWalkDirArray:      .byte   0,  0,  0,  0,  0,  0
bLoungersTimerHArray:       .byte   0,  0,  0,  0,  0,  0
bLoungersTimerLArray:       .byte   0,  0,  0,  0,  0,  0
bLoungersChairTakenArray:   .byte   0,  0,  0,  0,  0,  0
bLoungersChairArray:        .byte   0,  1,  2,  3,  4,  5
bLoungersSpriteColorArray:  .byte   1,  0,  5,  0,  2,  6
bLoungersChairCol1Array:    .byte   8, 18, 28,  8, 18, 28
bLoungersChairCol2Array:    .byte   9, 19, 29,  9, 19, 29
bLoungersChairRow1Array:    .byte   8,  8,  8, 16, 16, 16
bLoungersChairRow2Array:    .byte   9,  9,  9, 17, 17, 17
bLoungersChairRow3Array:    .byte  10, 10, 10, 18, 18, 18
bLoungersTowelChar1Array:   .byte  34, 36, 38, 40, 42, 44
bLoungersTowelChar2Array:   .byte  35, 37, 39, 41, 43, 45
bLoungersWalk1Array:        .byte  10, 16, 10, 28, 10, 22
bLoungersWalk2Array:        .byte  11, 17, 11, 29, 11, 23
bLoungersWalk3Array:        .byte   8, 14,  8, 26,  8, 20
bLoungersWalk4Array:        .byte   9, 15,  9, 27,  9, 21
bLoungersLieArray:          .byte  12, 18, 12, 30, 12, 24
bLoungersChairXArray:       .byte  83,163,243, 83,163,243
bLoungersChairYArray:       .byte 115,115,115,179,179,179
bLoungersWalkYArray:        .byte 135,135,135,199,199,199

// current element values
bLoungersSprite:        .byte 0
bLoungersState:         .byte 0
bLoungersElement:       .byte 0
wLoungersX:             .word 0
bLoungersY:             .byte 0
bLoungersWalkDir:       .byte 0
bLoungersChair:         .byte 0
bLoungersSpriteColor:   .byte 0
bLoungersChairColumn1:  .byte 0
bLoungersChairColumn2:  .byte 0
bLoungersChairRow1:     .byte 0
bLoungersChairRow2:     .byte 0
bLoungersChairRow3:     .byte 0
bLoungersTowelChar1:    .byte 0
bLoungersTowelChar2:    .byte 0
bLoungersWalk1:         .byte 0
bLoungersWalk2:         .byte 0
bLoungersWalk3:         .byte 0
bLoungersWalk4:         .byte 0
bLoungersLie:           .byte 0
bLoungersChairX:        .byte 0
bLoungersChairY:        .byte 0
bLoungersWalkY:         .byte 0
wLoungersTimer:         .word 0
bLoungersTimerIsZero:   .byte 0

//==============================================================================

gameLoungersUpdateStateJumpTable:
    .word gameLoungersUpdateStateWalking
    .word gameLoungersUpdateStateWaiting
    .word gameLoungersUpdateStateLying

gameLoungersUpdateSpriteJumpTable:
    .word gameLoungersUpdateSpriteWalking
    .word gameLoungersUpdateSpriteWaiting
    .word gameLoungersUpdateSpriteLying

//==============================================================================

gameLoungersInit:
    ldx #0
gLILoop:    
    jsr gameLoungersGetVariables
    // Reset some variables 
    lda #0
    sta bLoungersState
    sta wLoungersX
    sta bLoungersWalkDir
    // Fill the chair
    lda #True
    sta bLoungersChairTakenArray,x
    // Get a random timerhigh wait time (0->5)
    LIBMATH_RAND_AAA(bMathRandoms2, bMathRandomCurrent2, wLoungersTimer+1)
    // Add a large minimum delay to start a little later than the bar game
    LIBMATH_ADD8BIT_AVA(wLoungersTimer+1, 7, wLoungersTimer+1)
    // Get a random timerlow wait time (0->255)
    LIBMATH_RAND_AAA(bMathRandoms1, bMathRandomCurrent1, wLoungersTimer)
    jsr gameLoungersSetVariables
    inx
    cpx #LoungersSpriteMax
    bne gLILoop

    rts

//==============================================================================

gameLoungersUpdate:

    ldx #0
    stx bLoungersSprite

gLULoop:
    inc bLoungersSprite // x+1
    
    jsr gameLoungersGetVariables
    jsr gameLoungersUpdateState
    jsr gameLoungersSetVariables

    // only if on loungers screen
    lda bMapScreen
    cmp #2
    bne gLUNotOnLoungersScreen
    jsr gameLoungersUpdateSprite
gLUNotOnLoungersScreen:

    inx
    cpx #LoungersSpriteMax
    bne gLULoop

    rts

//==============================================================================

gameLoungersGetVariables:

    // Read this element's variables
    lda bLoungersStateArray,x
    sta bLoungersState
    lda bLoungersXArray,x
    sta wLoungersX
    lda bLoungersYArray,x
    sta bLoungersY
    lda bLoungersWalkDirArray,x
    sta bLoungersWalkDir
    lda bLoungersChairArray,x
    sta bLoungersChair
    lda bLoungersSpriteColorArray,x
    sta bLoungersSpriteColor
    lda bLoungersWalk1Array,x
    sta bLoungersWalk1
    lda bLoungersWalk2Array,x
    sta bLoungersWalk2
    lda bLoungersWalk3Array,x
    sta bLoungersWalk3
    lda bLoungersWalk4Array,x
    sta bLoungersWalk4
    lda bLoungersLieArray,x
    sta bLoungersLie
    lda bLoungersTimerHArray,x
    sta wLoungersTimer+1
    lda bLoungersTimerLArray,x
    sta wLoungersTimer

    // Get the chair & towel variables
    ldy bLoungersChair
    lda bLoungersChairYArray,y
    sta bLoungersChairY
    lda bLoungersWalkYArray,y
    sta bLoungersWalkY
    lda bLoungersChairCol1Array,y
    sta bLoungersChairColumn1
    lda bLoungersChairCol2Array,y
    sta bLoungersChairColumn2
    lda bLoungersChairRow1Array,y
    sta bLoungersChairRow1
    lda bLoungersChairRow2Array,y
    sta bLoungersChairRow2
    lda bLoungersChairRow3Array,y
    sta bLoungersChairRow3
    lda bLoungersTowelChar1Array,y
    sta bLoungersTowelChar1
    lda bLoungersTowelChar2Array,y
    sta bLoungersTowelChar2

    // Save X register
    stx bLoungersElement

    rts

//==============================================================================

gameLoungersSetVariables:

    // Restore X register
    ldx bLoungersElement
     
    // Write this element's variables
    // Read only variables need not be in here
    lda bLoungersState
    sta bLoungersStateArray,x
    lda wLoungersX
    sta bLoungersXArray,x
    lda bLoungersY
    sta bLoungersYArray,x
    lda bLoungersWalkDir
    sta bLoungersWalkDirArray,x
    lda bLoungersChair
    sta bLoungersChairArray,x
    lda wLoungersTimer+1
    sta bLoungersTimerHArray,x
    lda wLoungersTimer
    sta bLoungersTimerLArray,x
   
    rts

//==============================================================================    

gameLoungersUpdateState:

    jsr gameLoungersUpdateStateTimer

    lda bLoungersState                      // Get the current state into A
    asl                                     // Multiply by 2
    tay                                     // Copy A to Y
    lda gameLoungersUpdateStateJumpTable,y  // Lookup low byte
    sta ZeroPage1                           // Store in a temporary variable
    lda gameLoungersUpdateStateJumpTable+1,y// Lookup high byte
    sta ZeroPage2                           // Store in temporary variable+1
    jmp (ZeroPage1)                         // Indirect jump to subroutine

//==============================================================================

gameLoungersUpdateStateTimer:

    lda #False
    sta bLoungersTimerIsZero

    lda wLoungersTimer+1
    bne gLUSTimerHighNotZero
    lda wLoungersTimer
    beq gLUSTimerIsZero
gLUSTimerHighNotZero:
    // decrement the timer
    LIBMATH_SUB16BIT_AVA(wLoungersTimer, 1, wLoungersTimer)
    rts
gLUSTimerIsZero:

    lda #True
    sta bLoungersTimerIsZero

    rts    

//==============================================================================    

gameLoungersUpdateStateWalking:

    lda bLoungersWalkY      // Get the Y position for this beachgoer
    sta bLoungersY          // Set the Y position for this beachgoer

    lda bLoungersTimerIsZero // If bLoungersTimerIsZero = true, then zero flag = false
    bne gLUSWTimerIsZero     // If zero flag not set, jump to gLUSWTimerIsZero
    jmp gLUSWEnd
gLUSWTimerIsZero:

    lda bLoungersWalkDir    // Is facing left?
    beq gLUSWRightWalk      // No, so jump to Walking Right

// ------------ Walking Left ----------------------

    dec wLoungersX          // Move left
    beq gLUSWEndSkip        // If at left edge, jump to gLUSWEndSkip
    jmp gLUSWEnd
gLUSWEndSkip:

    // move right 1 so we can try again next 
    // frame if no lounger is available
    inc wLoungersX

    // Set a random lounger (if available)
    LIBMATH_RAND_AAA(bMathRandoms2, bMathRandomCurrent2, ZeroPage1)
    ldy ZeroPage1  
    lda bLoungersChairTakenArray,y
    bne gLUSWEnd

    // Fill the lounger
    sty bLoungersChair
    lda #True
    sta bLoungersChairTakenArray,y

    // Set the walk direction
    lda #LoungersWalkDirRight
    sta bLoungersWalkDir

    // Get a random timerhigh wait time (0->5)
    LIBMATH_RAND_AAA(bMathRandoms2, bMathRandomCurrent2, wLoungersTimer+1)

    // Get a random timerlow wait time (0->255)
    LIBMATH_RAND_AAA(bMathRandoms1, bMathRandomCurrent1, wLoungersTimer)
 
    jmp gLUSWEnd

// ------------ Walking Right ---------------------

gLUSWRightWalk:

    inc wLoungersX          // Move right

    // Check if reached target lounger position
    ldy bLoungersChair
    lda bLoungersChairXArray,y
    sta ZeroPage1
    LIBMATH_GREATEREQUAL8BIT_AA(wLoungersX, ZeroPage1)
    bcc gLUSWEnd
    
    // Set the state
    lda #LoungersStateWaiting
    sta bLoungersState

    // Set the timer
    lda #LoungersStandingWait
    sta wLoungersTimer+1

// ------------------------------------------------

gLUSWEnd:

    rts

//==============================================================================    

gameLoungersUpdateStateWaiting:
    // ------------ Check is Towel Delivered ----------
    
    // needs to have fire pressed
    LIBINPUT_GET_V(GameportFireMask)
    bne gLUSWTowelNotDelivered

    // and be standing on the correct location
    lda bPlayerBackgroundChar
    cmp bLoungersTowelChar1
    beq gLUSWCheckTowels

    cmp bLoungersTowelChar2
    beq gLUSWCheckTowels

    jmp gLUSWTowelNotDelivered

gLUSWCheckTowels:

// ------------ Towel is Delivered ----------------

gLUSWTowelIsDelivered:

    // Set the state
    lda #LoungersStateLying
    sta bLoungersState

    // Set the timer
    lda #LoungersLyingWait
    sta wLoungersTimer+1

    jmp gLUSWaEnd

// ------------ Towel is Not Delivered  -----------

gLUSWTowelNotDelivered:

    // leave if the timer runs out
    lda bLoungersTimerIsZero
    beq gLUSWaEnd

    // Set the walk direction
    lda #LoungersWalkDirLeft
    sta bLoungersWalkDir

    // Clear the lounger
    lda #False
    ldy bLoungersChair
    sta bLoungersChairTakenArray,y

    // Set the state
    lda #LoungersStateWalking
    sta bLoungersState

// ------------------------------------------------

gLUSWaEnd:
    rts

//==============================================================================    

gameLoungersUpdateStateLying:
    lda bLoungersChairY
    sta bLoungersY

    // leave if the timer runs out
    lda bLoungersTimerIsZero
    beq gLUSLEnd

    // Set the walk direction
    lda #LoungersWalkDirLeft
    sta bLoungersWalkDir

    // Clear the lounger
    lda #False
    ldy bLoungersChair
    sta bLoungersChairTakenArray,y

    // Set the state
    lda #LoungersStateWalking
    sta bLoungersState

gLUSLEnd:
    rts

//==============================================================================    

gameLoungersUpdateSprite:

    LIBSPRITE_SETPOSITION_AAA(bLoungersSprite, wLoungersX, bLoungersY)
    LIBSPRITE_SETCOLOR_AA(bLoungersSprite, bLoungersSpriteColor)

    lda bLoungersState                      // Get the current state into A
    asl                                     // Multiply by 2
    tay                                     // Copy A to Y
    lda gameLoungersUpdateSpriteJumpTable,y // Lookup low byte
    sta ZeroPage1                           // Store in a temporary variable
    lda gameLoungersUpdateSpriteJumpTable+1,y// Lookup high byte
    sta ZeroPage2                           // Store in temporary variable+1
    jmp (ZeroPage1)                         // Indirect jump to subroutine 

//==============================================================================    

gameLoungersUpdateSpriteWalking:
    lda bLoungersWalkDir
    beq gLUSpWaRight

// ------------ Walking Left ----------------------

    LIBSPRITE_PLAYANIM_AAAVV(bLoungersSprite, bLoungersWalk3, bLoungersWalk4, LoungersAnimDelay, true)
    jmp gLUSpWaEnd

// ------------ Walking Right ---------------------

gLUSpWaRight:

    LIBSPRITE_PLAYANIM_AAAVV(bLoungersSprite, bLoungersWalk1, bLoungersWalk2, LoungersAnimDelay, true)

// ------------------------------------------------

gLUSpWaEnd:

    // Draw the lounger without a towel
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow1, LoungersNoTowel_1_1)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow1, LoungersNoTowel_2_1)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow2, LoungersNoTowel_1_2)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow2, LoungersNoTowel_2_2)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow3, LoungersNoTowel_1_3)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow3, LoungersNoTowel_2_3)
    rts

//==============================================================================    

gameLoungersUpdateSpriteWaiting:
    // Draw the standing sprite
    LIBSPRITE_STOPANIM_A(bLoungersSprite)
    LIBSPRITE_SETFRAME_AA(bLoungersSprite, bLoungersWalk1)
    rts

//==============================================================================    

gameLoungersUpdateSpriteLying:
    // Draw the lying sprite
    LIBSPRITE_STOPANIM_A(bLoungersSprite)
    LIBSPRITE_SETFRAME_AA(bLoungersSprite, bLoungersLie)

    // Draw the lounger with a towel
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow1, LoungersTowel_1_1)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow1, LoungersTowel_2_1)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow2, LoungersTowel_1_2)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow2, LoungersTowel_2_2)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn1, bLoungersChairRow3, LoungersTowel_1_3)
    LIBSCREEN_SETCHARACTER_S_AAV(bLoungersChairColumn2, bLoungersChairRow3, LoungersTowel_2_3)
    rts           
