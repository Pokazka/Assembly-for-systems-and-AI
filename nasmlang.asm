Pseudo-Instructions
      Dx: Declaring Initialized Data
      RESB and Friends: Declaring Uninitialized Data
      INCBIN: Including External Binary Files
      EQU: Defining Constants
      TIMES: Repeating Instructions or Data
Effective Addresses
Constants
      Numeric Constants
      Character Strings
      Character Constants
      String Constants
      Unicode Strings
      Floating-Point Constants
      Packed BCD Constants
Expressions
      ? ... :: Conditional Operator
      : ||: Boolean OR Operator
      : ^^: Boolean XOR Operator
      : &&: Boolean AND Operator
      : Comparison Operators
      |: Bitwise OR Operator
      ^: Bitwise XOR Operator
      &: Bitwise AND Operator
      Bit Shift Operators
      + and -: Addition and Subtraction Operators
      Multiplication, Division and Modulo
      Unary Operators
SEG and WRT
STRICT: Inhibiting Optimization
Critical Expressions
Local Labels

label:    instruction operands        ; comment

lodsb / lodab / -w+orphan-labels /ill cause it to warn you if you define a label alone on a line without a trailing colon

labels are letters, numbers, _, $, #, @, ~, ., and ?

$ to indicate that it is intended to be read as an identifier and not a reserved word

thus, if some other module you are linking with defines a symbol called eax

$eax in NASM code to distinguish the symbol from the register / Maximum length of an identifier is 4095 characters

LOCK, REP, REPE/REPZ, REPNE/REPNZ, XACQUIRE/XRELEASE or BND/NOBND

Explicit address-size and operand-size prefixes A16, A32, A64, O16 and O32, O64

name of a segment register as an instruction prefix: coding es mov [bx],ax is equivalent to coding mov [es:bx],ax

LODSB, which has no operands and yet can require a segment override, there is no clean syntactic way to proceed apart from es lodsb

CS, A32, LOCK or REPE can appear on a line by themselves, and NASM will just generate the prefix bytes

register name ax, bp, ebx, cr0

fadd    st1             ; this sets st0 := st0 + st1 
add    st0,st1         ; so does this 

fadd    st1,st0         ; this sets st1 := st1 + st0 
fadd    to st1          ; so does this

x87 floating-point instruction prefixes DWORD, QWORD or TWORD

DB, DW, DD, DQ, DT, DO, DY and DZ; 
their uninitialized counterparts RESB, RESW, RESD, RESQ, REST, RESO, RESY and RESZ; 
the INCBIN command, the EQU command, and the TIMES prefix

"Dx" and "RESx" is used to indicate all the DB and RESB type directives

