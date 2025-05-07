//==============================================================================
//                        RetroGameDev Library C64 v2.02
//==============================================================================
// Includes

#importonce
#import "libDefines.asm"
#import "libUtility.asm"
#import "libMath.asm"
#import "libSprite.asm"

//==============================================================================
// Variables

wScreenRAMRowStart: // SCREENRAM + 40*0, 40*1, 40*2, 40*3, 40*4 ... 40*24
    .word SCREENRAM,     SCREENRAM+40,  SCREENRAM+80,  SCREENRAM+120, SCREENRAM+160
    .word SCREENRAM+200, SCREENRAM+240, SCREENRAM+280, SCREENRAM+320, SCREENRAM+360
    .word SCREENRAM+400, SCREENRAM+440, SCREENRAM+480, SCREENRAM+520, SCREENRAM+560
    .word SCREENRAM+600, SCREENRAM+640, SCREENRAM+680, SCREENRAM+720, SCREENRAM+760
    .word SCREENRAM+800, SCREENRAM+840, SCREENRAM+880, SCREENRAM+920, SCREENRAM+960

wColorRAMRowStart: // COLORRAM + 40*0, 40*1, 40*2, 40*3, 40*4 ... 40*24
    .word COLORRAM,     COLORRAM+40,  COLORRAM+80,  COLORRAM+120, COLORRAM+160
    .word COLORRAM+200, COLORRAM+240, COLORRAM+280, COLORRAM+320, COLORRAM+360
    .word COLORRAM+400, COLORRAM+440, COLORRAM+480, COLORRAM+520, COLORRAM+560
    .word COLORRAM+600, COLORRAM+640, COLORRAM+680, COLORRAM+720, COLORRAM+760
    .word COLORRAM+800, COLORRAM+840, COLORRAM+880, COLORRAM+920, COLORRAM+960

//==============================================================================
// Macros

.macro LIBSCREEN_DEBUG8BIT_VVA(bXPos, bYPos, bIn)
{
    LIBMATH_8BITTOBCD_AA(bIn, ZeroPage4)
    lda ZeroPage4
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+2, bYPos, ZeroPage6)
    lda ZeroPage4
    lsr                 // get high nibble
    lsr
    lsr
    lsr
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+1, bYPos, ZeroPage6)
    lda ZeroPage5
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage6
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos, bYPos, ZeroPage6)
}

//==============================================================================

.macro LIBSCREEN_DEBUG16BIT_VVA(bXPos, bYPos, wIn)
{
    LIBMATH_16BITTOBCD_AAA(wIn, ZeroPage6, ZeroPage8)
    lda ZeroPage6
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage12
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+4, bYPos, ZeroPage12)
    lda ZeroPage6
    lsr                 // get high nibble
    lsr
    lsr
    lsr
    ora #$30            // convert to ascii
    sta ZeroPage12
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+3, bYPos, ZeroPage12)
    lda ZeroPage7
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage12
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+2, bYPos, ZeroPage12)
    lda ZeroPage7
    lsr                 // get high nibble
    lsr
    lsr
    lsr
    ora #$30            // convert to ascii
    sta ZeroPage12
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos+1, bYPos, ZeroPage12)
    lda ZeroPage8
    and #%00001111      // get low nibble
    ora #$30            // convert to ascii
    sta ZeroPage12
    LIBSCREEN_SETCHARACTER_S_VVA(bXPos, bYPos, ZeroPage12)
}

//==============================================================================

.macro LIBSCREEN_DRAWTEXT_VVA(bXPos, bYPos, string)
{
    lda #bYPos                  // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wScreenRAMRowStart,Y    // load low address byte
    sta ZeroPage2
    lda wScreenRAMRowStart+1,Y  // load high address byte
    sta ZeroPage3

    ldy #bXPos                  // load x position into Y register

    ldx #0
loop:
    lda string,X
    cmp #0
    beq done
    //cmp #Space
    //beq noAdjust
//noAdjust:
    sta (ZeroPage2),Y
    inx
    iny
    jmp loop
done:
}

//==============================================================================

.macro LIBSCREEN_GETCHARACTER_AAA(bXPos, bYPos, bOut)
{
    lda bYPos                   // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wScreenRAMRowStart,Y    // load low address byte
    sta ZeroPage2
    lda wScreenRAMRowStart+1,Y  // load high address byte
    sta ZeroPage3
    ldy bXPos                   // load x position into Y register
    lda (ZeroPage2),Y
    sta bOut
}

