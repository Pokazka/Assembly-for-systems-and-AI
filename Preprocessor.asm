%define THIS_VERY_LONG_MACRO_NAME_IS_DEFINED_TO \ 
        THIS_VALUE

      add al,'\'     ; Add the ASCII code for \ 
      mov [ecx],al   ; Save the character

In this step, %line directives are processed

Multi-line macro definitions, specified by the %macro and %imacro directives. The body of a multi-line macro is stored and is not further expanded at this time

Conditional assembly, specified by the %if family of preprocessor directives. Disabled part of the source code are discarded and are not futher expanded

Preprocessor loops, specified by the %rep preprocessor directive. A preprocessor loop is very similar to a multi-line macro and as such the body is stored and is not futher expanded at this time

%i / %idefine, %imacro etc.

%ifidni and %elifidni / %isidni() and %findi()

%define ctrl    0x1F & 
%define param(a,b) ((a)+(a)*(b)) 

        mov     byte [param(2,ebx)], ctrl 'D'

        mov     byte [(2)+(2)*(ebx)], 0x1F & 'D'

%define a(x)    1+b(x) 
%define b(x)    2*x 

        mov     ax,a(8)

mov ax,1+2*8

   %define foo (a,b)               ; no arguments, (a,b) is the expansion 
   %define bar(a,b)                ; two arguments, empty expansion

%define a(x)    1+a(x) 

        mov     ax,a(3)

%define foo(x)   1+x 
%define foo(x,y) 1+x*y

%define foo bar

foo(ebx,2) / 1+ebx*2

%define foo bar

%define foo bar

%define foo baz

   %define ereg(foo,) e %+ foo 
     mov eax,ereg(dx,cx)

   %define myreg() eax 
     mov edx,myreg()

    %define xyzzy(=expr,&val,=hex/x) expr, str, hex 
    %define plugh(x) xyzzy(x,x,x) 
    db plugh(13+5), `\0` ; Expands to: db 18, "13+5", 0x12, `\0`

%define  isTrue  1 
%define  isFalse isTrue 
%define  isTrue  0 

val1:    db      isFalse 

%define  isTrue  1 

val2:    db      isFalse

%xdefine isTrue  1 
%xdefine isFalse isTrue 
%xdefine isTrue  0 

val1:    db      isFalse 

%xdefine isTrue  1 

val2:    db      isFalse

     mov ax,Foo%[__?BITS?__] ; The Foo value

%xdefine Bar         Quux    ; Expands due to %xdefine 
%define  Bar         %[Quux] ; Expands due to %[...]

%define BDASTART 400h                ; Start of BIOS data area

struc   tBIOSDA                      ; its structure 
        .COM1addr       RESW    1 
        .COM2addr       RESW    1 
        ; ..and so on 
endstruc

        mov     ax,BDASTART + tBIOSDA.COM1addr 
        mov     bx,BDASTART + tBIOSDA.COM2addr

; Macro to access BIOS variables by their names (from tBDA):

%define BDA(x)  BDASTART + tBIOSDA. %+ x

        mov     ax,BDA(COM1addr) 
        mov     bx,BDA(COM2addr)

%imacro Foo 0 
        mov %?,%?? 
%endmacro 

        foo 
        FOO

        mov foo,Foo 
        mov FOO,Foo

%imacro Foo 0 
      %idefine Bar _%? 
      mov BAR,bAr 
%endmacro 

      foo 
      mov eax,bar

      mov _foo,_foo 
      mov eax,_foo

%imacro Foo 0 
      %idefine Bar _%*? 
      mov BAR,bAr 
%endmacro 

      foo 
      mov eax,bar

      mov _BAR,_bAr 
      mov eax,_bar

%idefine pause $%*?                 ; Hide the PAUSE instruction

%define foo bar 
%undef  foo 

        mov     eax, foo

%assign i i+1

%defstr test TEST

%define test 'TEST'

%defstr PATH %!PATH          ; The operating system PATH variable

%deftok test 'TEST'

%define test TEST

