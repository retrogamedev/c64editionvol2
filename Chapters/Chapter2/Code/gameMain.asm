//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 Chapter 2
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
    LIBUTILITY_SET1000_AV(SCREENRAM, '2') // fill the screen characters with 2's
    LIBUTILITY_SET1000_AV(COLORRAM, RED)  // fill the screen colors with red

    // Put the number 5 in memory location $FB
    lda #5  // (l)oa(d) the (a)ccumulator with the value 5
    sta $FB // (st)ore the value in the (a)ccumulator to $FB 

    // Copy a byte from one memory location to another
    lda $FB // (l)oa(d) the (a)ccumulator with the value in $FB
    sta $FC // (st)ore the value in the (a)ccumulator to $FC

    // Set the background color using a macro
    GAMEMAIN_SETBACKGROUNDCOLOR_V(CYAN)

    // Set the green border color using a subroutine
    jsr gameMainSetBorderColorGreen

    // Set the border color using a wrapped subroutine
    GAMEMAIN_SETBORDERCOLOR_S_V(LIGHT_BLUE)

    // Put the number 8 in memory location $FE
    lda #8 // (l)oa(d) the (a)ccumulator with the value 8
    ldx #3 // (l)oa(d) the x register with the value 3
    sta $FB,x // (st)ore the value in A to $FE 

//==============================================================================
// Update

gameMainUpdate:
    LIBSCREEN_WAIT_V(250)   // Wait for scanline 250
    jmp gameMainUpdate      // Jump back, infinite loop

//==============================================================================
// Macros

// Set the background color
.macro GAMEMAIN_SETBACKGROUNDCOLOR_V(bColor)
{
    lda #bColor // bColor -> A
    sta BGCOL0  // A -> background color register
}

//==============================================================================
// Subroutines

// Set the border color
gameMainSetBorderColorGreen:
{
    lda #GREEN  // GREEN (5) -> A
    sta EXTCOL  // A -> border color register
    rts         // Return from subroutine
}

//==============================================================================
// Wrapped Subroutines

// Set the border color
.macro GAMEMAIN_SETBORDERCOLOR_S_V(bColor)
{
    lda #bColor                 // bColor -> A
    sta ZeroPage1               // A -> ZeroPage1
    jsr gameMainSetBorderColor  // Jump to subroutine
}

gameMainSetBorderColor:
{
    lda ZeroPage1   // ZeroPage1 -> A
    sta EXTCOL      // A -> border color register
    rts             // Return from subroutine
}