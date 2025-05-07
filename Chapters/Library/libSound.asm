//==============================================================================
//                        RetroGameDev Library C64 v2.02
//==============================================================================
// Includes

#importonce

//==============================================================================
// Variables

soundIsPAL:         .byte 0
soundNTSCTimer:     .byte 0

//==============================================================================
// Macros

.macro LIBSOUND_INIT_A(wSidfile)
{
    lda $02A6
    sta soundIsPAL  // Get system type
    lda #0          
    tax 
    tay 
    jsr wSidfile    // initialize music
}    

//==============================================================================    

.macro LIBSOUND_PLAYSFX_AA(wSidfile, wSound)   
{   
    lda #<wSound
    ldy #>wSound
    ldx #14
    jsr wSidfile+6
}

//==============================================================================

.macro LIBSOUND_UPDATE_A(wSidfile)
{
    lda soundIsPAL
    cmp #1 //Is system PAL?
    beq pal //Yes.
    //System is NTSC
    inc soundNTSCTimer
    lda soundNTSCTimer
    cmp #6 // Music delay
    beq resetNTSCTimer  
pal:
    jsr wSidfile+3
    jmp end
resetNTSCTimer:
    lda #0
    sta soundNTSCTimer
end:    
}