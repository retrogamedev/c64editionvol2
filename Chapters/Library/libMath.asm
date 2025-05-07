//==============================================================================
//                        RetroGameDev Library C64 v2.02
//==============================================================================
// Includes

#importonce
#import "libDefines.asm"

//==============================================================================
// Constants

.const MathRandomMax = 64

//==============================================================================
// Variables

// Random numbers 0->255
bMathRandoms1:  .byte  39, 58, 89,239,  3,238,218,114
                .byte  79,152, 49, 93,152, 33,230,179
                .byte 146,192,221,109,241,197, 67, 98
                .byte 166,126, 55, 21, 71,248, 76,126
                .byte 115,166,225,127,162, 37,144, 35
                .byte 237, 73, 61,131,124, 39, 32, 19
                .byte 230,191,195, 92, 49, 47,116,222
                .byte 167, 93,190, 42, 54, 80, 62,113 

bMathRandomCurrent1: .byte 0

// Random numbers 0->5
bMathRandoms2:  .byte   5,  1,  2,  0,  3,  0,  1,  2
                .byte   1,  1,  3,  2,  1,  5,  4,  3
                .byte   2,  4,  4,  0,  3,  5,  3,  1
                .byte   3,  2,  4,  0,  5,  0,  3,  3
                .byte   2,  3,  2,  3,  3,  2,  5,  4
                .byte   0,  4,  0,  3,  2,  5,  1,  1
                .byte   4,  5,  1,  1,  0,  1,  2,  0
                .byte   2,  1,  2,  4,  2,  1,  5,  3

bMathRandomCurrent2: .byte 0

//==============================================================================
// Macros

// http://www.6502.org/source/integers/hex2dec-more.htm
.macro LIBMATH_8BITTOBCD_AA(bIn, wOut)
{
    ldy bIn
    sty ZeroPage13  // Store in a temporary variable
    sed 		    // Switch to decimal mode
	lda #0          // Ensure the result is clear
	sta wOut
	sta wOut+1
	ldx #8		    // The number of source bits
cnvBit:
    asl ZeroPage13	// Shift out one bit
	lda wOut        // And add into result
	adc wOut
	sta wOut
	lda wOut+1	    // propagating any carry
	adc wOut+1
	sta wOut+1
	dex		        // And repeat for next bit
	bne cnvBit
	cld		        // Back to binary
}

//==============================================================================

// http://www.6502.org/source/integers/hex2dec-more.htm
.macro LIBMATH_16BITTOBCD_AAA(wIn, wOut, bOut)
{
    ldy wIn         // Save
    lda wIn+1
    sta ZeroPage1
    sed		        // Switch to decimal mode
	lda #0		    // Ensure the result is clear
	sta wOut
	sta wOut+1
	sta bOut
	ldx #16		    // The number of source bits
cnvBit:
    asl wIn	        // Shift out one bit
	rol wIn+1
	lda wOut	    // And add into result
	adc wOut
	sta wOut
	lda wOut+1	    // propagating any carry
	adc wOut+1
	sta wOut+1
	lda bOut	    // ... thru whole result
	adc bOut
	sta bOut
	dex		        // And repeat for next bit
	bne cnvBit
	cld		        // Back to binary
    sty wIn         // Restore
    lda ZeroPage1
    sta wIn+1
}

//==============================================================================

.macro LIBMATH_ADD8BIT_AAA(bNum1, bNum2, bSum)
{
    clc             // Clear carry before add
    lda bNum1       // Get first number
    adc bNum2       // Add to second number
    sta bSum        // Store in bSum
}

//=============================================================================

.macro LIBMATH_ADD8BIT_AVA(bNum1, bNum2, bSum)
{
    clc             // Clear carry before add
    lda bNum1       // Get first number
    adc #bNum2      // Add to second number
    sta bSum        // Store in sum
}

//==============================================================================         

.macro LIBMATH_ADD16BIT_AVA(wNum1, wNum2, wSum)
{
    clc             // Clear carry before first add
    lda wNum1       // Get LSB of first number
    adc #<wNum2     // Add LSB of second number
    sta wSum        // Store in LSB of bSum
    lda wNum1+1     // Get MSB of first number
    adc #>wNum2     // Add carry and MSB of NUM2
    sta wSum+1      // Store bSum in MSB of sum
}

