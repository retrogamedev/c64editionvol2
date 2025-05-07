//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 6_1
//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
    BasicUpstart(gameMainInit)

//==============================================================================
// Includes

*= $0810 "Code"
    #import "../../Library/libIncludes.asm"
    #import "gamePlayer.asm"

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_DISABLEBASICANDKERNAL()          // Disable BASIC and Kernal ROMs
    LIBUTILITY_SET1000_AV(SCREENRAM, Space)     // Clear the screen
    LIBSCREEN_SETSCREENCOLOR_V(YELLOW)          // Set the screen color
    
    LIBSPRITE_ENABLEALL_V(true)                 // Enable all 8 hardware sprites 
    LIBSPRITE_MULTICOLORENABLEALL_V(true)       // Set the sprite multicolor mode
    LIBSPRITE_SETMULTICOLORS_VV(LIGHT_RED, BROWN) // Set the sprite multicolors

    jsr gamePlayerInit  // Call the player initialize subroutine

//==============================================================================
// Update

gameMainUpdate:
    jmp gameMainUpdate    // Jump back, infinite loop

//==============================================================================
// Data

 *= $2800 "Sprites" // Add sprite data at the $2800 memory location
    .import binary "..\..\Content\BeachBarSprites1.bin"