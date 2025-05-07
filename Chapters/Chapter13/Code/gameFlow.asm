//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameFlow
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"
#import "gameBar.asm"
#import "gameHUD.asm"
#import "gameLoungers.asm"
#import "gameCrabs.asm"

//==============================================================================
// Constants

.const FlowStateMenu = 0
.const FlowStateGame = 1

//==============================================================================
// Variables

bFlowState:     .byte 0

//==============================================================================
// Jump Tables

gameFlowJumpTable:
    .word gameFlowUpdateMenu
    .word gameFlowUpdateGame

//==============================================================================
// Subroutines

gameFlowUpdate:
    lda bFlowState                  // Get the current state into A
    asl                             // Multiply by 2
    tay                             // Copy A to Y
    lda gameFlowJumpTable,y         // Lookup low byte
    sta ZeroPage1                   // Store in a temporary variable
    lda gameFlowJumpTable+1,y       // Lookup high byte
    sta ZeroPage2                   // Store in temporary variable+1
    jmp (ZeroPage1)                 // Indirect jump to subroutine

//==============================================================================

gameFlowUpdateMenu:
    LIBINPUT_GET_V(GameportFireMask)
    bne gFUMNotPressed

    // Set the state
    lda #FlowStateGame
    sta bFlowState

    jsr gameHUDClearPressStart

    jsr gamePlayerInit
    jsr gameBarInit
    jsr gameLoungersInit
    jsr gameHUDInit

    // Enable all 8 hardware sprites 
    LIBSPRITE_ENABLEALL_V(true)
    rts

gFUMNotPressed:
    jsr gameHUDShowPressStart
    rts

//==============================================================================

gameFlowUpdateGame:
    jsr gamePlayerUpdate
    jsr gameBarUpdate
    jsr gameLoungersUpdate
    jsr gameCrabsUpdate     // Update the crabs subroutines

    lda bHudEnergy
    bne gFUGEnd

    // Set the state
    lda #FlowStateMenu
    sta bFlowState

    // Disable all 8 hardware sprites 
    LIBSPRITE_ENABLEALL_V(false)

    jsr gameHUDCalculateNewHiScore

    // Reset screen to top left
    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopLeft*1000), gameDataBackGroundCol)
    lda #PlayerScreenTopLeft
    sta bPlayerMapScreen

gFUGEnd:
    rts