%defalias OLD NEW 
   ; OLD and NEW both undefined 
%define NEW 123 
   ; OLD and NEW both 123 
%undef OLD 
   ; OLD and NEW both undefined 
%define OLD 456 
   ; OLD and NEW both 456 
%undefalias OLD 
   ; OLD undefined, NEW defined to 456

%define greedy(a,b,c+) a + 66 %, b * 3 %, c 

       db greedy(1,2)          ; db 1 + 66, 2 * 3 
       db greedy(1,2,3)        ; db 1 + 66, 2 * 3, 3 
       db greedy(1,2,3,4)      ; db 1 + 66, 2 * 3, 3, 4 
       db greedy(1,2,3,4,5)    ; db 1 + 66, 2 * 3, 3, 4, 5

%strcat alpha "Alpha: ", '12" screen'

%strcat beta '"foo"\', "'bar'"

%strlen charcnt 'my string'

%define sometext 'my string' 
%strlen charcnt sometext

%substr mychar 'xyzw' 1       ; equivalent to %define mychar 'x' 
%substr mychar 'xyzw' 2       ; equivalent to %define mychar 'y' 
%substr mychar 'xyzw' 3       ; equivalent to %define mychar 'z' 
%substr mychar 'xyzw' 2,2     ; equivalent to %define mychar 'yz' 
%substr mychar 'xyzw' 2,-1    ; equivalent to %define mychar 'yzw' 
%substr mychar 'xyzw' 2,-2    ; equivalent to %define mychar 'yz'

Starting with NASM 3.00, the %ifdef directive or %isdef() function can also test for the availability of preprocessor functions. They cannot, however, be undefined, aliased or redefined

The %abs() function evaluates its first argument as an expression, and then emits the absolute value. This will always be emitted as a single token containing a decimal number; no minus sign will be emitted even if the input value is the maximum negative number

The %b2hs() functin takes a quoted string and an optional separator string, and expands to a quoted string containing a packed hexadecimal form of the bytes of the first string, separated by the separator string if applicable, This is the inverse of the %hs2b() function

The %chr() function evaluates its arguments as integers, then creates a quoted string out of these integers (mod 256) as bytes

%define a 1 
%xdefine astr %cond(a,"true","false") ; %define astr "true"

%xdefine empty %count()        ; %define empty 1 
%xdefine one   %count(1)       ; %define one 1 
%xdefine two   %count(5,q)     ; %define two 2 
%define  list  a,b,46 
%xdefine lc1   %count(list)    ; %define lc 1 (just one argument) 
%xdefine lc2   %count(%[list]) ; %define lc 3 (indirection expands)

The %depend() function takes a quoted string as argument, adds it to the output dependency list generated by the -M options, and evaluates to the unchanged string

%pathsearch() function

     ; This example assumes USER=nasmuser and MISSING is undefined 

     db %env(USER)                   ; db 'nasmuser' 
     db %env("USER")                 ; db 'nasmuser' 
     db %env("USER",0)               ; db 'nasmuser' 
     db %env(MISSING)                ; db '' 
     db %env("MISSING",0xff)         ; db 0xff 
     db %env("MISSING",1,"2",3)      ; db 1,"2",3 

     ; This line generates a warning for "db" without data: 
     db %env("MISSING",)             ; db

%ifenv directive

%! construct

%assign a    2 
%assign b    3 
%defstr what %eval(a+b,a*b)  ; equivalent to %define what "5,6"

     db %find(a,b,c,d)                       ; 0 
     db %find(a,b,a,c)                       ; 2 
     db %find(a)                             ; 0 (empty list)

%find() and %findi() Functions

%isidn() or %isidni() functions

%hex() Function, Equivalent to %eval(), except that the results generated are given as unsigned hexadecimal, with a 0x prefix

     db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09 
     db %hs2b("00010203 4 0506 07 8","9")

%is() Family Functions

; Instead of !%isidn() could have used %isnidn() 
%if %isdef(foo) && !%isidn(foo,bar) 
      db "foo is defined, but not as 'bar'" 
