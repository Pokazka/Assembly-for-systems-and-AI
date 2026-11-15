BITS 64 / default rel
        ↓
section .data / .rodata          (stałe, stringi, tabele)
        ↓
section .bss                     (niezainicjalizowane dane – resb/resq)
        ↓
section .text                    (kod wykonywalny)
        ↓
global _start / main             (punkt wejścia)
        ↓
_start:                          (tu zaczyna się wykonanie)

[ Wejście ] → [ Inicjalizacja ] → [ Główna logika ] → [ Wyjście / pętla ]

_start / entry point
        ↓
1. Ustawienie stosu (mov rsp, ...)
        ↓
2. Czyszczenie rejestrów / flag (xor eax,eax  /  cld)
        ↓
3. Inicjalizacja segmentów / GDT / IDT  (lgdt, lidt, mov cr0/cr3/cr4...)
        ↓
4. Włączenie trybów (paging, long mode, interupts – sti)
        ↓
5. Alokacja / mapowanie pamięci (struktury page tables)
        ↓
6. Inicjalizacja urządzeń / I/O (out/in, konfiguracja PIC/APIC)
        ↓
7. Główna logika programu / kernela
        │
        ├── pętle (jmp / jcc / loop)
        ├── wywołania (call / ret)
        ├── syscalle / interrupty (syscall / int / iret)
        └── synchronizacja (lock, fences, pause)
        ↓
8. Zakończenie lub nieskończona pętla (hlt / jmp $)

Pseudo-ops i dane
        ↓
MOV / LEA / XOR                    ← podstawowy transfer i czyszczenie
        ↓
ADD / SUB / AND / OR / XOR / CMP / TEST
        ↓
JMP / Jcc / CALL / RET             ← sterowanie przepływem
        ↓
PUSH / POP / ENTER / LEAVE         ← zarządzanie stosem
        ↓
String ops (MOVS/STOS + REP)       ← kopiowanie bloków
        ↓
Atomic + LOCK + Fences             ← synchronizacja
        ↓
Systemowe (LGDT/LIDT/MOV CR3/INVLPG/STI/CLI)
        ↓
Syscall / Int / Iret
        ↓
SIMD (SSE/AVX) – dopiero gdy potrzebujesz wydajności

[BITS + sekcje] → [dane] → [_start] → [setup stosu + rejestry] → [tryby CPU + pamięć] → [I/O + urządzenia] → [główna logika + pętle + call] → [syscalle / sync] → [hlt / exit]

Najpierw – struktura pliku + dane
Potem – punkt wejścia + podstawowe mov/lea/xor
Następnie – sterowanie przepływem (jmp/call)
Później – zarządzanie pamięcią i trybami procesora
Na końcu – optymalizacje (SIMD, atomics, fences)
