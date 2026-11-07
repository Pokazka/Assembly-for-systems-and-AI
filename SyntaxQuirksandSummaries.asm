The JMP and CALL instructions support a variety of syntaxes to simplify their specific use cases. Some of the following chapters explain how these two instructions interact with various special symbols that NASM uses and some document non-obvious scenarios regarding differently sized modes of operation.

Near jumps are jumps within a single segment. Probably the most common way to use them is through labels. APX added a near jump instruction – JMPABS, that allows jumps to any 64-bit address specified with an immediate operand. The instruction works with absolute addresses and the syntax options

One of the ways to quickly implement an infinite loop is using the $ token which evaluates to the current position in the code

     jmp $

In some special circumstances one might need to jump between 16-bit mode and 32-bit mode. A similar issue is addressing between 16 and 32 bit segments

When writing shared libraries it's often necessary to call external code. In the ELF format the keyword takes on a different meaning than normally when it helps reference a segment – it's used to refer to some special symbols
In the case described here, "wrt ..plt" references a PLT (procedure linkage table) entry

NASM supports FAR (inter-segment) calls and jumps by means of the syntax call segment:offset, where segment and offset both represent immediate values

        call    (seg procedure):procedure 
        call    weird_seg:(procedure wrt weird_seg)

NASM also supports the syntax call far procedure as a synonym for the first of the above usages. JMP works identically to CALL in these examples

To declare a far pointer to a data item in a data segment, you must code
        dw symbol, seg symbol                ; 16 bit 
        dd symbol, word seg symbol           ; 32 bit

Defined as part of the APX specification, JMPABS is a new near jump instruction takes a 64-bit absolute address immediate. It is the only direct jump instruction that can jump anywhere in the address space in 64-bit mode

     jmpabs target

     jmp abs target

The ABS is required regardless of the DEFAULT setting

JMP lengths can be specified using keywords such as SHORT and NEAR. The keyword used also has consequences in how many bytes will be emitted in the final assembled instruction

00000000 EB09                    jmp label 
00000002 EB07                    jmp SHORT label 
00000004 E90400                  jmp NEAR label 
00000007 EB02                    jmp BYTE label 
00000009 EB00                    jmp WORD label 

                                 label:

Some instructions that use the VEX prefix, mainly AVX ones, use NDS (Non-Destructive Source) or NDD (New Data Destination) operands. Semantically it works by passing another operand to the instruction so that none of the source operands are modified as a result of the operation
Thereby these instructions have exactly the same encoding:
     vaddpd xmm0, xmm0, xmm1 
     vaddpd xmm0, xmm1

Here the XMM0 register is used as the "non-destructive source" even though in this case it will of course be modified

The moffs operand can be used with the MOV instruction, only using the "A" register (AL, AX, EAX, or RAX), and for non-64-bit operand size means to address memory at an offset from a segment. For 64-bit operands it simply accesses memory at a specified offset

