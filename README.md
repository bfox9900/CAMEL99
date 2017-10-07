# CAMEL99
Camel Forth for the TI-99
-------------------------

The file called CAMEL99 is a binary program file that should load and run on the TI-99 computer with the EDITOR/ASSEMBLER cartridge plugged into the console. The Forth system that is created is mostly true to the original Camel Forth by Brad Rodriguez but it has a few optimizations to better handle the low speed of the TI-99 computer.  Mostly notably the dictionary search has been re-written in Assembler and is called (FIND). (See: 9900FAST.HSF)

At this stage it is NOT a completed system, but a cross-compiler demonstration.
Files in the LIB\ folder with the extension .FTH  can be pasted into the CLASSIC99 TI-99 Emulator and they will compile and extend the system.

Optional Binary Programs
------------------------
In the BIN folder we have added KERNEL99 which is a minimal system running in 40 column text mode. There is also MULTICAM a TI-99 program binary that includes the GRAPHICS library and the multi-tasking code. Multicam is required to load the SPRITE demo program.

Multitasking Version
--------------------
There is also a cooperative multi-tasking version. If you load the file MULTICAM
you can paste in demonstration code called MTASKDEM.FTH found in the LIB folder.

To RUN CAMEL99 Binary program files
-----------------------------------
Insert the EDITOR/ASSEMBLER cartridge
Select "Option 5":  "RUN PROGRAM FILE"
Type:  DSK1.CAMEL99   ( or KERNEL99  or MULTICAM )


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

The second file is CAMEL99.HSF.  This file contains the rest of the sytem that is written in Forth. 

At the beginning of CAMEL99.HSF their is a include statement to compile BRCHLOOP.HSF. This file builds the final pieces of the cross compiler to allow it to make IF ELSE THEN, BEGIN UNTIL etc.. and it also creates the CROSS COMPILING versions of ':' and ';'.

The routines in CAMEL99.HSF create the TI-99 Forth interpreter and compiler. It also provides the system with I/O hooks to the Video Display Peripheral (VDP) chip that TI-99 uses for it's terminal screen in the form of Forth's EMIT TYPE word.

The keyboard scanning code that is in the TI-99 ROMs is called by one CODE word KEY? which only returns TRUE or FALSE.  The rest of the keyboard interface is in Forth.

There is one "CODE" word (a word written in Forth Assembler) in CAMEL99.HSF. It is called INIT and sets up the CPU to become a Forth
Virtual machine. INIT also copies a few important pieces of code into the high speed memory of the TI-99. This improves the speed of the system by about 20%.  

The other files are features you can add the core system to explore the TI-99 or CAMEL99 itself.

*WARNING* The binary code image file cannot be bigger than 8192 bytes at this time.  
Including TOOLS.HSF, STRINGS.HSF and GRAFIX99.HSF fills it up to capacity.

This system is a work in progress by a hobbyist so you will no doubt find numerous errors and places for impovement. That is all good.

Do not hesitate to let me know a brian dot fox at foxaudioresearch dot ca




