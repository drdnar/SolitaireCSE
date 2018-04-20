@echo off
echo Assembling . . .
echo.
brass solitaire.asm solitaire.hex -l solitaire.html
echo .defcont +1>> build_number.asm
echo.
echo Signing. . . .
rabbitsign -g -o solitaire.8ck solitaire.hex
echo.
echo Build complete.
echo.