Instructions that use the mib operand, (that is memory addressed with a base register, with some offset, with an added index register that's multiplied by some scale factor) can also utilize the split EA (effective addressing). The new form is mainly intended for MPX instructions that use the mib operands, but can be used for any memory reference

     mov eax,[ebx+8,ecx*4]   ; ebx=base, ecx=index, 4=scale, 8=disp

     ; bndstx 
     ; next 5 lines are parsed same 
     ; base=rax, index=rbx, scale=1, displacement=3 
     bndstx [rax+0x3,rbx], bnd0      ; NASM - split EA 
     bndstx [rbx*1+rax+0x3], bnd0    ; GAS - '*1' indecates an index reg 
     bndstx [rax+rbx+3], bnd0        ; GAS - without hints 
     bndstx [rax+0x3], bnd0, rbx     ; ICC-1 
     bndstx [rax+0x3], rbx, bnd0     ; ICC-2

VPTERNLOGD and VPTERNLOGQ are instructions that implement an arbitrary logic function for three inputs. They take three register operands and one immediate value that determines what logic function the instruction shall implement on execution

     a equ 0xaa 
     b equ 0xcc 
     c equ 0xf0 
     imm equ a | b & c

Note that only the expression must be written using the bitwise operators &, |, ^, and ~. Using the boolean operators &&, ||, ^^, ! and ? : will not work correctly

The vtern standard macro package, llows for these kinds of expressions without introducing the symbols a, b and c into the global namespace

%use vtern 
     vpternlogd xmm1, xmm2, xmm3, a | b & c 
     vpternlogq ymm4, ymm5, xmm6, (b ^ c) & ~a 
     ; a, b, and c are not defined as symbols elsewhere

Intel APX (Advanced Performance Extensions) introduces multiple new features, mostly to existing instructions. APX is only available in 64-bit mode

There are 16 new general purpose registers, R16 to R31.

Many instructions now support a non-destructive destination operand.

The ability to suppress the setting of the arithmetic flags.

The ability to zero the upper parts of a full 64-bit register for 8- and 16-bit operation size instructions. (This zeroing is always performed for 32-bit operations; this has been the case since 64-bit mode was first introduced.)

New instructions to conditionally set the arithmetic flags to a user-specified value.

Performance-enhanced versions of the PUSH and POP instructions.

A 64-bit absolute jump instruction.

A new REX2 prefix.

When it comes to register size, the new registers (R16–R31) work the same way as registers R8–R15

R31 is the 64-bit form of register 31,

R31D is the 32-bit form,

R31W is the 16-bit form, and

R31B is the 8-bit form. The form R31L can also be used if the altreg macro package is used (%use altreg)

Extended registers require that either a REX2 prefix (the default, if possible) or an EVEX prefix is used

There are some instructions that don't support EGPRs. In that case, NASM will generate an error if they are used

New Data Destination (NDD)

     add rax, rbx, rcx

The {nf} prefix on a supported instruction inhibits the update of the flags

     {nf} add rax, rbx

     {nf} add rax, rbx       ; Standard syntax 
     {nf}add  rax, rbx       ; Prefix without space 
     add {nf} rax, rbx       ; Suffix syntax 
     add{nf}  rax, rbx       ; Suffix without space

The {zu} prefix can be used meaning – "zero-upper", which disables retaining the upper parts of the registers and instead zero-extends the value into the full 64-bit register when the operand size is 8 or 16 bits

     {zu} setb al

     {zu} setb ax 
     setb {zu} al 
     setb {zu} ax 
     setb {zu} eax 
     setb {zu} rax 
     setb eax 
     setb rax

The source condition code (Scc) instructions, CCMPScc and CTESTScc, perform a test which if successful set the arithmetic flags to a user specfied value and otherwise leave them unchanged

using the {dfv=}...} syntax, containing a comma-separated list of zero or more of the CPU flags OF, SF, ZF or CF or simply as a numeric immediate (with OF, SF, ZF and CF being represented by bits 3 to 0 in that order.)

The PF flag is always set to the same value as the CF flag, and the AF flag is always cleared. NASM allows {dfv=pf} as an alias for {dfv=cf}, but do note that it still affects both flags

     ccmpl {dfv=of,cf} rdx, r30 
     ccmpl {dfv=of,cf}, rdx, r30 
     ccmpl 0x9, rdx, r30                     ; Comma required

     ccmpl ({dfv=of}|{dfv=cf}), rdx, r30     ; Parens, comma required 
ocf1 equ {dfv=of,cf}                         ; Parens not required 
     ccmpl ocf1, rdx, r30                    ; Comma required 
ofcf equ ({dfv=of,sf,cf} & ~{dfv=sf})        ; Parens required 
     ccmpl ofcf2, rdx, r30                   ; Comma required

     push2p rax, rbx 
     ; rax in [rsp+8] 
     ; rbx is [rsp+0] 
     pop2p rbx, rax

     push rax 
     push rbx 
     ; rax in [rsp+8] 
     ; rbx is [rsp+0] 
     pop rbx 
     pop rax

     push2p rax:rbx 
     ; rax in [rsp+8] 
     ; rbx is [rsp+0] 
     pop2p rax:rbx

The {nf} prefix may be ignored on instructions that already don't modify the arithmetic flags.

When the {nf} prefix is specified, NASM may generate another instruction which would not modify the flags register. For example, {nf} ror rax, rcx, 3 can be translated into rorx rax, rcx, 3.

The {zu} prefix may be ignored on instruction that already zero the upper parts of the destination register.

When the {zu} prefix is specified, NASM may generate another instruction which would zero the upper part of the register. For example, {zu} mov ax, cs can be translated into mov eax, cs.

New data destination or nondestructive source operands may be contracted if they are the same (and the semantics are otherwise identical). For example, add eax, eax, edx could be encoded as add eax, edx using legacy encoding. NASM does not perform this optimization as of version 3.00, but it probably will in the future.

APX encoding, using REX2 and EVEX, respectively, can be forced by using the {rex2} or {evex} instruction prefixes
