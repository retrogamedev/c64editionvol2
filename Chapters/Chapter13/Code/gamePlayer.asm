//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gamePlayer
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"
#import "gameData.asm"
#import "gameHUD.asm"

//==============================================================================
// Constants

.const PlayerStartFrame         = 6
.const PlayerXStart             = 173
.const PlayerYStart             = 163
.const PlayerSpeed              = 1
.const PlayerYMin               = 82
.const PlayerYMax               = 229
.const PlayerXMin               = 20
.const PlayerXMax               = 323
.const PlayerAnimDelay          = 7
.const PlayerAnimIdle           = 0
.const PlayerAnimLeft           = 1
.const PlayerAnimRight          = 2
.const PlayerAnimUp             = 3
.const PlayerAnimDown           = 4
.const PlayerLeftPointX         = 5
.const PlayerRightPointX        = 20
.const PlayerCenterPointX       = 14
.const PlayerPointY             = 31 //50-19
.const PlayerCharCollIndex      = 100
.const PlayerCharCrossMin       = 71
.const PlayerCharCrossMax       = 79
.const PlayerSpriteCollWait     = 15
.const PlayerScreenTopLeft      = 0
.const PlayerScreenTopRight     = 1
.const PlayerScreenBottomLeft   = 2
.const PlayerScreenBottomRight  = 3

//==============================================================================
// Variables

bPlayerSprite:          .byte 0
wPlayerX:               .word PlayerXStart
bPlayerY:               .byte PlayerYStart
bPlayerAnim:            .byte PlayerAnimIdle
wPlayerPreviousX:       .word 0
bPlayerPreviousY:       .byte 0
bPlayerMapScreen:             .byte 0
wPlayerCollisionX:      .word 0
bPlayerCollisionY:      .byte 0
bPlayerXChar:           .byte 0
bPlayerYChar:           .byte 0
bPlayerDrinksArray:     .byte RED, GREEN, BLUE, PURPLE
bPlayerBackgroundChar:  .byte 0
bPlayerBackgroundColor: .byte 0
bPlayerSpriteCollision: .byte PlayerSpriteCollWait

//==============================================================================
// Jump Tables

gamePlayerAnimationJumpTable:
    .word gamePlayerUpdateAnimationIdle
    .word gamePlayerUpdateAnimationLeft
    .word gamePlayerUpdateAnimationRight
    .word gamePlayerUpdateAnimationUp
    .word gamePlayerUpdateAnimationDown

gamePlayerMapJumpTable:
    .word gamePlayerUpdateMapTopLeft
    .word gamePlayerUpdateMapTopRight
    .word gamePlayerUpdateMapBottomLeft
    .word gamePlayerUpdateMapBottomRight    

//==============================================================================
// Subroutines

gamePlayerInit:
    lda #0
    sta wPlayerX+1
    lda #PlayerXStart
    sta wPlayerX
    lda #PlayerYStart
    sta bPlayerY
    lda #WHITE
    sta bHudDrinkCarrying

    // Set sprite animation frame, position, and color
    LIBSPRITE_SETFRAME_AV(bPlayerSprite, PlayerStartFrame)
    LIBSPRITE_SETPOSITION_AAA(bPlayerSprite, wPlayerX, bPlayerY)
    LIBSPRITE_SETCOLOR_AV(bPlayerSprite, BLACK)
    rts

//==============================================================================

gamePlayerUpdate:
    jsr gamePlayerUpdatePosition
    jsr gameplayerUpdateAnimation
    jsr gamePlayerUpdateBackgroundCollisions
    jsr gamePlayerUpdateSpriteCollisions
    jsr gamePlayerUpdateMap
    jsr gameplayerUpdateSprite
    jsr gamePlayerUpdateCollectDrinks
    jsr gamePlayerUpdateFillDrinks // new in this chapter - maybe add these in chapter 11 instead
    jsr gamePlayerUpdateFillTowels // new in this chapter 
    rts

//==============================================================================

gamePlayerUpdatePosition:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPUPRight
    LIBMATH_SUB16BIT_AVA(wPlayerX, PlayerSpeed, wPlayerX)
    jmp gPUPEndmove

