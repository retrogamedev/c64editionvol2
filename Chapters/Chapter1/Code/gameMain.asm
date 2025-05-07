//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 1
//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
    BasicUpstart(gameMainInit)

//==============================================================================
// Includes

*= $0810 "Code"
    #import "../../Library/libIncludes.asm"

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_SET1000_AV(SCREENRAM, Space) // Clear the screen
    LIBSCREEN_SETSCREENCOLOR_V(YELLOW)      // Set background & border colors
    // 16 C64 Colors -  BLACK, WHITE, RED, CYAN, PURPLE, GREEN, BLUE, YELLOW,
    //                  ORANGE, BROWN, LIGHT_RED, DARK_GRAY, GRAY, LIGHT_GREEN,
    //                  LIGHT_BLUE, LIGHT_GRAY

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)   // Wait for scanline 250
    jmp gameMainUpdate      // Jump back, infinite loop