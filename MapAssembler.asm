Uniwersalne dla Intel i AMD

Podstawowe x86
(mov, add, sub, and, or, xor, cmp, test, lea, push, pop, call, ret, jmp, jcc, nop)

32/64-bit
Long Mode (Wszystkie wersje z eXX / rXX)

FPU x87
fld, fst, fadd, fmul, fsqrt itd.

MMX (movq, paddb, pmullw...)

SSE / SSE2 / SSE3 / SSSE3 / SSE4.1 / SSE4.2
Standard (movaps, addps, movdqa, pshufb...)

AVX / AVX2 (vmovaps, vaddps, vpxor...) 256-bit

BMI1 / BMI2 Bit manipulation (andn, blsi, bzhi, pdep, pext, tzcnt, lzcnt)

Atomics + Fences Synchronizacja (lock, xchg, cmpxchg, xadd, mfence, lfence, sfence, pause)

Pamięć / System Paging, TLB, privilege (lgdt, lidt, ltr, invlpg, invpcid, mov cr3, cli, sti, hlt, rdtsc, cpuid)

Syscall Linux 64-bit (oba producenci) (syscall, sysret)

AES-NI, CLMUL, SHA, ADX, RDRAND/RDSEED

////////////////////////////////////////

CPU Intel

AVX-512 (pełne), Wszystkie v*zmm*, maski k0-k7, EVEX, Intel (Xeon + niektóre desktop). AMD ma tylko częściowe (Zen4/Zen5)
APX,"Nowe rejestry EGPR, NDD, NF, ZU",Nowe Intel (2024+)
TSX,"xbegin, xend, xabort, xtest",Hardware transactions (Intel)
MPX,"bndmk, bndcl, bndcu...",Memory Protection Extensions (martwe)
SGX,Enclave instructions,Intel only
SMX,Safer Mode Extensions,Intel
VMX (pełne),"vmxon, vmlaunch, vmresume, invept, invvpid...",Intel VT-x
AMX,Tile registers (tdpbf16ps itd.),Intel (Sapphire Rapids+)
CET (pełne),"endbr64, incsspq...",Control-flow Enforcement
"Key Locker, TME, MKTME",Szyfrowanie pamięci,Intel

CPU Intel . MMX SIMD using the x87 register file

CPU Intel . MMX Katmai

CPU Intel . Willamette MMX

CPU Intel . Willamette Streaming

CPU Intel SIMD / MMX

/////////////////////////////////

CPU AMD

Rozszerzenie,Kluczowe instrukcje,Status
3DNow! / Enhanced 3DNow!,"pfadd, pfmul, pavgusb...","Stare, usunięte z Zen"
SSE4a,"extrq, insertq, movntsd, movntss",AMD only
XOP,"vprotd, vpcmov, vfrczpd...","Stare (Bulldozer), usunięte"
FMA4,vfmaddpd (4-operand),AMD only (Intel ma FMA3)
TBM,"bextr, blci, blsic, t1mskc...",Trailing Bit Manipulation
SVM (AMD-V),"vmrun, vmload, vmsave, stgi, clgi, skinit",AMD virtualization
SEV / SEV-ES / SEV-SNP,"psmash, pvalidate, rmpadjust, rmpupdate, vmgexit",Secure Encrypted Virtualization
"CLZERO, MONITORX, MWAITX","clzero, monitorx, mwaitx",AMD-specific
LWP,Lightweight Profiling,Stare

CPU AMD . Enhanced 3DNow!

//////////////////////////////////

NVidia

nvcc - kompilator
PTX -> ptxas
SASS native - no public assembler like nasm

//////////////////////////////////

Podstawowe:
→ pseudo-ops, NOP, basic arithmetic (ADD/SUB/AND/OR/XOR/ADC/SBB...), 
  shift/rotate, bit operations (BT/BTS/BTR/BTC, BSF/BSR), 
  BSWAP, MOVBE, sign/zero extension (MOVSX/MOVZX/CDQE...),
  decimal (AAA/AAS/AAM/AAD/DAA/DAS – tylko 32-bit)

Przepływ sterowania:
→ mov, lea, cmp, test
→ call / ret / jmp / jcc / cmovcc / setcc
→ syscall / sysret
→ string instructions (MOVS/STOS/LODS/CMPS/SCAS + REP)
→ stack (PUSH/POP/ENTER/LEAVE)

Synchronizacja i atomics:
→ LOCK prefix, XCHG, CMPXCHG, XADD, 
  MFENCE / LFENCE / SFENCE / PAUSE

Pamięć i system:
→ invlpg, mov crX / drX, lgdt/lidt/lldt/ltr, 
  SGDT/SIDT..., CLFLUSH/CLFLUSHOPT/CLWB
→ RDTSC / RDTSCP / RDPMC / RDRAND / RDSEED / RDPID / CPUID
→ I/O (IN/OUT/INS/OUTS)
→ Segment handling
→ x87 FPU
→ MMX
→ SSE / SSE2 / SSE3 / SSSE3 / SSE4.1 / SSE4.2
→ AVX / AVX2
→ BMI1 / BMI2
→ AES-NI + VAES
→ CLMUL / VPCLMULQDQ
→ FMA (FMA3)
→ SHA
→ GFNI
→ PREFETCH*

