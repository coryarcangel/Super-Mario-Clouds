Super Mario Clouds v2k9.  

This is Super Mario Clouds v2k9. The main difference between this and v2k3 is that I have fixed a sprite error in one of the clouds. This error was brought to my attention  by Jack Grahl so thanks to Jack for having a sharp eye and finding a mistake! To compile this code requires Bob Rost's nbasic, and the 6502 complier nesasm.  It complies on OSX.  A typical compile routine would be like this:

> nbasic clouds.bas -quiet -o clouds.asm 
> nesasm clouds.asm 
> open clouds.nes

Please drag the compilers (nbasic and nesasm) into your BIN directory.

Thanks!,
Cory Arcangel