//==============================================================================

.macro LIBMATH_GREATEREQUAL8BIT_AA(bNum1, bNum2)
{
    lda bNum1       // Load Number 1
    cmp bNum2       // Compare with Number 2
} // Test with bcc on return

//==============================================================================

.macro LIBMATH_MAX8BIT_AV(bNum1, bNum2)
{
    lda #bNum2      // Load Number 2
    cmp bNum1       // Compare with Number 1
    bcc skip        // If Number 2 < Number 1 then skip
    sta bNum1       // Else replace Number1 with Number2
skip:
}

//==============================================================================

// Adapted from https://codebase64.org/doku.php?id=base:16-bit_comparison
.macro LIBMATH_MAX16BIT_AV(wNum1, wNum2)
{
    lda wNum1+1     // high bytes
    cmp #>wNum2
    bcc LsThan      // hiVal1 < hiVal2 --> Val1 < Val2
    bne GrtEqu      // hiVal1 ≠ hiVal2 --> Val1 > Val2
    lda wNum1       // low bytes
    cmp #<wNum2
    bcs GrtEqu      // loVal1 ≥ loVal2 --> Val1 ≥ Val2
LsThan:
    lda #>wNum2     // replace wNum1 with wNum2
    sta wNum1+1
    lda #<wNum2
    sta wNum1
GrtEqu:
}

//==============================================================================

.macro LIBMATH_MIN8BIT_AV(bNum1, bNum2)
{
    lda #bNum2      // Load Number 2
    cmp bNum1       // Compare with Number 1
    bcs skip        // If Number 2 >= Number 1 then skip
    sta bNum1       // Else replace Number1 with Number2
skip:
}

//==============================================================================

// Adapted from https://codebase64.org/doku.php?id=base:16-bit_comparison
.macro LIBMATH_MIN16BIT_AV(wNum1, wNum2)
{
    lda wNum1+1     // high bytes
    cmp #>wNum2
    bcc LsThan      // hiVal1 < hiVal2 --> Val1 < Val2
    bne GrtEqu      // hiVal1 ≠ hiVal2 --> Val1 > Val2
    lda wNum1       // low bytes
    cmp #<wNum2
    bcs GrtEqu      // loVal1 ≥ loVal2 --> Val1 ≥ Val2
LsThan:
    jmp End         // end
GrtEqu:
    lda #>wNum2     // replace wNum1 with wNum2
    sta wNum1+1
    lda #<wNum2
    sta wNum1
End:
}

//==============================================================================

.macro LIBMATH_RAND_AAA(bArray, bCurrent, bOut)
{
    ldy bCurrent    // Load the array index into Y
    lda bArray,y    // Get the value at index into A
    sta bOut        // Store A into bOut
    inc bCurrent    // Increment the array index
    
    // if bCurrent == MathRandomMax, reset to 0
    lda bCurrent    
    cmp #MathRandomMax  
    bne end
    lda #0
    sta bCurrent
end:    
}

//==============================================================================

.macro LIBMATH_RANDSEED_AA(bCurrent, bSeed)
{ 
    lda bSeed               // Load seed value into A
    and #MathRandomMax-1    // Wrap around MathRandomMax
    sta bCurrent            // Store A into bCurrent
}

//==============================================================================

.macro LIBMATH_SUB8BIT_AAA(bNum1, bNum2, bSum)
{
    sec             // sec is the same as clear borrow
    lda bNum1       // Get first number
    sbc bNum2       // Subtract second number
    sta bSum        // Store in sum
}

//============================================================================== 

.macro LIBMATH_SUB8BIT_AVA(bNum1, bNum2, bSum)
{
    sec             // sec is the same as clear borrow
    lda bNum1       // Get first number
    sbc #bNum2      // Subtract second number
    sta bSum        // Store in sum
}

//==============================================================================        

.macro LIBMATH_SUB16BIT_AVA(wNum1, wNum2, wSum)
{
    sec             // sec is the same as clear borrow
    lda wNum1       // Get LSB of first number
    sbc #<wNum2     // Subtract LSB of second number
    sta wSum        // Store in LSB of bSum
    lda wNum1+1     // Get MSB of first number
    sbc #>wNum2     // Subtract borrow and MSB of NUM2
    sta wSum+1      // Store bSum in MSB of bSum
}