%endif

%istoken() and %isidn() is somewhat stricter than their corresponding %if directives

; Instead of !%isidn() could have used %isnidn() 
%if %isdef(foo) && !%isidn({foo,)}) 
      db "foo is defined, but not as ')'" 
%endif

%limit() / --limit- command line option / %pragma limit directive

%pragma limit limit-name reset

%pragma limit limit-name default

%pragma limit limit-name maximum

unlimited

__?NASM_LIMITS?__

%map() function

%define alpha(&x)     x 
%define alpha(&x,y)   y dup (x) 
%define alpha(s,&x,y) y dup (x,s) 
; 0 fixed + 1 grouped parameters per call, calls alpha(&x) 
      db %map(alpha,foo,bar,baz,quux) 
; 0 fixed + 2 grouped parameters per call, calls alpha(&x,y) 
      db %map(alpha::2,foo,bar,baz,quux) 
; 1 fixed + 2 grouped parameters per call, calls alpha(s,&x,y) 
      db %map(alpha:("!"):2,foo,bar,baz,quux)

      db 'foo','bar','baz','quux' 
      db bar dup ('foo'),quux dup ('baz') 
      db bar dup ('foo',"!"),quux dup ('baz',"!")

%define join(sep)        ''      ; handle the case of zero strings 
%define _join(sep,str)   sep,str ; helper macro 
%define join(sep,s1,sn+) %strcat(s1, %map(_join:(sep) %, sn)) 

      db join(':') 
      db join(':','a') 
      db join(':','a','b') 
      db join(':','a','b','c') 
      db join(':','a','b','c','d')

      db '' 
      db 'a' 
      db 'a:b' 
      db 'a:b:c' 
      db 'a:b:c:d'

%null() Function

%num() Function

given as –2, –8, –10, or –16, then 0b, 0q, 0d or 0x is prepended

The full 64-symbol set used is, in order

0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_

%ord() Function

%substr()

%pathsearch() Function

%pathsearch()

%realpath() Function

%define SOMEREALPATH %realpath(%pathsearch("somefile.asm"))

%define b 2 
%xdefine bstr %sel(b,"one","two","three") ; %define bstr "two"

     BITS 64 

%define breg %selbits(bx,ebx,rbx) 
%define vreg %selbits(ax,eax) 

     mov vreg,[breg]         ; mov eax,[rbx]

; The following lines are all equivalent 
%define  test 'TEST' 
%defstr  test TEST 
%xdefine test %str(TEST)

; The following lines are all equivalent 
%define  alpha 'Alpha: 12" screen' 
%strcat  alpha "Alpha: ", '12" screen' 
%xdefine alpha %strcat("Alpha: ", '12" screen')

; The following lines are all equivalent 
%define  charcnt 9 
%strlen  charcnt 'my string' 
%xdefine charcnt %strlen('my string')

; The following lines are all equivalent 
%define  mychar 'yzw' 
%substr  mychar 'xyzw' 2,-1 
%xdefine mychar %substr('xyzw',2,3) 
%xdefine mychar %substr('xyzw',2,-1) 
%xdefine mychar %substr('xyzw',2)

; The following lines are all equivalent 
%define test TEST 
%deftok test 'TEST' 
%define test %tok('TEST')

%macro  prologue 1 

        push    ebp 
        mov     ebp,esp 
        sub     esp,%1 

%endmacro

myfunc:   prologue 12

myfunc: push    ebp 
        mov     ebp,esp 
        sub     esp,12

%macro  silly 2 

    %2: db      %1 

%endmacro 

        silly 'a', letter_a             ; letter_a:  db 'a' 
        silly 'ab', string_ab           ; string_ab: db 'ab' 
        silly {13,10}, crlf             ; crlf:      db 13,10

%pragma preproc sane_empty_expansion

prologue

%imacro

%macro  prologue 0 

        push    ebp 
        mov     ebp,esp 

%endmacro

%macro  push 2 

        push    %1 
        push    %2 

