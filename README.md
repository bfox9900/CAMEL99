# CAMEL99
Camel Forth for the TI-99
-------------------------

The file called CAMEL99 is a binary program file that should load and run on the TI-99 computer with the EDITOR/ASSEMBLER cartridge plugged into the console. The Forth system that is created is mostly true to the original Camel Forth by Brad Rodriguez but it has a few optimizations to better handle the low speed of the TI-99 computer.  Mostly notably the dictionary search has been re-written in Assembler and is called (FIND).
26
(See: 9900FAST.HSF)

Select "Option 5":  "RUN PROGRAM FILE"

At this stage it is NOT a completed system, but a cross-compiler demonstration.
Files in the LIB\ folder with the extension .FTH  can be pasted into the CLASSIC99 Emulator and they will compile and extend the system.

ABOUT CAMEL99
-------------
The final CAMEL99 Forth has been built for users of TI BASIC who want to explore Forth. With that in mind it has a string package that provides many of the features of BASIC including the use of a string stack and automated stack management. See the source file STRINGS.HSF to see the functions available and the comments at the bottom of the file provide some example code.  

Graphics Support:
The existing version of CAMEL99 also includes the GRAFIX99.HSF source code which provides common features of TI BASIC that relate the TI-99 display chip, the TMS9918.  Together these two extensions make a Forth system that is more familiar to the TI BASIC programmer.

NOTE: Files with the extension .HSF can only be compiled by the XFC99 cross-compiler. See the LIB folder for examples of CODE that will compile on CAMEL99.

BUILDING CAMEL99
----------------
To build this code requires the XFC99 cross compiler that runs in DOSBOX or on MS DOS or a compatible OS found in the COMPILER folder.

* To build the CAMEL99 binary program file for TI-99 please see INSTRUCTIONS.TXT file in this repository.

SOURCE CODE OVERVIEW
-----------------------
Their are two primary source code files. 
This first file is 9900FAST.HSF which contains the "primitive" words of the Forth system. These are the small routines written Forth Assembler that are the foundation of how a Forth system gets things done. 

The second file is CAMEL99.HSF.  This file contains the rest of the sytem that is written in Forth. The routines in CAMEL99.HSF create the Forth interpreter and compiler. It also provides the system with hooks to the Video Display Peripheral (VDP) chip that TI-99 uses for it's terminal screen and it provides a hook to the keyboard scanning code that is in the TI-99 ROMs.

There is one "CODE" word (a word written in Forth Assembler) in CAMEL99.HSF. It is called INIT and sets up the CPU to become a Forth
Virtual machine. INIT also copies a few important pieces of code into the high speed memory of the TI-99. This improves the speed of the system by about 20%.  

The other files are features you can add the core system to explore the TI-99 or CAMEL99 itself.

This system is a work in progress by a hobbyist so you will no doubt find numerous errors and places for impovement. That is all good.

Do not hesitate to let me know a brian dot fox at foxaudioresearch dot ca




