
; This program will print its own source when run.

%define CODE_STR(str) "", 10,"; This program will print its own source when run.", 10,"", 10,"%define CODE_STR(str) ", str, 10,"%defstr CODE_LITERAL CODE_STR(str)", 10,"", 10,"%macro FT 1", 10,"    global main", 10,"main:", 10,"    mov rdi, fileName", 10,"    mov rsi, 577", 10,"    mov rdx, 0o666", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    mov rax, 0x2000005  ; open", 10,"    clc", 10,"    syscall", 10,"    jnb .write_file", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    mov rax, 2 ; open", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns .write_file", 10,"%endif", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,".write_file:", 10,"    push rax", 10,"    sub rsp, 8", 10,"    mov rdi, rax", 10,"    mov rsi, dataCode", 10,"    mov rdx, dataLen", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    mov rax, 0x2000004 ; write", 10,"    clc", 10,"    syscall", 10,"    jnb %%continue", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,"    %%continue:", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    mov rax, 1 ; write", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns %%continue", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,"    %%continue:", 10,"%endif", 10,"    add rsp, 8", 10,"    pop rdi", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    mov rax, 0x2000006 ; close", 10,"    clc", 10,"    syscall", 10,"    jnb .exit", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    mov rax, 3 ; close", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns .exit", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,"%endif", 10,".exit:", 10,"    xor rdi, rdi", 10,".error_exit:", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    mov rax, 0x2000001 ; exit", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    mov rax, 60", 10,"%endif", 10,"    syscall", 10,"    int 3", 10,"%endmacro", 10,"", 10,"section .data", 10,"fileName    db 'Grace_kid.s', 0", 10,"dataCode    db  CODE_STR(CODE_LITERAL)", 10,"dataLen     equ $ - dataCode", 10,"", 10,"section .text", 10,"    FT x", 10
%defstr CODE_LITERAL CODE_STR(str)

%macro FT 1
    global main
main:
    mov rdi, fileName
    mov rsi, 577
    mov rdx, 0o666
%ifidn __OUTPUT_FORMAT__, macho64
    mov rax, 0x2000005  ; open
    clc
    syscall
    jnb .write_file
%elifidn __OUTPUT_FORMAT__, elf64
    mov rax, 2 ; open
    syscall
    cmp rax, 0
    jns .write_file
%endif
    mov rdi, 1
    jmp .error_exit
.write_file:
    push rax
    sub rsp, 8
    mov rdi, rax
    mov rsi, dataCode
    mov rdx, dataLen
%ifidn __OUTPUT_FORMAT__, macho64
    mov rax, 0x2000004 ; write
    clc
    syscall
    jnb %%continue
    mov rdi, 1
    jmp .error_exit
    %%continue:
%elifidn __OUTPUT_FORMAT__, elf64
    mov rax, 1 ; write
    syscall
    cmp rax, 0
    jns %%continue
    mov rdi, 1
    jmp .error_exit
    %%continue:
%endif
    add rsp, 8
    pop rdi
%ifidn __OUTPUT_FORMAT__, macho64
    mov rax, 0x2000006 ; close
    clc
    syscall
    jnb .exit
    mov rdi, 1
    jmp .error_exit
%elifidn __OUTPUT_FORMAT__, elf64
    mov rax, 3 ; close
    syscall
    cmp rax, 0
    jns .exit
    mov rdi, 1
    jmp .error_exit
%endif
.exit:
    xor rdi, rdi
.error_exit:
%ifidn __OUTPUT_FORMAT__, macho64
    mov rax, 0x2000001 ; exit
%elifidn __OUTPUT_FORMAT__, elf64
    mov rax, 60
%endif
    syscall
    int 3
%endmacro

section .data
fileName    db 'Grace_kid.s', 0
dataCode    db  CODE_STR(CODE_LITERAL)
dataLen     equ $ - dataCode

section .text
    FT x
