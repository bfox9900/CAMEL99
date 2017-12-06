# CAMEL99
Camel Forth V1.9 for the TI-99
------------------------------
## Change History
Oct 7, 2017  - Version 1.9 includes POSTPONE, ;CODE and DOES>
- 99.2% ANS CORE compliant. Missing 1 word: ENVIRONMENT?
- change to CHARDEF in GRAFIX2.FTH         
- Now uses pointer to data, not stack data             
- S" now uses a string POOL at >2000            
- HEAP memory system added. Starts at >2180             
- Target loops now in separate file. (targloop.hsf)             
- LEAVE has been implemented per CAMEL Forth method               
- numerous speedups and size reductions in CODE words              
- new word: ^C? scans keyboard for control C. 4X faster than KEY?                
- TMR! TMR@ let you use the 9901 timer for limit timing MAX duration is 325mS            
- MS word uses the 9901 timer for accurate delays in milli-seconds 

Oct 19, 2017
- Factored (:NONAME) out of HEADER. (Idea from GForth) Created :NONAME and refactored HEADER
- Removed duplicate code from S".  Saves 6 bytes in the binary image

Nov 26, 2017
- fixed bug in new word 'CHARDEF' (GRAFIX2.HSF and GRAFIX2.FTH)  writing too many bytes to VDP.
- REMOVED ^C? word from kernel and replaced with ?TERMINAL. Common word name in old systems. 
  ?TERMINAL also 7X faster than using KEY? because it calls a ROM routine to detect only the 
  'FUNCTION 4' key on the TI-99 which is the "BREAK" key in TI BASIC. 
- Continued to clean and update /LIB, /CCLIB and /DEMO folders to keep the source code compatible with the CAMEL99
  program in /BIN .  
- added MUSIC.FTH to /DEMO  
  
  *** Please report bugs in any of the files to theBF on atariage.com or foxaudioresearch at gmail dot com.
  
Dec 5, 2017
  Added support for INLINE[ ] code in colon definitions. See LIB/INLINE99.FTH

## Description
The file called CAMEL99 is a binary program file that should load and run on the TI-99 computer with the EDITOR/ASSEMBLER cartridge plugged into the console. The Forth system that is created is mostly true to the original Camel Forth by Brad Rodriguez but it has a few optimizations to better handle the low speed of the TI-99 computer.  Mostly notably the dictionary search has been re-written in Assembler and is called (FIND). (See: 9900FAST.HSF)

At this stage it is NOT a completed system, but a cross-compiler demonstration. V1.9 has no file interface to the TI-99 OS.

Files in the LIB\ folder with the extension .FTH can be pasted into the CLASSIC99 TI-99 Emulator and they will compile and extend the system.

### Optional Binary Programs
------------------------
In the BIN folder we have added KERNEL99 which is a minimal system running in 40 column text mode. There is also MULTICAM a TI-99 program binary that includes the GRAPHICS library and the multi-tasking code. Multicam is required to load the SPRITE demo program.

### Multitasking Version
--------------------
There is also a cooperative multi-tasking version. If you load the file MULTICAM
you can paste in demonstration code called MTASKDEM.FTH found in the LIB folder.

### To RUN CAMEL99 Binary program files
-----------------------------------
Insert the EDITOR/ASSEMBLER cartridge
Select "Option 5":  "RUN PROGRAM FILE"
Type:  DSK1.CAMEL99   ( or KERNEL99  or MULTICAM )

### ABOUT CAMEL99
-------------
The final CAMEL99 Forth has been built for users of TI BASIC who want to explore Forth. With that in mind it has a string package that provides many of the features of BASIC including the use of a string stack and automated stack management. See the source file LIB/STRINGS.FTH to see the functions available and the comments at the bottom of the file provide some example code.  

Graphics Support:
The existing version of CAMEL99 also includes the GRAFIX2.HSF source code which provides common features of TI BASIC (VCHAR, HCHAR, GCHAR CLEAR etc.)that relate the TI-99 display chip, the TMS9918.  The graphics and string extensions make a Forth system that is a little more familiar to the TI BASIC programmer however it is still Forth and not BASIC. You are warned.

### File extensions
Files with the extension .HSF can only be compiled by the XFC99 cross-compiler. 
Files with the .FTH extension are in the LIB/ folder and they are meant to be compiled on the TI-99.
(currently they must be pasted into the CLASSIC99 emulator)

### BUILDING CAMEL99
----------------
To build this code requires the XFC99 cross compiler that runs in DOSBOX or on MS DOS or a compatible OS found in the COMPILER folder.

* To build the CAMEL99 binary program file for TI-99 please see INSTRUCTIONS.TXT file in this repository.

### SOURCE CODE OVERVIEW
-----------------------
Their are two primary source code files. 
This first file is 9900FAST.HSF which contains the "primitive" words of the Forth system. These are the small routines written Forth Assembler that are the foundation of how a Forth system gets things done. 

The second file is CAMEL99.HSF.  This file contains the rest of the sytem that is written in Forth. 

At the beginning of CAMEL99.HSF there is a include statement to compile BRCHLOOP.HSF. This file builds the final pieces of the cross compiler to allow it to make IF ELSE THEN, BEGIN UNTIL etc.. and it also creates the CROSS COMPILING versions of ':' and ';'.

The routines in CAMEL99.HSF create the TI-99 Forth interpreter and compiler. It also provides the system with I/O hooks to the Video Display Peripheral (VDP) chip that TI-99 uses for it's terminal screen in the form of Forth's EMIT TYPE word.

The keyboard scanning code that is in the TI-99 ROMs is called by one CODE word KEY? which only returns TRUE or FALSE.  The rest of the keyboard interface is in Forth.

There is one "CODE" word (a word written in Forth Assembler) in CAMEL99.HSF. It is called INIT and sets up the CPU to become a Forth Virtual machine. INIT also copies a few important pieces of code into the high speed memory of the TI-99. This improves the speed of the system by about 20%.  

The other files are features you can add the core system to explore the TI-99 or CAMEL99 itself.

*WARNING* The binary code image file cannot be bigger than 8192 bytes at this time.  The compiler will ABORT at the end 
of the build cycle and report that the memory is image is greater than 8192 bytes.

- See the comment \ ADDONS in CAMEL99.HSF to see how to include CCLIB/ files
Including TOOLS.HSF and GRAFIX2.HSF fills it up to capacity.

This system is a work in progress by a hobbyist so you will no doubt find numerous errors and places for impovement. That is all good.

Do not hesitate to let me know at brian dot fox at foxaudioresearch dot ca

### TWO DIFFERENT TYPES OF LIBRARY FILES
------------------------------------

The cross compiler source files require some extra commands to control the cross-compiler and so cannot be loaded onto the TI-99 CAMEL99 Forth system.  These files end with the extension '.HSF'  (HsForth) and are kept in the CCLIB folder.

The Library files for CAMEL99 Forth, that compile on the TI-99 CAMEL99 system, are in the LIB folder and use the extension '.FTH'  

For the most part, with the exception of hardware specfic extensions, the libary code is ANS Standard Forth. CAMEL99 has the CORE word set minus the word ENVIRONMENT?  About 60% of the CORE Extension word set is also part of CAMEL99.


