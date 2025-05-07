//==============================================================================
//                        RetroGameDev Library C64 v2.02
//==============================================================================
//Includes

#importonce
#import "libDefines.asm"

//==============================================================================
// Constants

// Port Masks
.label GameportUpMask       = %00000001
.label GameportDownMask     = %00000010
.label GameportLeftMask     = %00000100
.label GameportRightMask    = %00001000
.label GameportFireMask     = %00010000

//==============================================================================
// Macros

.macro LIBINPUT_GET_V(bPortMask)
{
    lda CIAPRA      // Load joystick 2 state to A
    and #bPortMask  // Mask out direction/fire required
} // Test with bne immediately after the call