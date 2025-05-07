//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameData
//==============================================================================
#importonce

*= $1000 "Sounds" // Add sound data at the $1000 memory location
gameDataSID:
    // $7E is the size of the header to be skipped
    .import binary "..\..\Content\Calypso_Bar.sid", $7E

SFX_Crab:          .byte $0E,$EE,$00,$DC,$81,$DC,$DC,$DC,$B1,$31,$B0,$AF,$AE,$AF,$AE,$AD,$AC,$90,$11,$00
SFX_Fail1:         .byte $0E,$EE,$00,$98,$21,$98,$98,$98,$98,$98,$94,$94,$94,$94,$94,$92,$92,$92,$92,$92,$90,$11,$00
SFX_Fail2:         .byte $0E,$EE,$00,$AC,$81,$AC,$21,$AB,$81,$AB,$21,$AA,$81,$AA,$21,$A9,$81,$A9,$21,$A8,$81,$A8,$21,$A7,$81,$A7,$21,$A6,$81,$A6,$21,$A5,$81,$A5,$21,$A4,$81,$A4,$21,$A3,$81,$A3,$21,$A2,$81,$A2,$21,$A1,$81,$A1,$21,$90,$11,$00
SFX_Great:         .byte $0E,$00,$00,$B0,$21,$B0,$B0,$B4,$B4,$B4,$B7,$B7,$B7,$BC,$BC,$BC,$A0,$11,$00
SFX_NewCustomer:   .byte $0E,$EE,$00,$CC,$11,$CC,$CC,$CC,$C8,$C8,$C8,$C8,$90,$00
SFX_Tadaah:        .byte $0E,$00,$33,$B0,$21,$B4,$B7,$BC,$A0,$11,$A0,$B0,$21,$B4,$B7,$BC,$B0,$B4,$B7,$BC,$B0,$B4,$B7,$BC,$B0,$B4,$B7,$BC,$B0,$B4,$B7,$BC,$A0,$11,$00

//==============================================================================

*= $2000 "Characters" // Add character data at the $2000 memory location
    .import binary "..\..\Content\BeachBarScreensCharset.bin" 

//==============================================================================

*= $2800 "Sprites" // Add sprite data at the $2800 memory location
    .import binary "..\..\Content\BeachBarSprites1.bin"
    .import binary "..\..\Content\BeachBarSprites2.bin"
    .import binary "..\..\Content\BeachBarSprites3.bin"
    .import binary "..\..\Content\BeachBarSprites4.bin"
    .import binary "..\..\Content\BeachBarSprites5.bin"
    .import binary "..\..\Content\BeachBarSprites6.bin"  

//==============================================================================    

*= $3080 "Screens" // Add background data at the $3080 memory location
gameDataBackground:
    .import binary "..\..\Content\BeachBarScreenTopLeft.bin"
    .import binary "..\..\Content\BeachBarScreenTopRight.bin"
    .import binary "..\..\Content\BeachBarScreenBottomLeft.bin"
    .import binary "..\..\Content\BeachBarScreenBottomRight.bin"
gameDataBackGroundCol:
    .import binary "..\..\Content\BeachBarScreensColors.bin"