%endmacro

        push    ebx             ; this line is not a macro call 
        push    eax,ecx         ; but this one is

%macro  retz 0 

        jnz     %%skip 
        ret 
    %%skip: 

%endmacro

        writefile [filehandle],"hello, world",13,10

%macro  writefile 2+ 

        jmp     %%endstr 
  %%str:        db      %2 
  %%endstr: 
        mov     dx,%%str 
        mov     cx,%%endstr-%%str 
        mov     bx,%1 
        mov     ah,0x40 
        int     0x21 

%endmacro

          writefile [filehandle], {"hello, world",13,10}

%macro mpar 1-* 
     db %{3:5} 
%endmacro 

mpar 1,2,3,4,5,6

%macro mpar 1-* 
     db %{5:3} 
%endmacro 

mpar 1,2,3,4,5,6

%macro mpar 1-* 
     db %{-1:-3} 
%endmacro 

mpar 1,2,3,4,5,6

%macro  die 0-1 "Painful program death has occurred." 

        writefile 2,%1 
        mov     ax,0x4c01 
        int     0x21 

%endmacro

%macro foobar 1-3 eax,[ebx+2]

%macro quux 1 something

%macro die 0-1+ "Painful program death has occurred.",13,10

%0: Macro Parameter Counter

%00: Label Preceding Macro

%macro  multipush 1-* 

  %rep  %0 
        push    %1 
  %rotate 1 
  %endrep 

%endmacro

%macro  multipop 1-* 

  %rep %0 
  %rotate -1 
        pop     %1 
  %endrep 

%endmacro

%macro keytab_entry 2 

    keypos%1    equ     $-keytab 
                db      %2 

%endmacro 

keytab: 
          keytab_entry F1,128+1 
          keytab_entry F2,128+2 
          keytab_entry Return,13

keytab: 
keyposF1        equ     $-keytab 
                db     128+1 
keyposF2        equ     $-keytab 
                db      128+2 
keyposReturn    equ     $-keytab 
                db      13

%1foo / foo1 and foo2 when passed the parameter foo / %{1}1

%{%foo}bar / bar / %%foo / %{%foo}bar / %%foobar / %[...] / %+

%macro  retc 1 

        j%-1    %%skip 
        ret 
  %%skip: 

%endmacro

%+1 / %-1 / retz / retc ne / retc po

CXZ / ECXZ

%macro foo 1.nolist

%macro bar 1-5+.nolist a,b,c,d,e,f,g,h

%macro foo 1-3 
        ; Do something 
%endmacro 
%unmacro foo 1-3

%macro bar 1-3 
        ; Do something 
%endmacro 
%unmacro bar 1

%unmacro or %unimacro directives

%macro count_something 2 
 %if %1 < 0 
   %warning %?: negative count 
   %exitmacro 
 %endif 
 ; ... do the thing, knowing that %1 >= 0 ... 
%endmacro

%exitrep directive

%if<condition> 
    ; some code which only appears if <condition> is met 
%elif<condition2> 
    ; only appears if <condition> is not met but <condition2> is 
%else 
    ; this appears if neither <condition> nor <condition2> was met 
%endif

%ifn / %elifn / %elif / %else / %ifdef / %elifdef / %ifndef / %elifndef / %is()

%if expr / expr is non-zero

          ; perform some function 
%ifdef DEBUG 
          writefile 2,"Function performed successfully",13,10 
%endif 
          ; go and do something else

%ifdef %newfunc 
  db %newfunc(99)     ; Generates something magic 
%else 
  %warning "This version of NASM doesn't support %newfunc()" 
  db -1              ; Feature not supported 
%endif

  db %cond(%isdef(%newfunc),%newfunc(99),-1)

__?NASM_HAS_IFDIRECTIVE?__

%ifdirective, %ifusable, %ifusing

%ifdefalias Testing Single-Line Macro Alias Existence / %defalias

%ifmacro MyMacro 1-3 

     %error "MyMacro 1-3" causes a conflict with an existing macro. 

