
global main

; This program will print its own source when run.

%define CODE_STR(str) "", 10,"global main", 10,"", 10,"; This program will print its own source when run.", 10,"", 10,"%define CODE_STR(str) " , str, 10,"%defstr CODE_LITERAL CODE_STR(str)", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    %define sysidx_write 0x2000004", 10,"    %define sysidx_exit 0x2000001", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    %define sysidx_write 1", 10,"    %define sysidx_exit 60", 10,"%endif", 10,"", 10,"section .data", 10,"dataCode    db  CODE_STR(CODE_LITERAL)", 10,"dataLen     equ $ - dataCode", 10,"", 10,"section .text", 10,"ft_putstr_fd:", 10,"    xor rdx, rdx", 10,"    mov rax, sysidx_write", 10,".loop:", 10,"    cmp BYTE[rdi + rdx], 0", 10,"    inc rdx", 10,"    jnz .loop", 10,"    syscall", 10,"    ret", 10,"", 10,"exit:", 10,"    mov rax, sysidx_exit", 10,"    syscall", 10,"    int 3", 10,"", 10,"main:", 10,"    mov rdi, 1          ; Print source code & exit(0)", 10,"    mov rsi, dataCode", 10,"    mov rdx, dataLen", 10,"    mov rax, sysidx_write", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    clc", 10,"    syscall", 10,"    jnb .exit", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns .exit", 10,"    neg rax", 10,"%endif", 10,"    mov rdi, rax", 10,"    jmp .error_exit", 10,".exit:", 10,"    xor rdi, rdi", 10,".error_exit:", 10,"    call exit", 10
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
%ifidn __OUTPUT_FORMAT__, macho64
    clc
    syscall
    jnb .exit
%elifidn __OUTPUT_FORMAT__, elf64
    syscall
    cmp rax, 0
    jns .exit
    neg rax
%endif
    mov rdi, rax
    jmp .error_exit
.exit:
    xor rdi, rdi
.error_exit:
    call exit
