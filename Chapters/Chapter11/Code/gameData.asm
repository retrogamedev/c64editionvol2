//==============================================================================
//                 RetroGameDev C64 Edition Volume 2 gameData
//==============================================================================
#importonce

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