#!/bin/bash

FILE=$(readlink -f "$0")
DIR=$(dirname "$FILE")

cd "$DIR"

wine x64.exe -config vice_en.ini -cartgmod2 "sams-journey-gmod2-flash.bin" -gmod2eepromimage "sams-journey-gmod2-eeprom.bin"

