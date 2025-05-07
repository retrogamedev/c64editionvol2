//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 12_1
//==============================================================================
// Basic Loader

*= $0801 "Basic Loader" 
    BasicUpstart(gameMainInit)

//==============================================================================
// Includes

*= $0810 "Code"
    #import "../../Library/libIncludes.asm"

//==============================================================================
// Constants

.const IrqFast = true
.const Irq1Scanline = 0

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_DISABLEBASICANDKERNAL()      // Disable BASIC and Kernal ROMs
    LIBUTILITY_SET1000_AV(SCREENRAM, Space) // Clear the screen
    LIBSCREEN_SETSCREENCOLOR_V(YELLOW)      // Set the screen color
    LIBSOUND_INIT_A(gameMainSID)            // Initialize the sound
    LIBRASTERIRQ_INIT_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Initialize the irq

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)   // Wait for scanline 250
    jmp gameMainUpdate      // Jump back, infinite loop

//==============================================================================
// Interrupt Handlers

gameMainIRQ1:
    LIBRASTERIRQ_START_V(IrqFast)   // Start the irq
    LIBSOUND_UPDATE_A(gameMainSID)  // Update the sound player
    LIBRASTERIRQ_END_V(IrqFast)     // End the irq

//==============================================================================
// Data

*= $1000 "Sounds" // Add sound data at the $1000 memory location
gameMainSID:
    // $7E is the size of the header to be skipped
    .import binary "..\..\Content\Bahama_Beach.sid", $7E