%else 

     %macro MyMacro 1-3 

             ; insert code to define the macro 

     %endmacro 

%endif

%ifctx: Testing the Context Stack

%ifidn and %ifidni: Testing Exact Text Identity

%macro  pushparam 1 

  %ifidni %1,ip 
        call    %%label 
  %%label: 
  %else 
        push    %1 
  %endif 

%endmacro

%ifid, %ifnum, %ifstr: Testing Token Types

+ or -; %ifstr

%macro writefile 2-3+ 

  %ifstr %2 
        jmp     %%endstr 
    %if %0 = 3 
      %%str:    db      %2,%3 
    %else 
      %%str:    db      %2 
    %endif 
      %%endstr: mov     dx,%%str 
                mov     cx,%%endstr-%%str 
  %else 
                mov     dx,%2 
                mov     cx,%3 
  %endif 
                mov     bx,%1 
                mov     ah,0x40 
                int     0x21 

%endmacro

        writefile [file], strpointer, length 
        writefile [file], "hello", 13, 10

%iftoken: Test for a Single Token

%iftoken 1

%iftoken -1

%ifempty: Test for Empty Expansion

%ifdirective: Test If a Directive Is Supported

     %ifdirective %ifndef 
     %ifdirective "%ifndef"

__?NASM_HAS_IFDIRECTIVE?__ / %ifdirective, %ifusable, %ifusing and using %ifdef

%ifusable and %ifusing: Test For Standard Macro Packages

%use / __?USE_package?__ / %ifusing and %ifusable / __?NASM_HAS_IFDIRECTIVE?__ / %ifdirective, %ifusable, %ifusing and using %ifdef

%define MYFILE "file.asm" 
%iffile %pathsearch(MYFILE) 
     ; ... 
%endif

%ifenv: Test If Environment Variable Exists / %ifenv / %! / %env()

%ifdef __?NASM_HAS_IFDIRECTIVE?__        ; NASM 3.00 or later 
  %ifdirective %iffile                   ; Test for directive 
    %iffile MYFILE 
       incbin MYFILE 
    %endif 
  %endif 
%endif

%ifdef __?NASM_HAS_IFDIRECTIVE?__        ; NASM 3.00 or later 
  %if %isdef(%isfile)                    ; Test for function 
    %if %isfile(MYFILE) 
       incbin MYFILE 
    %endif 
  %endif 
%endif

Preprocessor Loops: %rep

%assign i 0 
%rep    64 
        inc     word [table+2*i] 
%assign i i+1 
%endrep

fibonacci: 
%assign i 0 
%assign j 1 
%rep 100 
%if j > 65535 
    %exitrep 
%endif 
        dw j 
%assign k j+i 
%assign i j 
%assign j k 
%endrep 

fib_number equ ($-fibonacci)/2

%include "macros.mac"

%ifndef MACROS_MAC 
    %define MACROS_MAC 
    ; now define some macros 
%endif

%pathsearch MyFoo "foo.bin"

%imacro incbin 1-2+ 0 
%pathsearch dep %1 
%depend dep 
        incbin dep,%2 
%endmacro

%use altreg 
%use 'altreg'

%ifusable and %ifusing directives can be used for the existence and inclusion of a specific standard macro package, see ifusing

The Context Stack / REPEAT ... UNTIL loop, in which the expansion of the UNTIL macro would need to be able to refer to a label which the REPEAT macro had defined

stack using the %push directive, and remove one using %pop

%push    foobar

this is normally used when both the %push and the %pop are inside a single macro definition

%pop, taking one optional argument, removes the top context from the context stack and destroys it

%macro repeat 0 

    %push   repeat 
    %$begin: 

%endmacro 

%macro until 1 

        j%-1    %$begin 
    %pop 

%endmacro

        mov     di,string 
        repeat 
        add     di,3 
        scasb 
        until   e

%define %$localmac 3

%macro ctxthru 0 
%push ctx1 
    %assign %$external 1 
        %push ctx2 
            %assign %$internal 1 
            mov eax, %$external 
            mov eax, %$internal 
        %pop 
