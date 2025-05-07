//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gamePlayer
//==============================================================================
// Includes

#import "../../Library/libIncludes.asm"

//==============================================================================
// Constants

.const PlayerStartFrame = 6
.const PlayerXStart     = 173
.const PlayerYStart     = 163
.const PlayerSpeed      = 1
.const PlayerYMin       = 82
.const PlayerYMax       = 229
.const PlayerXMin       = 20
.const PlayerXMax       = 323
.const PlayerAnimDelay  = 7
.const PlayerAnimIdle   = 0
.const PlayerAnimLeft   = 1
.const PlayerAnimRight  = 2
.const PlayerAnimUp     = 3
.const PlayerAnimDown   = 4

//==============================================================================
// Variables

bPlayerSprite:  .byte 0
wPlayerX:       .word PlayerXStart
bPlayerY:       .byte PlayerYStart
bPlayerAnim:    .byte PlayerAnimIdle

//==============================================================================
// Jump Tables

gamePlayerAnimationJumpTable:
    .word gamePlayerUpdateAnimationIdle
    .word gamePlayerUpdateAnimationLeft
    .word gamePlayerUpdateAnimationRight
    .word gamePlayerUpdateAnimationUp
    .word gamePlayerUpdateAnimationDown    

//==============================================================================
// Subroutines

gamePlayerInit:
    // Set sprite animation frame, position, and color
    LIBSPRITE_SETFRAME_AV(bPlayerSprite, PlayerStartFrame)
    LIBSPRITE_SETPOSITION_AAA(bPlayerSprite, wPlayerX, bPlayerY)
    LIBSPRITE_SETCOLOR_AV(bPlayerSprite, BLACK)
    rts

//==============================================================================

gamePlayerUpdate:
    jsr gamePlayerUpdatePosition
    jsr gameplayerUpdateAnimation
    LIBSCREEN_DEBUG16BIT_VVA(0, 1, wPlayerX) // Debug print the position
    LIBSCREEN_DEBUG8BIT_VVA(2, 2, bPlayerY)
    rts

//==============================================================================

gamePlayerUpdatePosition:
    LIBINPUT_GET_V(GameportLeftMask) // Check left
    bne gPUPRight // If left not pressed, skip to right check
    LIBMATH_SUB16BIT_AVA(wPlayerX, PlayerSpeed, wPlayerX) // Subtract X speed
    jmp gPUPEndmove // Skip all other input checks

gPUPRight:
    LIBINPUT_GET_V(GameportRightMask) // Check right
    bne gPUPUp // If right not pressed, skip to up check
    LIBMATH_ADD16BIT_AVA(wPlayerX, PlayerSpeed, wPlayerX) // Add X speed
    jmp gPUPEndmove // Skip all other input checks

gPUPUp:
    LIBINPUT_GET_V(GameportUpMask) // Check up
    bne gPUPDown // If up not pressed, skip to down check
    LIBMATH_SUB8BIT_AVA(bPlayerY, PlayerSpeed, bPlayerY) // Subtract Y speed
    jmp gPUPEndmove // Skip all other input checks
    
gPUPDown:
    LIBINPUT_GET_V(GameportDownMask)  // Check down
    bne gPUPEndmove // If down not pressed, skip to endmove
    LIBMATH_ADD8BIT_AVA(bPlayerY, PlayerSpeed, bPlayerY) // Add Y speed
      
gPUPEndmove:
    // clamp the player x position
    LIBMATH_MIN16BIT_AV(wPlayerX, PlayerXMax)
    LIBMATH_MAX16BIT_AV(wPlayerX, PlayerXMin)

    // clamp the player y position
    LIBMATH_MIN8BIT_AV(bPlayerY, PlayerYMax)
    LIBMATH_MAX8BIT_AV(bPlayerY, PlayerYMin)

    // Set the player's sprite position
    LIBSPRITE_SETPOSITION_AAA(bPlayerSprite, wPlayerX, bPlayerY)
    rts

//==============================================================================

gameplayerUpdateAnimation:
    lda bPlayerAnim                         // Get the current state into A
    asl                                     // X2 as table is in words
    tay                                     // Copy A to Y
    lda gamePlayerAnimationJumpTable,y      // Lookup low byte
    sta ZeroPage1                           // Store in a temporary variable
    lda gamePlayerAnimationJumpTable+1,y    // Lookup high byte
    sta ZeroPage2                           // Store in temporary variable+1
    jmp (ZeroPage1)                         // Indirect jump to subroutine

//==============================================================================

