( ORIGINAL TI-FORTH ASSEMBLER modified slightly by Mark Wills, Turboforth)
( and more changes for CAMEL99 file based source code by Brian Fox )

.( TI-99 Assembler ...)

( VOCABULARY ASSEMBLER )

( ASSEMBLER DEFINITIONS)
HEX

 0 CONSTANT  R0   1 CONSTANT  R1
 2 CONSTANT  R2   3 CONSTANT  R3
 4 CONSTANT  R4   5 CONSTANT  R5
 6 CONSTANT  R6   7 CONSTANT  R7
 8 CONSTANT  R8   9 CONSTANT  R9
10 CONSTANT R10  11 CONSTANT R11
12 CONSTANT R12  13 CONSTANT R13
14 CONSTANT R14  15 CONSTANT R15

: GOP'     OVER DUP 1F > SWAP 30 < AND IF + , , ELSE + , THEN ;
: GOP      CREATE , DOES> @ GOP' ;

0440 GOP B,    0680 GOP BL,   0400 GOP BLWP,
04C0 GOP CLR,  0700 GOP SETO, 0540 GOP INV,
0500 GOP NEG,  0740 GOP ABS,  06C0 GOP SWPB,
0580 GOP INC,  05C0 GOP INCT, 0600 GOP DEC,
0640 GOP DECT, 0480 GOP X,

: GROP         CREATE , DOES> @ SWAP 40 * + GOP' ;

2000 GROP COC,  2400 GROP CZC,  2800 GROP XOR,
3800 GROP MPY,  3C00 GROP DIV,  2C00 GROP XOP,

: GGOP       CREATE ,
             DOES> @ SWAP DUP DUP 1F > SWAP 30 < AND
                   IF 40 * + SWAP >R GOP' R> ,
                   ELSE 40 * + GOP'
                   THEN ;

A000 GGOP A,   B000 GGOP AB,   8000 GGOP CMP, 9000 GGOP CB,
6000 GGOP S,   7000 GGOP SB,   E000 GGOP SOC, F000 GGOP SOCB,
4000 GGOP SZC, 5000 GGOP SZCB, C000 GGOP MOV, D000 GGOP MOVB,

: 0OP     CREATE ,  DOES> @ , ;

0340 0OP IDLE,   0360 0OP RSET,  03C0 0OP CKOF,
03A0 0OP CKON,   03E0 0OP LREX,  0380 0OP RTWP,

: ROP     CREATE , DOES> @ + , ;  02C0 ROP STST,  02A0 ROP STWP,
: IOP     CREATE , DOES> @ , , ;  02E0 IOP LWPI, 0300 IOP LIMI,
: RIOP    CREATE , DOES> @ ROT + , , ;

0220 RIOP AI,
0240 RIOP ANDI,
0280 RIOP CI,
0200 RIOP LI,
0260 RIOP ORI,
: RCOP    CREATE , DOES> @ SWAP 10 * + + , ;

0A00 RCOP SLA,
0800 RCOP SRA,
0B00 RCOP SRC,
0900 RCOP SRL,

( jump instructions)
: DOP      CREATE , DOES> @ SWAP 00FF AND OR , ;

1300 DOP JEQ,  1500 DOP JGT,  1B00 DOP JH,   1400 DOP JHE,
1A00 DOP JL,   1200 DOP JLE,  1100 DOP JLT,  1000 DOP JMP,
1700 DOP JNC,  1600 DOP JNE,  1900 DOP JNO,  1800 DOP JOC,
1C00 DOP JOP,  1D00 DOP SBO,  1E00 DOP SBZ,  1F00 DOP TB,

: GCOP CREATE , DOES> @ SWAP 000F AND 40 * + GOP' ;
3000 GCOP LDCR,  3400 GCOP STCR,    CHAR . EMIT -->

.( CAMEL99 Forth registers & addressing modes )
: @()       020    ;
: *?        010 +  ;
: *?+       030 +  ;
: @(?)      020 +  ;

: W         R6  ;
: @(W)      W @(?) ;
: *W        W *?   ;
: *W+       W *?+  ;

: RP        R6      ;
: @(RP)     RP @(?) ;
: *RP       RP *?   ;
: *RP+      RP *?+  ;

: IP        R3      ;
: @(IP)     IP @(?) ;
: *IP       IP *?   ;
: *IP+      IP *?+  ;

: SP        R4      ;
: @(SP)     SP @(?) ;
: *SP       SP *?   ;
: *SP+      SP *?+  ;

: NXT       R12     ;
: *NXT+     NXT *?+ ;
: *NXT      NXT *?  ;
: @(NXT)    NXT @(?) ;

( comparision for jumps )
: GTE 1 ; : HI  2 ; : NE 3  ; : LO  4 ; : LTE 5 ; : EQ 6  ;
: OC  7 ; : NC  8 ; : OO 9  ; : HE 0A ; : LE 0B ; : NP 0C ;
: LT 0D ; : GT 0E ; : NO 0F ; : OP 10 ;
: CJMP CASE LT OF 1101 , 0 ENDOF GT OF 1501 , 0 ENDOF
            NO OF 1901 , 0 ENDOF OP OF 1C01 , 0 ENDOF
            DUP 0< OVER 10 > ABORT" Jump error" ( DUP)
       ENDCASE 100 * 1000 + , ;

.( branching and looping )
: IF, CJMP HERE 2- 42 ; IMMEDIATE
: ENDIF, 42 ?PAIRS HERE OVER - 2- 2 / SWAP 1+ C! ; IMMEDIATE
: ELSE,  42 ?PAIRS 0 CJMP HERE 2- SWAP 42 [COMPILE] ENDIF, 42 ; IMMEDIATE
: BEGIN, HERE 41 ; IMMEDIATE
: UNTIL, SWAP 41 ?PAIRS CJMP HERE - 2 / 00FF AND HERE 1- C! ; IMMEDIATE
: AGAIN, 0 [COMPILE] UNTIL, ; IMMEDIATE
: REPEAT, >R >R [COMPILE] AGAIN, R> R> 2- [COMPILE] ENDIF, ; IMMEDIATE
: WHILE, [COMPILE] IF, 2+ ; IMMEDIATE

\ Wycove assembler register syntax:
: @@ @() ; : ** *? ;
: *+ *?+ ;
: () @(?) ;

( Pseudo instrucions like the TI Assember)
: RT,  R11 ** B, ;   R> BASE !
: NOP,
 .( Assembler loaded)