%pop 
%endmacro

%macro ctxthru 0 
%push ctx1 
    %assign %$external 1 
        %push ctx2 
            %assign %$internal 1 
            mov eax, %$$external 
            mov eax, %$internal 
        %pop 
%pop 
%endmacro

%pop 
%push   newname

%macro if 1 

    %push if 
    j%-1  %$ifnot 

%endmacro 

%macro else 0 

  %ifctx if 
        %repl   else 
        jmp     %$ifend 
        %$ifnot: 
  %else 
        %error  "expected `if' before `else'" 
  %endif 

%endmacro 

%macro endif 0 

  %ifctx if 
        %$ifnot: 
        %pop 
  %elifctx      else 
        %$ifend: 
        %pop 
  %else 
        %error  "expected `if' or `else' before `endif'" 
  %endif 

%endmacro

        cmp     ax,bx 

        if ae 
               cmp     bx,cx 

               if ae 
                       mov     ax,cx 
               else 
                       mov     ax,bx 
               endif 

        else 
               cmp     ax,cx 

               if ae 
                       mov     ax,cx 
               endif 

        endif

Stack Relative Preprocessor Directives / %arg / %stacksize / %local

some_function: 

    %push     mycontext        ; save the current context 
    %stacksize large           ; tell NASM to use bp 
    %arg      i:word, j_ptr:word 

        mov     ax,[i] 
        mov     bx,[j_ptr] 
        add     ax,[bx] 
        ret 

    %pop                       ; restore original context

The %stacksize directive is used in conjunction with the %arg and the %local directives. 
It tells NASM the default size to use for subsequent %arg and %local directives. 
The %stacksize directive takes one required argument which is one of flat, flat64, large or small

%stacksize flat
stack-based parameter addressing relative to ebp and it assumes that a near form of call was used to get to this label (i.e. that eip is on the stack)

%stacksize flat64
stack-based parameter addressing relative to rbp and it assumes that a near form of call was used to get to this label (i.e. that rip is on the stack)

%stacksize large
bp to do stack-based parameter addressing and assumes that a far form of call was used to get to this address (i.e. that ip and cs are on the stack)

%stacksize small
bp to address stack parameters, but it is different from large because it also assumes that the old value of bp is pushed onto the stack
bp, ip and cs are on the top of the stack
useful when used in combination with the %local directive

silly_swap: 

    %push mycontext             ; save the current context 
    %stacksize small            ; tell NASM to use bp 
    %assign %$localsize 0       ; see text for explanation 
    %local old_ax:word, old_dx:word 

        enter   %$localsize,0   ; see text for explanation 
        mov     [old_ax],ax     ; swap ax & bx 
        mov     [old_dx],dx     ; and swap dx & cx 
        mov     ax,bx 
        mov     dx,cx 
        mov     bx,[old_ax] 
        mov     cx,[old_dx] 
        leave                   ; restore old bp 
        ret                     ; 

    %pop                        ; restore original context

%ifdef F1 
    ; do some setup 
%elifdef F2 
    ; do some different setup 
%else 
    %error "Neither F1 nor F2 was defined." 
%endif

%ifdef F1 
    ; do some setup 
%elifdef F2 
    ; do some different setup 
%else 
    %warning "Neither F1 nor F2 was defined, assuming F1." 
    %define F1 
%endif

-w-user / -w+error=user

%error and %warning

%fatal terminates assembly immediately, regardless of pass

%note adds an output line to the list file

%if foo > 64 
    %assign foo_over foo-64 
    %error foo is foo_over bytes too large 
%endif

ignore: this %pragma is unconditionally ignored.

preproc: preprocessor

limit: resource limits,

asm: the parser and assembler proper. Currently no such pragmas are defined.

list: listing options

file: general file handling options. Currently no such pragmas are defined.

input: input file handling options. Currently no such pragmas are defined.

output: output format options.

debug: debug format options.

%pragma output gprefix _

%pragma win gprefix _