Uniwersalne (bezpieczne na Intel + AMD):
→ pseudo-ops, no operation, basic 8 arithmetic operations, basic shift and rotate operations, basic integer arithmetic
→ AVX, APX EVEX, ADCX/ADOX, SHLD/SHRD, bit operations, BMI1 and BMI2 bit operations, decimal arithmetic, BSWAP/MOVBE, sign and 0 extension, 
→ mov, lea, add/sub/and/or/xor, cmp/test
→ call/ret/jmp/jcc/return/syscall/interrupts/flag reg instruct/sys manag mode/power manag/nop
→ mach control manag instruct
→ string instruct
→ synch and fencing
→ mem manag control
→ RDPMC/RDTSC/RDRAND/RDSEED/RDPID
→ syscall / sysret
→ lock + atomics + fences / RAO-INT
→ invlpg / mov cr3 / lgdt/lidt
→ rdtsc / cpuid
→ SSE2+ (do szybkiego kopiowania pamięci)/SSE3/SSSE3/SSE/FXRSTOR/FXRSTOR64/FXSAVE/FXSAVE64/Willamette SSE2/Willamette MMX/Willamette Streaming
→ I/O
→ Segment handling
→ x86 float
→ MMX/SIMD/Katmai/(VMX/SVM)/VMX
→ Stack operation
→ UD0/UD1/UD2B/UD2/UD2A/UDB/UDW/FWAIT/XLATB/XLAT/CCMPscc/CTESTscc
→ CMOVcc/CFCMOVcc/SETcc/SETccZU/CMPccXADD
→ PREFETCHNTA/PREFETCHT0/PREFETCHT1/PREFETCHT2/PREFETCHIT0/PREFETCHIT1/SFENCE
→ XSTORE/XCRYPTECB/XCRYPTCBC/XCRYPTCTR/XCRYPTCFB/XCRYPTOFB/MONTMUL/XSHA1/XSHA256
→ S3M/SM4
→ AVX Vector Neural Network Instructions / AVX Vector Neural Network Instructions INT8 / AVX Vector Neural Network Instructions INT16
→ Galois field operations (GFNI)
→ User interrupts / History reset
→ FSGSBASE – uniwersalne (RDFSBASE/WRFSBASE...)
→ INVPCID – uniwersalne
→ XSAVE / XRSTOR rodzina – uniwersalne

Intel-only (używaj tylko gdy targetujesz Intel):
→ pełne AES, AVX AES, AES Key Locker, AVX, AVX-512, AVX2, CLMUL, AVX CLMUL, FMA, APX, TSX, MPX, SHA, PKU aka PKEYs, SGX, CET, AMX, AVX512-FP16, pełne VMX, SMX, RAO-INT, CMPccXADD, UINTR, HRESET
→ APX (w tym EVEX formy, NDD, NF, ZU, CFCMOVcc, SETccZU...)
→ SERIALIZE, WBNOINVD, PCONFIG, WAITPKG, MOVDIRI/MOVDIR64B, ENQCMD...
→ PTWRITE – Intel
→ TPAUSE / UMONITOR / UMWAIT – Intel (WAITPKG)
→ SERIALIZE – Intel

AMD-only (używaj tylko gdy targetujesz AMD):
→ SSE4a, CLZERO, MONITORX/MWAITX, SVM, SEV-SNP, XOP, SEV-SNP, LWP, SSE5 XOP and FMA4
→ PREFETCHW – oryginalnie AMD, teraz uniwersalne
→ SSE4a (EXTRQ/INSERTQ/MOVNTSD/MOVNTSS)
→ SVM (AMD-V: VMRUN/VMLOAD/VMSAVE/STGI/CLGI/SKINIT...)
→ SEV / SEV-ES / SEV-SNP (PSMASH/PVALIDATE/RMPADJUST/RMPUPDATE/VMGEXIT...)
→ XOP (stare, usunięte z Zen)
→ FMA4 (stare)
→ TBM
→ LWP (Lightweight Profiling – stare)
→ 3DNow! / Enhanced 3DNow! (stare, usunięte)

Inne nie Intel / AMD
→ VIA PadLock: XSTORE, XCRYPTECB/CBC/CTR/CFB/OFB, XSHA1/XSHA256, MONTMUL
→ SM3 / SM4 (głównie Zhaoxin + niektóre nowe chipy)

////////////////////////////////

Cache

FPU

SSE

AVX

Universal Instruction

Universal Operation

Universal Debuging

TEST

Call and return

Interrupts, system calls, and returns

Flag register instruction

Synchronization and fencing

Memmanag and control

timestamp, CPU number, performance counters, randomness

Machine contrl / manag instruct

Sys manag mode

Power

I/O

Segments

Float x87

Stack operation

Undefined

Conditional

SIMD Streaming

Generic mem op

Memory protect

Convert

Min / Max

Compare scalar fp with enhanced eflags instructions

BF16 instructions

History reset

User interrupts

Atomic operations weakly ordered

AVX512 Bfloat16 instructions

AVX-512 mask register instructions

AVX Vector Neural Network Instructions

AVX Vector Neural Network Instructions INT8

AVX Vector Neural Network Instructions INT16

VIA (Centaur) security instructions
