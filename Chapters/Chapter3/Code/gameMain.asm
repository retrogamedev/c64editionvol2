//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 3
//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
    BasicUpstart(gameMainInit)

//==============================================================================
// Includes

*= $0810 "Code"
    #import "../../Library/libIncludes.asm"

//==============================================================================
// Variables
 
bVariable:      .byte 0
wVariable:      .word 0
bVariableText:  .text "byte variable: "
.byte 0
wVariableText:  .text "word variable: "
.byte 0
zeroPage1Text:  .text "zeropage1: "
.byte 0
zeroPage2Text:  .text "zeropage2: "
.byte 0

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_SET1000_AV(SCREENRAM, Space)     // Clear the screen
    LIBSCREEN_SETBACKGROUNDCOLOR_V(YELLOW)      // Set the background color
    LIBSCREEN_SETBORDERCOLOR_V(BLUE)            // Set the border color

    LIBSCREEN_DRAWTEXT_VVA(1, 5, bVariableText) // Draw byte variable text
    LIBSCREEN_DRAWTEXT_VVA(1, 7, wVariableText) // Draw word variable text
    LIBSCREEN_DRAWTEXT_VVA(1, 14, zeroPage1Text)// Draw zeropage1 text
    LIBSCREEN_DRAWTEXT_VVA(1, 16, zeroPage2Text)// Draw zeropage2 text

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)                       // Wait for scanline 250
    LIBSCREEN_SETBORDERCOLOR_V(RED)             // Start a profiling bar
    LIBSCREEN_DEBUG8BIT_VVA(18, 5, bVariable)   // Draw byte variable value
    inc bVariable                               // Increment byte variable
    LIBSCREEN_SETBORDERCOLOR_V(CYAN)            // Start a profiling bar
    LIBSCREEN_DEBUG16BIT_VVA(18, 7, wVariable)  // Draw word variable value
    LIBMATH_ADD16BIT_AVA(wVariable, 1, wVariable)// Increment word variable
    LIBSCREEN_SETBORDERCOLOR_V(PURPLE)          // Start a profiling bar
    LIBSCREEN_DEBUG8BIT_VVA(18, 14, ZeroPage1)  // Draw zeropage1 value
    LIBSCREEN_DEBUG8BIT_VVA(18, 16, ZeroPage2)  // Draw zeropage2 value
    LIBSCREEN_SETBORDERCOLOR_V(BLUE)            // Reset border color to default
    jmp gameMainUpdate                          // Jump back, infinite loop