//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameCrabs
//==============================================================================
// Includes

#importonce
#import "../../Library/libIncludes.asm"
#import "gamePlayer.asm"

//==============================================================================
// Constants

.const CrabsSpriteMax  =  6
.const CrabsAnimFrame1 = 32
.const CrabsAnimFrame2 = 33
.const CrabsAnimDelay  = 10
.const CrabsOffsetXMax = 70

//==============================================================================
// Variables

// arrays
bCrabsXStartArray:  .byte  35,110,185,105,180,255
bCrabsXArray:       .byte   0,  0,  0,  0,  0,  0
bCrabsYTopArray:    .byte  96, 96, 96,126,126,126
bCrabsYBottomArray: .byte 171,171,171,201,201,201
bCrabsDirArray:     .byte   0,  0,  0,  1,  1,  1 

// current element values
bCrabsSprite:       .byte 0
wCrabsX:            .word 0
bCrabsY:            .byte 0
bCrabsDir:          .byte 0

bCrabsXOffsetLeft:  .byte 0
bCrabsXOffset:      .byte 0
bCrabsSkipMove:     .byte 0

//==============================================================================

gameCrabsUpdate:
    // Only do if on Top Right or Bottom Right screen
    lda bPlayerMapScreen
    cmp #PlayerScreenTopRight
    beq gCUOK
    cmp #PlayerScreenBottomRight
    beq gCUOK
    jmp gCUEnd
gCUOK:
    // Init loop to 0
    ldx #0              
    stx bCrabsSprite
gCULoop:
    // Start from sprite 1 (x+1) - sprite 0 is the player
    inc bCrabsSprite

    // Set the sprite animation frames  
    LIBSPRITE_PLAYANIM_AVVVV(bCrabsSprite, CrabsAnimFrame1, CrabsAnimFrame2, CrabsAnimDelay, true)

    // Set the sprite color
    LIBSPRITE_SETCOLOR_AV(bCrabsSprite, RED)
    
    // Loop if < CrabsSpriteMax
    inx
    cpx #CrabsSpriteMax
    bne gCULoop
gCUEnd:
    // Update the x offset position
    jsr gameCrabsUpdateXOffset
    rts

//==============================================================================

gameCrabsUpdateXOffset:
     // Skip every other frame to slow down crabs movement
    lda bCrabsSkipMove
    eor #1              // Toggle
    sta bCrabsSkipMove
    bne gCUXEnd
    lda bCrabsXOffsetLeft
    beq gCUXRight       // If moving right jump to gCUXRight

    // Left directional movement
gCUXLeft:
    dec bCrabsXOffset   // Move left by 1
    bne gCUXEnd         // If not at 0, jmp to end
    lda #False          // If at 0, toggle left flag
    sta bCrabsXOffsetLeft
    jmp gCUXEnd         // Skip over right movement

    // Right directional movement 
gCUXRight:
    inc bCrabsXOffset   // Move right by 1
    lda bCrabsXOffset
    cmp #CrabsOffsetXMax
    bne gCUXEnd         // If not at CrabsOffsetXMax, jmp to end
    lda #True           // If at CrabsOffsetXMax, toggle left flag
    sta bCrabsXOffsetLeft
gCUXEnd:
    rts

//==============================================================================

gameCrabsUpdateTop:
    // Only do if on Top Right or Bottom Right screen
    lda bPlayerMapScreen
    cmp #PlayerScreenTopRight
    beq gCUTOK
    cmp #PlayerScreenBottomRight
    beq gCUTOK
    jmp gCUTEnd
gCUTOK:

    ldx #0
    stx bCrabsSprite
gCUTLoop:
    // Start from sprite 1 (x+1) - sprite 0 is the player
    inc bCrabsSprite

    // Get variables from arrays
    lda bCrabsXStartArray,x
    sta wCrabsX
    lda bCrabsYTopArray,x
    sta bCrabsY
    lda bCrabsDirArray,x
    sta bCrabsDir
    
    // Apply x offset to position
    lda bCrabsDir
    beq gCUTNotReverseDir
    // Add if going right
    LIBMATH_SUB8BIT_AAA(wCrabsX, bCrabsXOffset, wCrabsX)
    jmp gCUTReverseDirEnd
gCUTNotReverseDir:
    // Subtract if going left
    LIBMATH_ADD8BIT_AAA(wCrabsX, bCrabsXOffset, wCrabsX)
gCUTReverseDirEnd:

    // Set the sprite position
    LIBSPRITE_SETPOSITION_AAA(bCrabsSprite, wCrabsX, bCrabsY)

    // Set variables back to arrays
    lda wCrabsX
    sta bCrabsXArray,x

    // Loop if < CrabsSpriteMax
    inx
    cpx #CrabsSpriteMax
    bne gCUTLoop
gCUTEnd:
    rts

//==============================================================================

gameCrabsUpdateBottom:
    // Only do if on Top Right or Bottom Right screen
    lda bPlayerMapScreen
    cmp #PlayerScreenTopRight
    beq gCUBOK
    cmp #PlayerScreenBottomRight
    beq gCUBOK
    jmp gCUBEnd
gCUBOK:

    ldx #0
    stx bCrabsSprite
gCUBLoop:
    // Start from sprite 1 (x+1) - sprite 0 is the player
    inc bCrabsSprite

    // Get variables from arrays
    lda bCrabsXArray,x
    sta wCrabsX
    lda bCrabsYBottomArray,x
    sta bCrabsY

    // Set the sprite position
    LIBSPRITE_SETPOSITION_AAA(bCrabsSprite, wCrabsX, bCrabsY)

    // Loop if < CrabsSpriteMax
    inx
    cpx #CrabsSpriteMax
    bne gCUBLoop
gCUBEnd:
    rts

