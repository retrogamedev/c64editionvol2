Megatops BinCalc Readme
=========================================================
Megatops BinCalc is a binary calculator for developers.
It is available on Windows(for desktop) and Palm OS(for
smart phone & handhelds).


Main Features:
=================================================
* unique binary input method
* get bin/dec/hex input & display in one screen
* supports Intel/Freescale style bit numbering
  scheme (LSB 0 / MSB 0)
* signed/unsigned int 32 support (*)
* octal support (*)
* Unix file permission indicator (*)
* classic XYZT RPN calculator (*)

(*) Windows version only


Palm OS Version System Requirements:
=================================================
Palm OS 4.0+ (OS 5 Compatible)
50KB Free Memory
160x160 (OS4) or 320x320 (OS5) screen

Compatible Devices:
PDA:   Palm m500/505/515, Tungsten T/T2/T3/T5/E/E2/TX,
       Zire 21/71/72
Phone: Treo 180/270/650/680/700p

*NOT* compatible with Treo 600, Zire 21/22/31!


Windows Version System Requirements:
=================================================
Windows 2000/XP/2003


Differences between Windows & Palm OS Version:
=================================================
        Palm OS Ver.      Windows Ver.
-------------------------------------------------
Mode    Chain(simple)     Reverse Polish Notation
Stack   N/A               4 (X,Y,Z,T)
Base    Bin/Dec/Hex       Bin/Oct/Dec/Hex
Func.   Bitwise           Arithmetic, Bitwise
=================================================


Key-mappings in Windows Version:
=================================================
 Setting the base
-------------------------------------------------
 Tab            Cycles the keyboard input focus
 Ctrl + Tab     Same as Tab, but reversed the direction
 Shift + Tab    Same as Ctrl + Tab
 Ctrl + A       Set the keyboard focus to ASCII Char
 Ctrl + B       Set the keyboard focus to binary
 Ctrl + D       Set the keyboard focus to decimal
 Ctrl + H       Set the keyboard focus to hexadecimal
 Ctrl + I       Set the keyboard focus to IP address
 Ctrl + O       Set the keyboard focus to octal
-------------------------------------------------
 Entering the number
-------------------------------------------------
 1234567890     (As is)
 ABCDEF         (As is)
 Ctrl + S       Toggle Signed/Unsigned
 Enter          Enter
 Backspace      Bsp (As is)
 Esc            CLx (Clear X Register)
 Ctrl + Bksp    CLR (Clear all registers)
 Up Arrow       Stack up
 Down Arrow     Stack down
 Ctrl + C       Copy to clipboard (pure number)
 Ctrl + X       Same as Ctrl + C
 Ctrl + V       Paste from clipboard
-------------------------------------------------
 Do calculation
-------------------------------------------------
 + - * / .      (As is)
 Ctrl + -       +/- (2's)
 <              Shl (Shift left)
 >              Shr (Shift right)
 ~              Not
 %              Mod
 &              And
 |              Or
 ^              Xor
 Left Arrow     Shift left by 1
 Right Arrow    Shift right by 1
-------------------------------------------------
 Misc.
-------------------------------------------------
 Ctrl + R       Toggle "Hex View" in RPN calculator
 Ctrl + T       Toggle "Stay On Top"
=================================================


BinCalc Windows Version History:
=================================================
Mar 23, 2011. v1.0.4:
* Fixed binary string copy bug

Dec 21, 2008. v1.0.3:
* Added ASCII char copy & paste support
* More hotkeys supported:
  See Readme.txt for detailed key-mapping info.

Nov 12, 2008. v1.0.2:
* Minor bug fixed

Nov 8, 2008. v1.0.1:
* Shift left/right bug fixed:
  All shift operators are arithmetic now.

Aug 10, 2008. v1.0.0:
* Added IPv4 address support
* Added ASCII character input support
* Minor bugs fixed

Jun 28, 2008. v0.2g:
* Bit indicator tool-tips added 2^N value display

Dec 17, 2007. v0.2f:
* Minor bugs fixed

Nov 18, 2007. v0.2e:
* Added form position saving (supports multi-monitor)
* Added screen edge snapping

Nov 15, 2007. v0.2d:
* Added command line support (See CommandLine.txt)
* Added status save on close (in INI file)

Nov 8, 2007. v0.2c:
* Added keyboard support
* Fixed T register bug

Nov 6, 2007. v0.2b:
* Added octal support (UNIX file permission value
  friendly)
* Added separators in decimal display
* Added pop-up menu to switch bit label style
* Fixed some minor bugs

Feb 2, 2007. v0.1c:
* First version


BinCalc Palm OS Version History:
=================================================
Dec 3, 2006. v0.1c:
* Minor bug fixed.
* Size reduced.

Apr 11, 2006. v0.1b:
* Added bit numbering style switch
  o Intel style: MSB was numbered as 31 and LSB was
    marked as 0
  o Freescale style: MSB was numbered as 0 and LSB
    was marked as 31
* Bit order reverse function was removed. (Useless)

Dec 27, 2005. v0.1a:
* Added bit order reverse. (MSB-LSB/LSB-MSB)
* Cut off ANSI display function. (Useless)

Dec 25, 2005. v0.1:
* First version, a Xmas gift :)


About BinCalc:
=================================================
Megatops BinCalc Palm OS Version
(c)2005-2006 Ding Zhaojie
zhaojie.ding@gmail.com
Megatops Software, P.R.China

Megatops BinCalc Windows Version
(c)2007-2011 Ding Zhaojie
zhaojie.ding@gmail.com
Megatops Software, P.R.China