gPUPRight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPUPUp
    LIBMATH_ADD16BIT_AVA(wPlayerX, PlayerSpeed, wPlayerX) // Move player right
    jmp gPUPEndmove

gPUPUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPUPDown
    LIBMATH_SUB8BIT_AVA(bPlayerY, PlayerSpeed, bPlayerY)
    jmp gPUPEndmove
    
gPUPDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPUPEndmove
    LIBMATH_ADD8BIT_AVA(bPlayerY, PlayerSpeed, bPlayerY)
      
gPUPEndmove:
    // clamp the player x position
    LIBMATH_MIN16BIT_AV(wPlayerX, PlayerXMax)
    LIBMATH_MAX16BIT_AV(wPlayerX, PlayerXMin)

    // clamp the player y position
    LIBMATH_MIN8BIT_AV(bPlayerY, PlayerYMax)
    LIBMATH_MAX8BIT_AV(bPlayerY, PlayerYMin)

    rts

//==============================================================================

gameplayerUpdateAnimation:
    lda bPlayerAnim                         // Get the current state into A
    asl                                     // Multiply by 2
    tay                                     // Copy A to Y
    lda gamePlayerAnimationJumpTable,y      // Lookup low byte
    sta ZeroPage1                           // Store in a temporary variable
    lda gamePlayerAnimationJumpTable+1,y    // Lookup high byte
    sta ZeroPage2                           // Store in temporary variable+1
    jmp (ZeroPage1)                         // Indirect jump to subroutine

//==============================================================================

gamePlayerUpdateAnimationIdle:
    LIBINPUT_GET_V(GameportLeftMask)
    bne gPUIRight
    jsr gamePlayerSetAnimationLeft
gPUIRight:
    LIBINPUT_GET_V(GameportRightMask)
    bne gPUIUp
    jsr gamePlayerSetAnimationRight
gPUIUp:
    LIBINPUT_GET_V(GameportUpMask)
    bne gPUIDown
    jsr gamePlayerSetAnimationUp
gPUIDown:
    LIBINPUT_GET_V(GameportDownMask)
    bne gPUIEnd
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
    lda #PlayerAnimLeft
    sta bPlayerAnim
    LIBSPRITE_STOPANIM_A(bPlayerSprite)
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

//==============================================================================

gamePlayerUpdateBackgroundCollisions:
    // Left point
    LIBMATH_SUB16BIT_AVA(wPlayerX, PlayerLeftPointX, wPlayerCollisionX)  
    LIBMATH_SUB8BIT_AVA(bPlayerY, PlayerPointY, bPlayerCollisionY)

    jsr gamePlayerUpdateCollisionsCollide

    // Right point
    LIBMATH_SUB16BIT_AVA(wPlayerX, PlayerRightPointX, wPlayerCollisionX)  

    jsr gamePlayerUpdateCollisionsCollide

    // Center point (used for drinks collisions)
    LIBMATH_SUB16BIT_AVA(wPlayerX, PlayerCenterPointX, wPlayerCollisionX) 

    LIBSCREEN_PIXELTOCHAR_AAAA(wPlayerCollisionX, bPlayerCollisionY, bPlayerXChar, bPlayerYChar)

    LIBSCREEN_GETCHARACTER_AAA(bPlayerXChar, bPlayerYChar, bPlayerBackgroundChar)

    LIBSCREEN_GETCOLOR_AAA(bPlayerXChar, bPlayerYChar, bPlayerBackgroundColor)

    // Store previous player position
    lda wPlayerX+1
    sta wPlayerPreviousX+1
    lda wPlayerX
    sta wPlayerPreviousX
    lda bPlayerY
    sta bPlayerPreviousY
    rts

//==============================================================================