DB, DW, DD, DQ, DT, DO, DY and DZ

      db    0x55                ; just the byte 0x55 
      db    0x55,0x56,0x57      ; three bytes in succession 
      db    'a',0x55            ; character constants are OK 
      db    'hello',13,10,'$'   ; so are string constants 
      dw    0x1234              ; 0x34 0x12 
      dw    'a'                 ; 0x61 0x00 (it's just a number) 
      dw    'ab'                ; 0x61 0x62 (character constant) 
      dw    'abc'               ; 0x61 0x62 0x63 0x00 (string) 
      dd    0x12345678          ; 0x78 0x56 0x34 0x12 
      dd    1.234567e20         ; floating-point constant 
      dq    0x123456789abcdef0  ; eight byte constant 
      dq    1.234567e20         ; double-precision float 
      dt    1.234567e20         ; extended-precision float

DT, DO, DY and DZ do not accept integer numeric constants as operands

db    ?                   ; uninitialized

     dx      := DB | DW | DD | DQ | DT | DO | DY | DZ 
     type    := BYTE | WORD | DWORD | QWORD | TWORD | OWORD | YWORD | ZWORD 
     atom    := expression | string | float | '?' 
     parlist := '(' value [',' value ...] ')' 
     duplist := expression DUP [type] ['%'] parlist 
     list    := duplist | '%' parlist | type ['%'] parlist 
     value   := [type] atom | list 

     stmt    := dx value [',' value ...]

       db 33 
       db (44)               ; Integer expression 
     ; db (44,55)            ; Invalid - error 
       db %(44,55) 
       db %('XX','YY') 
       db ('AA')             ; Integer expression - outputs single byte 
       db %('BB')            ; List, containing a string 
       db ? 
       db 6 dup (33) 
       db 6 dup (33, 34) 
       db 6 dup (33, 34), 35 
       db 7 dup (99) 
       db 7 dup dword (?, word ?, ?) 
       dw byte (?,44) 
       dw 3 dup (0xcc, 4 dup byte ('PQR'), ?), 0xabcd 
       dd 16 dup (0xaaaa, ?, 0xbbbbbb) 
       dd 64 dup (?)

The use of $ (current address) in a Dx statement is undefined in the current version of NASM

For the first expression in the statement, either a DUP or a data item.

An expression of the form "value - $", which is converted to a self-relative relocation.

RESB, RESW, RESD, RESQ, REST, RESO, RESY and RESZ are designed to be used in the BSS section of a module
they declare uninitialized storage space
bytes, words, doublewords or whatever to reserve

buffer:         resb    64              ; reserve 64 bytes 
wordvar:        resw    1               ; reserve a word 
realarray       resq    10              ; array of ten reals 
ymmval:         resy    1               ; one YMM register 
zmmvals:        resz    32              ; 32 ZMM registers

buffer:         db      64 dup (?)      ; reserve 64 bytes 
wordvar:        dw      ?               ; reserve a word 
realarray       dq      10 dup (?)      ; array of ten reals 
ymmval:         dy      ?               ; one YMM register 
zmmvals:        dz      32 dup (?)      ; 32 ZMM registers

using ? and DUP in the Dx directives is also supported

    incbin  "file.dat"             ; include the whole file 
    incbin  "file.dat",1024        ; skip the first 1024 bytes 
    incbin  "file.dat",1024,512    ; skip the first 1024, and 
                                   ; actually include at most 512
INCBIN is both a directive and a standard macro

message         db      'hello, world' 
msglen          equ     $-message

EQU defines a symbol to a given constant value, EQU is to define the given label name
msglen is evaluated once, using the value of $, at the point of definition

zerobuf:        times 64 db 0

buffer: db      'hello, world' 
        times 64-$+buffer db ' '
        times 100 movsb

times 100 resb 1 and resb 100

wordvar dw      123 
        mov     ax,[wordvar] 
        mov     ax,[wordvar+1] 
        mov     ax,[es:wordvar+bx]

es:wordvar[bx]

        mov     eax,[ebx*2+ecx+offset] 
        mov     ax,[bp+di+8]

    mov     eax,[ebx*5]             ; assembles as [ebx*4+ebx] 
    mov     eax,[label1*2-label2]   ; ie [label1+(label1-label2)]

For example, there are distinct assembled forms for the 32-bit effective addresses [eax*2+0] and [eax+eax]

cause [eax+ebx] and [ebx+eax] to generate different opcodes; this is occasionally useful because [esi+ebp] and [ebp+esi] have different default segment registers

generate an effective address in a particular form by the use of the keywords BYTE, WORD, DWORD and NOSPLIT

[dword eax+3]

[byte eax+offset]

[byte eax]

[eax+0] // byte offset of zero

[dword eax] // will code it with a double-word offset of zero

[eax] // will be coded with no offset field

[eax*2] into [eax+eax]

[eax*2+offset] into [eax+eax+offset]

NOSPLIT keyword: [nosplit eax*2] will force [eax*2+0] to be generated literally

[nosplit eax*1] also has the same effect

[0, eax*2]

The REL keyword makes it produce RIP–relative addresses

     VDIVPS zmm4, zmm5, dword [rbx]{1to16}   ; single-precision float 
     VDIVPS zmm4, zmm5, zword [rbx]          ; packed 512 bit memory

NASM understands four different types of constant: numeric, character, string and floating-point

Suffix H or X, D or T, Q or O, and B or Y for hexadecimal, decimal, octal and binary respectively, or you can prefix 0h or 0x, 0d or 0t, 0q or 0o, and 0b or 0y

        mov     ax,200          ; decimal 
        mov     ax,0200         ; still decimal 
        mov     ax,0200d        ; explicitly decimal 
        mov     ax,0d200        ; also decimal 
        mov     ax,0c8h         ; hex 
        mov     ax,0xc8         ; hex yet again 
        mov     ax,0hc8         ; still hex 
        mov     ax,310q         ; octal 
        mov     ax,310o         ; octal again 
        mov     ax,0o310        ; octal yet again 
        mov     ax,0q310        ; octal yet again 
        mov     ax,11001000b    ; binary 
        mov     ax,1100_1000b   ; same binary constant 
        mov     ax,1100_1000y   ; same binary constant once more 
        mov     ax,0b1100_1000  ; same binary constant yet again 
        mov     ax,0y1100_1000  ; same binary constant yet again 

        ; Deprecated syntax: 
        mov     ax,$0c8         ; hex again: the 0 is required

[DOLLARHEX]

      \'          single quote (') 
      \"          double quote (") 
      \`          backquote (`) 
      \\          backslash (\) 
      \?          question mark (?) 
      \a          BEL (ASCII 7) 
      \b          BS  (ASCII 8) 
      \t          TAB (ASCII 9) 
      \n          LF  (ASCII 10) 
      \v          VT  (ASCII 11) 
      \f          FF  (ASCII 12) 
      \r          CR  (ASCII 13) 
      \e          ESC (ASCII 27) 
      \377        Up to 3 octal digits - literal byte 
      \xFF        Up to 2 hexadecimal digits - literal byte 
      \u1234      4 hexadecimal digits - Unicode character 
      \U12345678  8 hexadecimal digits - Unicode character

      \o377       Up to 3 octal digits - literal byte (from C2y) 
      \d255       Up to 3 decimal digits - literal byte (NASM extension) 
      \^?         ASCII DEL (\d127, \177) 
      \^X         Convert X to a control character (e.g. 

\x, \o, \d or \u can have their argument enclosed in curly braces to delimit their length

      \x{FF}      Hexadecimal, literal byte 
      \o{377}     Octal, literal byte 
      \d{255}     Decimal, literal byte 
      \u{1234}    Unicode character 
      \u{12345}   Unicode character

      db `\u263a`            ; UTF-8 smiley face 
      db `\U0000263a`        ; UTF-8 smiley face 
      db `\u{263a}`          ; UTF-8 smiley face 
      db `\xe2\x98\xba`      ; UTF-8 smiley face 
      db 0E2h, 098h, 0BAh    ; UTF-8 smiley face

          mov eax,'abcd'
then the constant generated is not 0x61626364, but 0x64636261
it would read abcd rather than dcba

DB family and INCBIN

      db    'hello'               ; string constant 
      db    'h','e','l','l','o'   ; equivalent character constants

      dd    'ninechars'           ; doubleword string constant 
      dd    'nine','char','s'     ; becomes three doublewords 
      db    'ninechars',0,0,0     ; and really looks like this

__?utf16?__, __?utf16le?__, __?utf16be?__, __?utf32?__, __?utf32le?__ and __?utf32be?__

%define u(x) __?utf16?__(x) 
%define w(x) __?utf32?__(x) 

      dw u('C:\WINDOWS'), 0       ; Pathname in UTF-16 
      dd w(`A + B = \u206a`), 0   ; String in UTF-32

DB, DW, DD, DQ, DT, and DO, or as arguments to the special operators 
__?float8?__, __?float16?__, __?bfloat16?__, __?float32?__, __?float64?__, __?float80m?__, __?float80e?__, __?float128l?__, and __?float128h?__

traditional form: digits, then a period, then optionally more digits, then optionally an E followed by an exponent

dd 1, which declares an integer constant, and dd 1.0 which declares a floating-point constant

0x, hexadecimal digits, period, optionally more hexadeximal digits, then optionally a P followed by a binary xponent in decimal notation

0h and $ prefixes for hexadecimal, as well binary and octal floating-point, using the 0b or 0y and 0o or 0q prefixes, respectively.

      db    -0.2                    ; "Quarter precision" 
      dw    -0.5                    ; IEEE 754r/SSE5 half precision 
      dd    1.2                     ; an easy one 
      dd    1.222_222_222           ; underscores are permitted 
      dd    0x1p+2                  ; 1.0x2^2 = 4.0 
      dq    0x1p+32                 ; 1.0x2^32 = 4 294 967 296.0 
      dq    1.e10                   ; 10 000 000 000.0 
      dq    1.e+10                  ; synonymous with 1.e10 
      dq    1.e-10                  ; 0.000 000 000 1 
      dt    3.141592653589793238462 ; pi 
      do    1.e+4000                ; IEEE 754r quad precision

bfloat16 format is effectively a compressed version of the 32-bit single precision format

There is no Dx directive that corresponds to bfloat16

__?float80m?__ and __?float80e?__ produce the 64-bit mantissa and 16-bit exponent of an 80-bit floating-point number, and __?float128l?__ and __?float128h?__ produce the lower and upper 64-bit halves of a 128-bit floating-point number, respectively

      mov    rax,__?float64?__(3.141592653589793238462)

      mov    rax,0x400921fb54442d18

__?Infinity?__, __?QNaN?__ (or __?NaN?__) and __?SNaN?__

%define Inf __?Infinity?__ 
%define NaN __?QNaN?__ 

      dq    +1.5, -Inf, NaN         ; Double-precision constants

The %use fp standard macro package contains a set of convenience macros

x87-style packed BCD constants can be used in the same contexts as 80-bit floating-point numbers. They are suffixed with p or prefixed with 0p, and can include up to 18 decimal digits

      dt 12_345_678_901_245_678p 
      dt -12_345_678_901_245_678p 
      dt +0p33 
      dt 33p

$ evaluates to the assembly position at the beginning of the line containing the expression

infinite loop using JMP $

$$ evaluates to the beginning of the current section

boolean ? trueval : falseval // This operator evaluates to trueval if boolean is true, otherwise to falseval

The || operator gives a boolean OR: it evaluates to 1 if either side of the expression is nonzero, otherwise 0

The ^^ operator gives a boolean XOR: it evaluates to 1 if exactly one side of the expression is nonzero, otherwise 0

The && operator gives a boolean AND: it evaluates to 1 if both sides of the expression is nonzero, otherwise 0

= or == compare for equality.

!= or <> compare for inequality.

< compares signed less than.

<= compares signed less than or equal.

> compares signed greater than.

>= compares signed greater than or equal.

These operators evaluate to 0 for false or 1 for true

<=> does a signed comparison, and evaluates to –1 for less than, 0 for equal, and 1 for greater than

NASM does not provide unsigned comparison operators

The | operator gives a bitwise OR, exactly as performed by the OR machine instruction

^ provides the bitwise XOR operation

& provides the bitwise AND operation

<< gives a bit-shift to the left, just as it does in C

<<< gives a bit-shift to the left, exactly equivalent to the << operator

>>> gives an signed (arithmetic) bit-shift to the right

The + and - operators do perfectly ordinary addition and subtraction

* is the multiplication operator

/ and // are both division operators: / is unsigned division and // is signed division

Similarly, % and %% provide unsigned and signed modulo operators respectively

% character is used extensively by the macro preprocessor

     b * (a // b) + (a %% b) = a       (b != 0)

- negates (2's complement) its operand.

+ does nothing; it's provided for symmetry with -.

~ computes the bitwise negation (1's complement) of its operand.

! is the boolean negation operator. It evaluates to 1 if the argument is 0, otherwise 0.

SEG provides the segment address of its operand.

A set of additional operators with leading and trailing double underscores are used to implement the integer functions of the ifunc macro package

SEG operator evaluates to the preferred segment base of a symbol, defined as the segment base relative to which the offset of the symbol makes sense

        mov     ax,seg symbol 
        mov     es,ax 
        mov     bx,symbol

will load ES:BX with a valid pointer to the symbol symbol

WRT (With Reference To) keyword

        mov     ax,weird_seg        ; weird_seg is a segment base 
        mov     es,ax 
        mov     bx,symbol wrt weird_seg

ES:BX with a different but functionally equivalent, pointer to the symbol symbol

WRT keyword is also used in far (inter-segment) calls and jumps

     call far procedure

(BYTE, WORD, DWORD, QWORD, TWORD, OWORD, YWORD or ZWORD), but will give them the smallest possible size

keyword STRICT can be used to inhibit optimization and force a particular operand to be emitted in the specified size

BITS 16 mode

        push dword 33

encoded in three bytes 66 6A 21

        push strict dword 33

ncoded in six bytes, with a full dword immediate operand 66 68 21 00 00 00

With the optimizer off, the same code (six bytes) is generated whether the STRICT keyword was used or not

        times (label-$) db 0 
label:  db      'Where am I?'

        times (label-$+1) db 0 
label:  db      'NOW where am I?'

label1  ; some code 

.loop 
        ; some more code 

        jne     .loop 
        ret 

label2  ; some code 

.loop 
        ; some more code 

        jne     .loop 
        ret

label3  ; some more code 
        ; and some more 

        jmp label1.loop

label1:                         ; a non-local label 
.local:                         ; this is really label1.local 
..@foo:                         ; this is a special symbol 
label2:                         ; another non-local label 
.local:                         ; this is really label2.local 

        jmp     ..@foo          ; this will jump three lines up

..start is used to specify the entry point in the obj output format

..imagebase is used to find out the offset from a base address of the current image in the win64 output format

..symtab is used to emit the COFF symbol table index
