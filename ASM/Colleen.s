
global main

; This program will print its own source when run.

%define CODE_STR(str) "", 10,"global main", 10,"", 10,"; This program will print its own source when run.", 10,"", 10,"%define CODE_STR(str) ", str, 10,"%defstr CODE_LITERAL CODE_STR(str)", 10,"", 10,"section .data", 10,"dataCode    db  CODE_STR(CODE_LITERAL)", 10,"dataLen     equ $ - dataCode", 10,"", 10,"section .text", 10,"ft_putstr_fd:", 10,"    xor rdx, rdx", 10,"    mov rax, 1", 10," .loop:", 10,"    cmp BYTE[rdi + rdx], 0", 10,"    inc rdx", 10,"    jnz .loop", 10,"    syscall", 10,"    ret", 10,"", 10,"exit:", 10,"    mov rax, 60", 10,"    syscall", 10,"    int 3", 10,"", 10,"main:", 10,"    mov rdi, 1          ; Print source code & exit(0)", 10,"    lea rsi, dataCode", 10,"    mov rdx, dataLen", 10,"    mov rax, 1", 10,"    syscall", 10,"    xor rdi, rdi", 10,"    call exit", 10
%defstr CODE_LITERAL CODE_STR(str)
%ifidn __OUTPUT_FORMAT__, macho64
    %define sysidx_write 0x2000004
    %define sysidx_exit 0x2000001
%elifidn __OUTPUT_FORMAT__, elf64
    %define sysidx_write 1
    %define sysidx_exit 60
%endif

section .data
dataCode    db  CODE_STR(CODE_LITERAL)
dataLen     equ $ - dataCode

section .text
ft_putstr_fd:
    xor rdx, rdx
    mov rax, sysidx_write
.loop:
    cmp BYTE[rdi + rdx], 0
    inc rdx
    jnz .loop
    syscall
    ret

exit:
    mov rax, sysidx_exit
    syscall
    int 3

main:
    mov rdi, 1          ; Print source code & exit(0)
    mov rsi, dataCode
    mov rdx, dataLen
    mov rax, sysidx_write
    syscall
    xor rdi, rdi
    call exit
