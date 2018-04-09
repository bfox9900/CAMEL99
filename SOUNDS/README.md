# Sound Lists

The TI-99 computer used a data structure called a sound list. This is set one or more counted strings that hold control bytes for the TMS9919 sound chip with the final byte being the duration. Typically these are run by the system under interrupt control.
Theses example sound lists are taken from PARSEC and other sound lists found online.
You hear them on CAMEL99 by loading the PLAYSND.FTH file onto the kernel.

This demo: https://github.com/bfox9900/CAMEL99/blob/master/Demo/PLAYSND.FTH

gives CAMEL99 Forth the ability to create these lists as source code in a manner that is very similar to TI Assembler so you can transplant ASM sound lists to CAMEL99 easily. We also provide a simple player that takes the address of a sound list as a the input argument.  The FORTH sound list player in the Demo is not interrupt driven and so delays executing code until the sounds are complete. They do however run acurately to time due to the use of the TMS9901 hardware timer being used for timing.

For an example of how to play sound lists in the background using the multi-tasker see:
https://github.com/bfox9900/CAMEL99/blob/master/Demo/PLAYSND2.FTH

You can also change these files to store the sound lists in VDP memory which then uses a very small amount for Forth dictionary space.
SEE: https://github.com/bfox9900/CAMEL99/blob/master/lib/VDPSOUND.FTH