%pragma preproc sane_empty_expansion / disables legacy compatibility handling of braceless empty arguments to multi-line macros

%line nnn[+mmm] [filename]

%!variable: Read an Environment Variable

%defstr FOO          %!FOO

%defstr C_colon      %!'C:'

   %clear [global|context] type...

define single-line macros

defalias single-line macro aliases (useful to remove backwards compatibility aliases)

alldefine same as define defalias

macro multi-line macros

all same as alldefine macro (default)

%clear was supported, which is equivalent to %clear global all

  Preprocessor Expansions
Continuation Line Collapsing
Comment Removal
%line directives
Conditionals, Loops and Multi-Line Macro Definitions
Directives processing
Inline expansions and other directives
Multi-Line Macro Expansion
Detokenization
  Preprocessor caveats
Case Insensitivity
  Single-Line Macros
The Normal Way: %define
Resolving %define: %xdefine
Macro Indirection: %[...]
Concatenating Single Line Macro Tokens: %+
The Macro Name Itself: %? and %??
The Single-Line Macro Name: %*? and %*??
Undefining Single-Line Macros: %undef
Preprocessor Variables: %assign
Defining Strings: %defstr
Defining Tokens: %deftok
Defining Aliases: %defalias
Conditional Comma Operator: %,
  String Manipulation in Macros
Concatenating Strings: %strcat
String Length: %strlen
Extracting Substrings: %substr
  Preprocessor Functions
%abs() Function
%b2hs() Function
%chr() Function
%cond() Function
%count() Function
%depend() Function
%env() Function
%eval() Function
%find() and %findi() Functions
%hex() Function
%hs2b() Function
%is() Family Functions
%limit() Function
%map() Function
%null() Function
%num() Function
%ord() Function
%pathsearch() Function
%realpath() Function
%sel() Function
%selbits() Function
%str() Function
%strcat() Function
%strlen() Function
%substr() Function
%tok() function
  Multi-Line Macros: %macro
Overloading Multi-Line Macros
Macro-Local Labels
Greedy Macro Parameters
Macro Parameters Range
Default Macro Parameters
%0: Macro Parameter Counter
%00: Label Preceding Macro
%rotate: Rotating Macro Parameters
Concatenating Macro Parameters
Condition Codes as Macro Parameters
Disabling Listing Expansion.nolist
Undefining Multi-Line Macros: %unmacro, %unimacro
%exitmacro: Stop Expanding a Multi-Line Macro
  Conditional Assembly
%if: Testing Arbitrary Numeric Expressions
%ifdef: Testing Single-Line Macro Existence
%ifdefalias: Testing Single-Line Macro Alias Existence
%ifmacro: Testing Multi-Line Macro Existence
%ifctx: Testing the Context Stack
%ifidn and %ifidni: Testing Exact Text Identity
%ifid, %ifnum, %ifstr: Testing Token Types
%iftoken: Test for a Single Token
%ifempty: Test for Empty Expansion
%ifdirective: Test If a Directive Is Supported
%ifusable and %ifusing: Test For Standard Macro Packages
%iffile: Test If a File Exists
%ifenv: Test If Environment Variable Exists
Backwards Compatibility Caveat
  Preprocessor Loops: %rep
  Source Files and Dependencies
%include: Including Other Files
%pathsearch: Search the Include Path
%depend: Add Dependent Files
%use: Include Standard Macro Package
  The Context Stack
%push and %pop: Creating and Removing Contexts
Context-Local Labels
Context-Local Single-Line Macros
Context Fall-Through Lookup (deprecated)
%repl: Renaming a Context
Example Use of the Context Stack: Block IFs
  Stack Relative Preprocessor Directives
%arg Directive
%stacksize Directive
%local Directive
  Reporting User-generated Diagnostics: %error, %warning, %fatal, %note
%pragma: Setting Options
Preprocessor Pragmas
  Other Preprocessor Directives
%line Directive
%!variable: Read an Environment Variable.
%clear: Clear All Macro Definitions
