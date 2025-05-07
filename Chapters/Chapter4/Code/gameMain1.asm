//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 4_1
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

.const IrqFast = false
.const Irq1Scanline = 100
.const Irq2Scanline = 180

//==============================================================================
// Variables

irqVectorLowText:  .text "irq vector low  ($fffe): "
.byte 0
irqVectorHighText:  .text "irq vector high ($ffff): "
.byte 0

//============================================================================== 
// Inititialize

gameMainInit:
    LIBUTILITY_SET1000_AV(SCREENRAM, Space)         // Clear the screen
    LIBRASTERIRQ_INIT_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Initialize irq
    LIBSCREEN_DRAWTEXT_VVA(5, 0, irqVectorLowText)  // Draw IRQ vector low text
    LIBSCREEN_DEBUG8BIT_VVA(30, 0, $FFFE)           // Draw IRQ vector low byte
    LIBSCREEN_DRAWTEXT_VVA(5, 1, irqVectorHighText) // Draw IRQ vector high text
    LIBSCREEN_DEBUG8BIT_VVA(30, 1, $FFFF)           // Draw IRQ vector high byte
    

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_SETSCREENCOLOR_V(BLUE)
    jmp gameMainUpdate // Jump back, infinite loop

//==============================================================================
// Interrupt Routines

gameMainIRQ1:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    LIBSCREEN_SETSCREENCOLOR_V(GREEN)               // Set the screen color
    LIBUTILITY_WAITLOOP_V(50)                       // Wait for a while
    LIBRASTERIRQ_SET_VAV(Irq2Scanline, gameMainIRQ2, IrqFast) // Point to 2nd irq
    LIBSCREEN_SETSCREENCOLOR_V(WHITE)               // Set the screen color
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq
    
//==============================================================================        

gameMainIRQ2:
    LIBRASTERIRQ_START_V(IrqFast)                   // Start the irq
    LIBSCREEN_SETSCREENCOLOR_V(RED)                 // Set the screen color
    LIBUTILITY_WAITLOOP_V(50)                       // Wait for a while
    LIBRASTERIRQ_SET_VAV(Irq1Scanline, gameMainIRQ1, IrqFast) // Point to 1st irq
    LIBSCREEN_SETSCREENCOLOR_V(WHITE)               // Set the screen color
    LIBRASTERIRQ_END_V(IrqFast)                     // End the irq