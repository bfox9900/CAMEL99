
# CAMEL99
Camel Forth for the TI-99
This code requires the XFC99 cross compiler that runs in DOSBOX or on MS DOS or a compatible OS.

The Forth system that is created is 99% true to the original Camel Forth by Brad Rodriguez but it has a few optimizations to better handle the low speed of the TI-99 computer.

Their are two primary source code files. This first file is 9900FAST.HSF which contains the "primitive" words of the Forth system. These are the small routines written Forth Assembler that are the foundation of how a Forth system gets things done. 

The second file is CAMEL99.HSF.  This file contains the rest of the sytem that is written in Forth. The routines in CAMEL99.HSF create the Forth interpreter and compiler. It also provides the system with hooks to the Video Display Peripheral (VDP) chip that TI-99 uses for it's terminal screen and it provides a hook to the keyboard scanning code that is in the TI-99 ROMs.

There is one "CODE" word (a word written in Forth Assembler) in CAMEL99.HSF. It is called INIT and sets up the CPU to become a Forth
Virtual machine. INIT also copies a few important pieces of code into the high speed memory of the TI-99. This improves the speed of the system by about 20%.  

The other files are features you can add the core system to explore the TI-99 or CAMEL99 itself.

This system is a work in progress by a hobbyist so you will no doubt find numerous errors and places for impovement. That is all good.

Do not hesitate to let me know a brian.fox@foxaudioresearch.ca

* HOW TO BUILD A WORKING CAMEL FORTH FOR TI-99
* To build the CAMEL99 binary program file for TI-99 please see INSTRUCTIONS.TXT file in this repository.
