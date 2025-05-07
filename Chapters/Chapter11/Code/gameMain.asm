//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 11
//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
    BasicUpstart(gameMainInit)

//==============================================================================
// Includes

*= $0810 "Code"
    #import "../../Library/libIncludes.asm"
    #import "gamePlayer.asm"
    #import "gameBar.asm"
    #import "gameLoungers.asm"
    #import "gameCrabs.asm"

//==============================================================================
// Constants

.const IrqFast = true
.const Irq1Scanline = 10
.const Irq2Scanline = 140

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_DISABLEBASICANDKERNAL()          // Disable BASIC and Kernal ROMs
    LIBUTILITY_SET1000_AV(SCREENRAM, Space)     // Clear the screen
    LIBSCREEN_SETSCREENCOLOR_V(YELLOW)          // Set the screen color
    
    LIBSPRITE_ENABLEALL_V(true)                 // Enable all 8 hardware sprites 
    LIBSPRITE_MULTICOLORENABLEALL_V(true)       // Set the sprite multicolor mode
    LIBSPRITE_SETMULTICOLORS_VV(LIGHT_RED, BROWN) // Set the sprite multicolors

    LIBSCREEN_SETMULTICOLORMODE_V(true)         // Set the background multicolor mode
    LIBSCREEN_SETMULTICOLORS_VV(BLACK, BROWN)   // Set the background multicolors
    LIBSCREEN_SETCHARMEMORY_V(CharacterSlot2000) // Set the custom character set
    LIBSCREEN_SETBACKGROUND_AA(gameDataBackground + (PlayerScreenTopLeft*1000), gameDataBackGroundCol) // Set the background screen

    LIBMATH_RANDSEED_AA(bMathRandomCurrent1, TIMALO) // Seed the random number lists
    LIBMATH_RANDSEED_AA(bMathRandomCurrent2, TIMALO)
    
    jsr gamePlayerInit      // Call the player initialize subroutine
    jsr gameBarInit         // Call the bar initialize subroutine
    jsr gameLoungersInit    // Call the loungers initialize subroutine

    LIBRASTERIRQ_INIT_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Initialize the irq

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)   // Wait for scanline 250
    LIBSPRITE_UPDATE()      // Update the sprites
    jsr gamePlayerUpdate    // Update the player subroutines
    jsr gameBarUpdate       // Update the bar subroutines
    jsr gameLoungersUpdate  // Update the loungers subroutines
    jsr gameCrabsUpdate     // Update the crabs subroutines
    jmp gameMainUpdate      // Jump back, infinite loop

//==============================================================================
// Interrupt Handlers

gameMainIRQ1:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    jsr gameCrabsUpdateTop
    LIBRASTERIRQ_SET_VAV(Irq2Scanline, gameMainIRQ2, IrqFast) // Point to the 2nd irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq

//==============================================================================        

gameMainIRQ2:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    jsr gameCrabsUpdateBottom
    LIBRASTERIRQ_SET_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Point to the 1st irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq    

//==============================================================================
// Data

#import "gameData.asm"