gamePlayerUpdateCollisionsCollide:
    LIBSCREEN_PIXELTOCHAR_AAAA(wPlayerCollisionX, bPlayerCollisionY, bPlayerXChar, bPlayerYChar)

    LIBSCREEN_GETCHARACTER_AAA(bPlayerXChar, bPlayerYChar, ZeroPage1)

    // Handle any collisions with character code > PlayerCharCollIndex
    lda #PlayerCharCollIndex
    cmp ZeroPage1
    bcs gPUCCNoCollision
    
    // Collision response
    lda wPlayerPreviousX+1
    sta wPlayerX+1
    lda wPlayerPreviousX
    sta wPlayerX
    lda bPlayerPreviousY
    sta bPlayerY
    
gPUCCNoCollision:
    rts

//==============================================================================

gamePlayerUpdateSpriteCollisions:
    LIBSPRITE_SETCOLOR_AV(bPlayerSprite, BLACK)

    // Only do if on Top Right or Bottom Right screen
    lda bPlayerMapScreen
    cmp #PlayerScreenTopRight
    beq gPUSCOK
    cmp #PlayerScreenBottomRight
    beq gPUSCOK
    jmp gPUSCEnd
gPUSCOK:

    LIBSPRITE_DIDCOLLIDESP_A(bPlayerSprite)
    beq gPUSCEnd

    LIBSPRITE_SETCOLOR_AV(bPlayerSprite, RED)
    
    dec bPlayerSpriteCollision
    bne gPUSCEnd

    // Decrease energy
    jsr gameHUDDecreaseEnergy

    // Play the sfx
    LIBSOUND_PLAYSFX_AA(gameDataSID, SFX_Crab)

    lda #PlayerSpriteCollWait
    sta bPlayerSpriteCollision

gPUSCEnd:
    rts

//==============================================================================

gamePlayerUpdateMap:
    lda bPlayerMapScreen                          // Get the current state into A
    asl                                     // Multiply by 2
    tay                                     // Copy A to Y
    lda gamePlayerMapJumpTable,y            // Lookup low byte
    sta ZeroPage1                           // Store in a temporary variable
    lda gamePlayerMapJumpTable+1,y          // Lookup high byte
    sta ZeroPage2                           // Store in temporary variable+1
    jmp (ZeroPage1)                         // Indirect jump to subroutine

 //==============================================================================

gamePlayerUpdateMapTopLeft:
    // X direction
    lda wPlayerX+1          // If high byte is 0 skip X processing
    beq gPUS1EndX                           

    lda wPlayerX            // If low byte < PlayerXMax skip X processing
    cmp #<PlayerXMax
    bmi gPUS1EndX              

    lda #>PlayerXMin        // Set player X position to XMin
    sta wPlayerX+1
    lda #PlayerXMin+1
    sta wPlayerX

    // Set screen to top right
    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopRight*1000), gameDataBackGroundCol)
    lda #PlayerScreenTopRight
    sta bPlayerMapScreen

gPUS1EndX:
    // Y direction
    lda bPlayerY            // If PlayerY < PlayerYMax skip Y processsing
    cmp #PlayerYMax
    bcc gPUS1EndY

    lda #PlayerYMin+1       // Set player Y position to YMin
    sta bPlayerY

    // Set screen to bottom left
    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenBottomLeft*1000), gameDataBackGroundCol)
    lda #PlayerScreenBottomLeft
    sta bPlayerMapScreen

gPUS1EndY:
    rts

//==============================================================================

gamePlayerUpdateMapTopRight:
    // X direction
    lda wPlayerX+1
    bne gPUS2EndX

    lda wPlayerX
    cmp #<PlayerXMin
    bne gPUS2EndX

    lda #>PlayerXMax
    sta wPlayerX+1
    lda #<PlayerXMax-1
    sta wPlayerX

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopLeft*1000), gameDataBackGroundCol)
    lda #PlayerScreenTopLeft
    sta bPlayerMapScreen

gPUS2EndX:

    // Y direction
    lda bPlayerY
    cmp #PlayerYMax
    bcc gPUS2EndY

    lda #PlayerYMin+1
    sta bPlayerY

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenBottomRight*1000), gameDataBackGroundCol)
    lda #PlayerScreenBottomRight
    sta bPlayerMapScreen

gPUS2EndY:
    rts

//==============================================================================

