//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameMap
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"

//==============================================================================
// Constants

.const ScreenTopLeft       = 0
.const ScreenTopRight      = 1
.const ScreenBottomLeft    = 2
.const ScreenBottomRight   = 3
//.const MapDelayFrames      = 120 //2

//==============================================================================
// Variables

bMapScreen:     .byte 0
//bMapUpdating:   .byte False

//==============================================================================

.macro GAMEMAP_SETSCREEN_V(mapData, colorData, screen)
{
    //jsr gameMapStartUpdating
    
    LIBSCREEN_SETDISPLAYENABLE_V(False)
    
    LIBSCREEN_SETBACKGROUND_AA(mapData + (screen*1000), colorData)
    
    LIBSCREEN_SETDISPLAYENABLE_V(True)
    
    
    lda #screen
    sta bMapScreen
}

//==============================================================================

//gameMapStartUpdating:
//    LIBSCREEN_SETDISPLAYENABLE_V(False)
//    LIBSPRITE_ENABLEALL_V(False)
//    lda #MapDelayFrames
//    sta bMapUpdating
//    rts

//==============================================================================

//gameMapUpdate:
    //lda bMapUpdating
    //beq gMUEnd
    //dec bMapUpdating
    //bne gMUEnd
    //LIBSPRITE_ENABLEALL_V(True)
//gMUEnd:
//    rts

