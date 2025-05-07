//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 4_3
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

.const SpriteMax        = 8
.const AnimDelay        = 7
.const ScanlineOffset   = 7
.const IrqFast          = true
.const IrqSpacing       = 29
.const Irq1Scanline     = 43
.const Irq2Scanline = Irq1Scanline + IrqSpacing
.const Irq3Scanline = Irq2Scanline + IrqSpacing
.const Irq4Scanline = Irq3Scanline + IrqSpacing
.const Irq5Scanline = Irq4Scanline + IrqSpacing
.const Irq6Scanline = Irq5Scanline + IrqSpacing
.const Irq7Scanline = Irq6Scanline + IrqSpacing

//==============================================================================
// Variables

// arrays (1 element per sprite)
bStartFrameArray:   .byte   0, 2, 4, 6, 0, 2, 4, 6
bEndFrameArray:     .byte   1, 3, 5, 7, 1, 3, 5, 7
wXPosRow1Array:     .word   30-4, 70+5, 110-2, 150+2, 190-1, 230+1, 270-2, 310+5
wXPosRow2Array:     .word   110+4, 150-2, 190+2, 230-1, 270-3, 310+4, 30-5, 70+3
wXPosRow3Array:     .word   190-3, 230+2, 270-4, 310+5, 30-2, 70+4, 110-3, 150+5
wXPosRow4Array:     .word   270+4, 310-3, 30+5, 70-3, 110+2, 150-3, 190+5, 230-3
wXPosRow5Array:     .word   70-5, 110+1, 150-2, 190+3, 230-1, 270+2, 310-4, 30+5
wXPosRow6Array:     .word   150+2, 190-1, 230+3, 270-5, 310+4, 30-5, 70+1, 110-4
wXPosRow7Array:     .word   230-3, 270+5, 310-2, 30+3, 70-4, 110+2, 150-3, 190+1

// current element values
bSprite:            .byte 0
bStartFrame:        .byte 0
bEndFrame:          .byte 0
wXPos:              .word 0

//============================================================================== 
// Initialize

gameMainInit:
    LIBUTILITY_DISABLEBASICANDKERNAL()          // Disable BASIC and Kernal ROMs
    LIBUTILITY_SET1000_AV(SCREENRAM, Space)     // Clear the screen
    LIBSCREEN_SETSCREENCOLOR_V(YELLOW)          // Set the screen color
    LIBRASTERIRQ_INIT_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Initialize the irq
    LIBSPRITE_ENABLEALL_V(true)                 // Enable all 8 hardware sprites 
    LIBSPRITE_MULTICOLORENABLEALL_V(true)       // Set the sprite multicolor mode
    LIBSPRITE_SETMULTICOLORS_VV(LIGHT_RED, BROWN) // Set the sprite multicolors
    GAMEMAIN_SPRITESANIMINIT()                  // Initialize the sprite animations

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)   // Wait for scanline 250
    LIBSPRITE_UPDATE()      // Update the sprites
    jmp gameMainUpdate      // Jump back, infinite loop

//==============================================================================
// Interrupt Handlers

gameMainIRQ1:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow1Array, Irq1Scanline + ScanlineOffset, BLACK)
    LIBRASTERIRQ_SET_VAV(Irq2Scanline, gameMainIRQ2, IrqFast) // Point to 2nd irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq

//==============================================================================        

gameMainIRQ2:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow2Array, Irq2Scanline + ScanlineOffset, RED)
    LIBRASTERIRQ_SET_VAV(Irq3Scanline, gameMainIRQ3, IrqFast) // Point to 3rd irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq

//==============================================================================        

gameMainIRQ3:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow3Array, Irq3Scanline + ScanlineOffset, CYAN)
    LIBRASTERIRQ_SET_VAV(Irq4Scanline, gameMainIRQ4, IrqFast) // Point to 4th irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq 

//==============================================================================        

gameMainIRQ4:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow4Array, Irq4Scanline + ScanlineOffset, PURPLE)
    LIBRASTERIRQ_SET_VAV(Irq5Scanline, gameMainIRQ5, IrqFast) // Point to 5th irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq 

//==============================================================================        

gameMainIRQ5:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow5Array, Irq5Scanline + ScanlineOffset, GREEN)
    LIBRASTERIRQ_SET_VAV(Irq6Scanline, gameMainIRQ6, IrqFast) // Point to 6th irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq 

//==============================================================================        

gameMainIRQ6:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow6Array, Irq6Scanline + ScanlineOffset, BLUE)
    LIBRASTERIRQ_SET_VAV(Irq7Scanline, gameMainIRQ7, IrqFast) // Point to 7th irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq 

//==============================================================================        

gameMainIRQ7:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    GAMEMAIN_SPRITESUPDATE_VV(wXPosRow7Array, Irq7Scanline + ScanlineOffset, LIGHT_BLUE)
    LIBRASTERIRQ_SET_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Point to 1st irq
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq                    

//==============================================================================
// Macros

.macro GAMEMAIN_SPRITESANIMINIT()
{
    ldx #0  // Start at index 0
    stx bSprite
loop:
    // Read this element's variables
    lda bStartFrameArray,x
    sta bStartFrame
    lda bEndFrameArray,x
    sta bEndFrame
    // Set the sprite animation details
    LIBSPRITE_PLAYANIM_AAAVV(bSprite, bStartFrame, bEndFrame, AnimDelay, true)
    // Loop for SpriteMax times
    inx
    inc bSprite
    cpx #SpriteMax
    bne loop
}

//==============================================================================

.macro GAMEMAIN_SPRITESUPDATE_VV(wXPosArray, bYPos, bColor)
{
    // These are unrolled for speed - i.e. not put into a loop
    LIBSCREEN_PROFILESTART()
    LIBSPRITE_SETALLCOLORS_V(bColor)
    LIBSPRITE_SETPOSITION_VAV(0, wXPosArray, bYPos)
    LIBSPRITE_SETPOSITION_VAV(1, wXPosArray + (2*1), bYPos)
    LIBSPRITE_SETPOSITION_VAV(2, wXPosArray + (2*2), bYPos)
    LIBSPRITE_SETPOSITION_VAV(3, wXPosArray + (2*3), bYPos)
    LIBSPRITE_SETPOSITION_VAV(4, wXPosArray + (2*4), bYPos)
    LIBSPRITE_SETPOSITION_VAV(5, wXPosArray + (2*5), bYPos)
    LIBSPRITE_SETPOSITION_VAV(6, wXPosArray + (2*6), bYPos)
    LIBSPRITE_SETPOSITION_VAV(7, wXPosArray + (2*7), bYPos)
    LIBSCREEN_PROFILEEND()
}

//==============================================================================
// Data

*= $2800 "Sprites" // Add sprite data at the $2800 memory location
.import binary "..\..\Content\BeachBarSprites1.bin"