//==============================================================================

.macro LIBSCREEN_GETCOLOR_AAA(bXPos, bYPos, bOut)
{
    lda bYPos                   // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wColorRAMRowStart,Y     // load low address byte
    sta ZeroPage2
    lda wColorRAMRowStart+1,Y   // load high address byte
    sta ZeroPage3
    ldy bXPos                   // load x position into Y register
    lda (ZeroPage2),Y
    and #%00001111              // Only low 4 bits are valid in Color RAM
    sta bOut
}

//==============================================================================

.macro LIBSCREEN_PIXELTOCHAR_AAAA(wXPixels, bYPixels, bXChar, bYChar)
{
    // divide by 8 to get character X
    lda wXPixels
    lsr // divide by 2
    lsr // and again = /4
    lsr // and again = /8
    sta bXChar

    // Adjust for XHigh
    lda wXPixels+1
    beq nothigh
    LIBMATH_ADD8BIT_AVA(bXChar, 32, bXChar) // shift across 32 chars
nothigh:
    // divide by 8 to get character Y
    lda bYPixels
    lsr // divide by 2
    lsr // and again = /4
    lsr // and again = /8
    sta bYChar
}

//==============================================================================

.macro LIBSCREEN_PROFILESTART()
{
    inc EXTCOL  // Increase the border color
}

//==============================================================================

.macro LIBSCREEN_PROFILEEND()
{
    dec EXTCOL  // Decrease the border color
}

//==============================================================================

.macro LIBSCREEN_SETBACKGROUND_AA(wBackground, wColor)
{
    LIBSCREEN_SETDISPLAYENABLE_V(false) // Disable display while updating

    ldx #0                  // set x counter to 0
    loop:
    lda wBackground,x       // get background + x
    sta SCREENRAM,x         // set SCREENRAM + x
    tay                     // transfer accumulator to y register
    lda wColor,y            // get color + y
    sta COLORRAM,x          // set COLORRAM + x

    lda wBackground+250,x   // get background + 250 + x
    sta SCREENRAM+250,x     // set SCREENRAM + 250 + x
    tay                     // transfer accumulator to y register
    lda wColor,y            // get color + y
    sta COLORRAM+250,x      // set COLORRAM + 250 + x
    
    lda wBackground+500,x   // get background + 500 + x
    sta SCREENRAM+500,x     // set SCREENRAM + 500 + x
    tay                     // transfer accumulator to y register
    lda wColor,y            // get color + y
    sta COLORRAM+500,x      // set COLORRAM + 500 + x
    
    lda wBackground+750,x   // get background + 750 + x
    sta SCREENRAM+750,x     // set SCREENRAM + 750 + x
    tay                     // transfer accumulator to y register
    lda wColor,y            // get color + y
    sta COLORRAM+750,x      // set COLORRAM + 750 + x
    
    inx                     // increment x counter
    cpx #251
    bcc loop                // loop 250 times (4 sections x 250 = 1000 bytes set)
    
    LIBSCREEN_SETDISPLAYENABLE_V(true) // Re-enable display
}

//==============================================================================

.macro LIBSCREEN_SETBACKGROUNDCOLOR_V(bColor)
{
    lda #bColor     // Color -> A
    sta BGCOL0      // A -> background color
}

//==============================================================================

.macro LIBSCREEN_SETBORDERCOLOR_V(bColor)
{
    lda #bColor     // Color -> A
    sta EXTCOL      // A -> border color
}

//==============================================================================

.macro LIBSCREEN_SETCHARACTER_S_AAA(bXPos, bYPos, bChar)
{   
    lda bXPos
    sta ZeroPage1
    lda bYPos
    sta ZeroPage2
    lda bChar
    sta ZeroPage3
    jsr libScreenSetCharacter
}

.macro LIBSCREEN_SETCHARACTER_S_AAV(bXPos, bYPos, bChar)
{   
    lda bXPos
    sta ZeroPage1
    lda bYPos
    sta ZeroPage2
    lda #bChar
    sta ZeroPage3
    jsr libScreenSetCharacter
}

.macro LIBSCREEN_SETCHARACTER_S_VVA(bXPos, bYPos, bChar)
{
    lda #bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda bChar
    sta ZeroPage3
    jsr libScreenSetCharacter
}