gamePlayerUpdateMapBottomLeft:
    // X direction
    lda wPlayerX+1
    beq gPUS3EndX
   
    lda wPlayerX
    cmp #<PlayerXMax
    bmi gPUS3EndX
    
    lda #>PlayerXMin
    sta wPlayerX+1
    lda #<PlayerXMin+1
    sta wPlayerX

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenBottomRight*1000), gameDataBackGroundCol)
    lda #PlayerScreenBottomRight
    sta bPlayerMapScreen

gPUS3EndX:

    // Y direction
    lda bPlayerY
    cmp #PlayerYMin
    bne gPUS3EndY

    lda #PlayerYMax-1
    sta bPlayerY

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopLeft*1000), gameDataBackGroundCol)
    lda #PlayerScreenTopLeft
    sta bPlayerMapScreen

gPUS3EndY:
    rts

//==============================================================================

gamePlayerUpdateMapBottomRight:
    // X direction
    lda wPlayerX+1
    bne gPUS4EndX

    lda wPlayerX
    cmp #<PlayerXMin
    bne gPUS4EndX

    lda #>PlayerXMax
    sta wPlayerX+1
    lda #<PlayerXMax-1
    sta wPlayerX

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenBottomLeft*1000), gameDataBackGroundCol)
    lda #PlayerScreenBottomLeft
    sta bPlayerMapScreen

gPUS4EndX:

    // Y direction
    lda bPlayerY
    cmp #PlayerYMin
    bne gPUS4EndY

    lda #PlayerYMax-1
    sta bPlayerY

    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopRight*1000), gameDataBackGroundCol)
    lda #PlayerScreenTopRight
    sta bPlayerMapScreen

gPUS4EndY:
    rts

//==============================================================================

gameplayerUpdateSprite:
    // Set the player's sprite position
    LIBSPRITE_SETPOSITION_AAA(bPlayerSprite, wPlayerX, bPlayerY)
    rts    

//==============================================================================

gamePlayerUpdateCollectDrinks:
    // Check if the player collects a drink
    LIBINPUT_GET_V(GameportFireMask)
    bne gPUCDEnd

    lda bPlayerBackgroundChar
    cmp #PlayerCharCrossMin
    bmi gPUCDEnd

    cmp #PlayerCharCrossMax                       
    bcs gPUCDEnd

    // already carrying drink of this color
    lda bHudDrinkCarrying
    cmp bPlayerBackgroundColor
    beq gPUCDEnd

    // drinks empty 
    lda bHudNumDrinks
    bne gPUCDNotEmpty

    // Play the sfx
    LIBSOUND_PLAYSFX_AA(gameDataSID, SFX_Fail1)

    beq gPUCDEnd

gPUCDNotEmpty:

    LIBMATH_SUB8BIT_AVA(bPlayerBackgroundChar, 71, ZeroPage1)

    lda ZeroPage1
    lsr // divide by 2
    tay

    lda bPlayerDrinksArray,y
    sta bHudDrinkCarrying

    jsr gameHUDDecreaseNumDrinks

    // Play the sfx
    LIBSOUND_PLAYSFX_AA(gameDataSID, SFX_Great)

gPUCDEnd:
    rts

//==============================================================================

gamePlayerUpdateFillDrinks:
    // Check if the player fills the drinks
    LIBINPUT_GET_V(GameportFireMask)
    bne gPUFDEnd

    lda bPlayerBackgroundChar
    cmp #79
    bmi gPUFDEnd

    cmp #81
    bcs gPUFDEnd

    jsr gameHUDFillDrinks

    // Play the sfx
    LIBSOUND_PLAYSFX_AA(gameDataSID, SFX_Tadaah)

gPUFDEnd:
    rts

//==============================================================================

gamePlayerUpdateFillTowels:
    // Check if the player fills the towels
    LIBINPUT_GET_V(GameportFireMask)
    bne gPUFTEnd

    lda bPlayerBackgroundChar
    cmp #46
    bmi gPUFTEnd

    cmp #48
    bcs gPUFTEnd

    jsr gameHUDFillTowels

    // Play the sfx
    LIBSOUND_PLAYSFX_AA(gameDataSID, SFX_Tadaah)

gPUFTEnd:
    rts    

