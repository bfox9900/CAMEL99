#README

##CAMEL99 BINARY FILES

This folder contains binary files that are in the TI-99 EA5 program file format.
They can be loaded with the Editor Assembler cartridge menu option 5: "LOAD PROGRAM FILE"
Note: All programs have only been tested with the CLASSIC99 emulator, not on real hardware.

###V1.99 Notes
I have made a change in philospy with 1.99.  It does not contain the GRAFIX2.HSF code in
the binary program.  Instead I have included MTASK99.HSF the cooperative multi-tasker.

V1.99 also a new SCROLL word that manages the heap in LOW mem properly and instead of taking
an entire screen of memory from the HEAP, it only allocates one line.  This was changed because 80cols
mode took 1920 bytes in the heap everytime it scrolled. The old SCROLL is still in the code
and you can recompile the program by changing the 0 to a -1 at the [IF] just before it. The new SCROLL
is about 12% slower but is better behaved.

And of course nothing prevents you from building your own program with GRAPHICS mode pre-
compiled in the binary.

V1.99 also incorporates some changes in the program to make use of Forth 2012 thinking that
made the final program smaller. A few bytes here and there never hurts.

### Updates to V1.99  
It's polite but I had to do a lot of space saving to be able to load new CRU words and GRAFIX2 into the 8K kernel.
So it's done. This version uses a new simplified VDP driver and a simplified KEY? word.
Be sure to try BANK.FTH to explore the SAMS memory (940K available) under Classic99 emulator.