.macro LIBSCREEN_SETCHARACTER_S_VVV(bXPos, bYPos, bChar)
{
    lda #bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda #bChar
    sta ZeroPage3
    jsr libScreenSetCharacter
}

libScreenSetCharacter:
    lda ZeroPage2               // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wScreenRAMRowStart,Y    // load low address byte
    sta ZeroPage9
    lda wScreenRAMRowStart+1,Y  // load high address byte
    sta ZeroPage10
    ldy ZeroPage1               // load x position into Y register
    lda ZeroPage3
    sta (ZeroPage9),Y
    rts

//==============================================================================

.macro LIBSCREEN_SETCHARMEMORY_V(bCharSlot)
{
    // Point vic (bits 1-3 of $d018) to new character data
    // CHARACTERSLOT_ defines show the memory address to locate the character data
    // remember to add the base VIC-II 16K start address
    lda VMCSB 
    and #%11110001      // Clear bits 1-3
    ora #bCharSlot      // Set bits 1-3 with the requested slot
    sta VMCSB
}

//==============================================================================

.macro LIBSCREEN_SETCOLOR_S_AAA(bXPos, bYPos, bColor)
{
    lda bXPos
    sta ZeroPage1
    lda bYPos
    sta ZeroPage2
    lda bColor
    sta ZeroPage3
    jsr libScreenSetColor
}

.macro LIBSCREEN_SETCOLOR_S_AVV(bXPos, bYPos, bColor)
{
    lda bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda #bColor
    sta ZeroPage3
    jsr libScreenSetColor
}

.macro LIBSCREEN_SETCOLOR_S_VVA(bXPos, bYPos, bColor)
{ 
    lda #bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda bColor
    sta ZeroPage3
    jsr libScreenSetColor  
}

.macro LIBSCREEN_SETCOLOR_S_VVV(bXPos, bYPos, bColor)
{
    lda #bXPos
    sta ZeroPage1
    lda #bYPos
    sta ZeroPage2
    lda #bColor
    sta ZeroPage3
    jsr libScreenSetColor  
}

libScreenSetColor:
    lda ZeroPage2               // load y position as index into list
    asl                         // X2 as table is in words
    tay                         // Copy A to Y
    lda wColorRAMRowStart,Y     // load low address byte
    sta ZeroPage4
    lda wColorRAMRowStart+1,Y   // load high address byte
    sta ZeroPage5
    ldy ZeroPage1               // load x position into Y register
    lda ZeroPage3
    sta (ZeroPage4),Y
    rts

//==============================================================================

.macro LIBSCREEN_SETDISPLAYENABLE_V(bEnable)
{
    lda SCROLY
    .if (bEnable)           // Build-time condition (not run-time)
    {
        ora #%00010000      // Set bit 4
    }
    else
    {
        and #%11101111      // Clear bit 4
    }
    sta SCROLY
}

//==============================================================================

.macro LIBSCREEN_SETMULTICOLORMODE_V(bEnable)
{
    lda SCROLX
    .if (bEnable)           // Build-time(not run-time)
    {
        ora #%00010000      // Set bit 4
    }
    else
    {
        and #%11101111      // Clear bit 4
    }
    sta SCROLX
}

//==============================================================================

.macro LIBSCREEN_SETMULTICOLORS_VV(bColor1, bColor2)
{                                           
    lda #bColor1    // Color1 -> Accumulator
    sta BGCOL1      // Accumulator -> BGCOL1
    lda #bColor2    // Color2 -> Accumulator
    sta BGCOL2      // Accumulator -> BGCOL2
}

//==============================================================================

.macro LIBSCREEN_SETSCREENCOLOR_V(bColor)
{  
    lda #bColor     // Color -> A
    sta EXTCOL      // A -> border color
    sta BGCOL0      // A -> background color
}

//==============================================================================

.macro LIBSCREEN_WAIT_V(wScanline) // (0-261 NTSC, 0-311 PAL)
{
loop:
    lda #<wScanline         // Scanline -> Accumulator        
    cmp RASTER              // Compare Accum to raster              
    bne loop                // Loop if not reached
    bit SCROLY              // Bit 7 of SCROLY ->N flag
    .if (wScanline <= 255)  // Build-time(not run-time)
    {   
        bmi loop            // Loop if N flag is 1
    }
    else
    {
        bpl loop            // Loop if N flag is 0
    }
}