gamePlayerUpdateAnimationIdle:
    LIBINPUT_GET_V(GameportLeftMask) // Check left
    bne gPUIRight // If left not pressed, skip to right check
    jsr gamePlayerSetAnimationLeft
gPUIRight:
    LIBINPUT_GET_V(GameportRightMask) // Check right
    bne gPUIUp // If right not pressed, skip to up check
    jsr gamePlayerSetAnimationRight
gPUIUp:
    LIBINPUT_GET_V(GameportUpMask) // Check up
    bne gPUIDown // If up not pressed, skip to down check
    jsr gamePlayerSetAnimationUp
gPUIDown:
    LIBINPUT_GET_V(GameportDownMask) // Check down
    bne gPUIEnd // If down not pressed, skip to end
    jsr gamePlayerSetAnimationDown
gPUIEnd:
    rts

//==============================================================================

gamePlayerUpdateAnimationLeft:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPULRight
    jmp gPULEnd

gPULRight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPULUp
    jsr gamePlayerSetAnimationRight
    jmp gPULEnd

gPULUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPULDown
    jsr gamePlayerSetAnimationUp
    jmp gPULEnd
    
gPULDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPULNone
    jsr gamePlayerSetAnimationDown
    jmp gPULEnd

gPULNone:
    jsr gamePlayerSetAnimationIdle

gPULEnd:
    rts

//==============================================================================

gamePlayerUpdateAnimationRight:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPURRight
    jsr gamePlayerSetAnimationLeft
    jmp gPUREnd

gPURRight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPURUp
    jmp gPUREnd

gPURUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPURDown
    jsr gamePlayerSetAnimationUp
    jmp gPUREnd
    
gPURDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPURNone
    jsr gamePlayerSetAnimationDown
    jmp gPUREnd

gPURNone:
    jsr gamePlayerSetAnimationIdle
      
gPUREnd:
    rts

//==============================================================================

gamePlayerUpdateAnimationUp:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPUURight
    jsr gamePlayerSetAnimationLeft
    jmp gPUUEnd

gPUURight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPUUUp
    jsr gamePlayerSetAnimationRight
    jmp gPUUEnd

gPUUUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPUUDown
    jmp gPUUEnd
    
gPUUDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPUUNone
    jsr gamePlayerSetAnimationDown  
    jmp gPUUEnd

gPUUNone:
    jsr gamePlayerSetAnimationIdle

gPUUEnd:
    rts      

//==============================================================================

gamePlayerUpdateAnimationDown:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPUADRight
    jsr gamePlayerSetAnimationLeft
    jmp gPUADEnd

gPUADRight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPUADUp
    jsr gamePlayerSetAnimationRight
    jmp gPUADEnd

gPUADUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPUADDown
    jsr gamePlayerSetAnimationUp
    jmp gPUADEnd
    
gPUADDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPUADNone
    jmp gPUADEnd

gPUADNone:
    jsr gamePlayerSetAnimationIdle
      
gPUADEnd:
    rts

//==============================================================================

gamePlayerSetAnimationIdle:
    lda #PlayerAnimIdle
    sta bPlayerAnim
    LIBSPRITE_STOPANIM_A(bPlayerSprite)
    rts

//==============================================================================

gamePlayerSetAnimationLeft:
    lda #PlayerAnimLeft // Load the state number
    sta bPlayerAnim     // Store the state number
    LIBSPRITE_STOPANIM_A(bPlayerSprite) // Stop existing anims
    // Play the new anim
    LIBSPRITE_PLAYANIM_AVVVV(bPlayerSprite, 0, 1, PlayerAnimDelay, true)
    rts

//==============================================================================

gamePlayerSetAnimationRight:
    lda #PlayerAnimRight
    sta bPlayerAnim
    LIBSPRITE_STOPANIM_A(bPlayerSprite)
    LIBSPRITE_PLAYANIM_AVVVV(bPlayerSprite, 2, 3, PlayerAnimDelay, true)
    rts      

//==============================================================================

gamePlayerSetAnimationUp:
    lda #PlayerAnimUp
    sta bPlayerAnim
    LIBSPRITE_STOPANIM_A(bPlayerSprite)
    LIBSPRITE_PLAYANIM_AVVVV(bPlayerSprite, 4, 5, PlayerAnimDelay, true)
    rts

//==============================================================================

gamePlayerSetAnimationDown:
    lda #PlayerAnimDown
    sta bPlayerAnim
    LIBSPRITE_STOPANIM_A(bPlayerSprite)
    LIBSPRITE_PLAYANIM_AVVVV(bPlayerSprite, 6, 7, PlayerAnimDelay, true)
    rts