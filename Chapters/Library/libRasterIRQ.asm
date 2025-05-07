//==============================================================================
//                        RetroGameDev Library C64 v2.02
//==============================================================================
// Includes

#importonce
#import "libDefines.asm"

//==============================================================================
// Macros

.macro LIBRASTERIRQ_INIT_VAV(wScanline, wIrq, bFast)
{
    sei                 // Disable IRQ's
    lda #%01111111      // Bit 7 off
    sta CIAICR          // Turn off CIA1 timer interrupts
    sta CI2ICR          // Turn off CIA2 timer interrupts
    lda CIAICR          // Cancel all CIA1-IRQs in queue
    lda CI2ICR          // Cancel all CIA2-IRQs in queue
    LIBRASTERIRQ_SET_VAV(wScanline, wIrq, bFast) // Set the IRQ scanline
    lda #%00000001      // Bit 0 on
    sta IRQMSK          // Enable raster interrupt signals from VIC-II
    cli                 // Enable IRQ's     
}

//==============================================================================

.macro LIBRASTERIRQ_START_V(bFast)
{
    .if (bFast) // Build-time condition (not run-time)
    {
        // Store A, X & Y registers on the stack
        pha     // PusH Accumulator on stack 
        txa     // Transfer X to Accumulator
        pha     // PusH Accumulator on stack
        tya     // Transfer Y to Accumulator
        pha     // PusH Accumulator on stack
    }
}

//==============================================================================

.macro LIBRASTERIRQ_END_V(bFast)
{
    // Acknowledge the interrupt by clearing the VIC-II's
    // interrupt flag. All raster interrupts must be
    // acknowledged for the current frame or the VIC-II
    // will keep repeating it.
    
    //lda #%00001111
    //sta VICIRQ // How to docs say to acknowledge IRQ
    asl VICIRQ   // Faster method due to quirk of VIC-II  

    .if (bFast) // Build-time condition (not run-time)
    {
        // Restore Y, X & A registers from the stack
        pla     // PulL Accumulator from stack        
        tay     // Transfer Accumulator to Y
        pla     // PulL Accumulator from stack
        tax     // Transfer Accumulator to X
        pla     // PulL Accumulator from stack
        rti     // ReTurn from Interrupt
    }
    else
    {
        jmp IRQROMROUTINE // Jump to the default irq routine
    }
}

//==============================================================================

.macro LIBRASTERIRQ_SET_VAV(wScanline, wIrq, bFast)
{
    // Scanline (0-261 for NTSC / 0-311 for PAL)
    lda #<wScanline     // Scanline low byte -> A
    sta RASTER          // A -> raster line register
    lda SCROLY
    .if (wScanline > 255)// Build-time condition (not run-time)
    {
        ora #%10000000  // Set most significant bit of VIC's raster register
    }
    else
    {
        and #%01111111  // Clear most significant bit of VIC's raster register
    }
    sta SCROLY

    ldx #<wIrq          // Load this IRQ's vector
    ldy #>wIrq
    .if (bFast)         // Store in the current IRQ vector
    {
        stx IRQROMVECTOR
        sty IRQROMVECTOR+1
    }
    else
    {
        stx IRQRAMVECTOR
        sty IRQRAMVECTOR+1
    }
}