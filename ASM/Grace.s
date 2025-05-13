
; This program will print its own source when run.

%define CODE_STR(str) "", 10,"; This program will print its own source when run.", 10,"", 10,"%define CODE_STR(str) ", str, 10,"%defstr CODE_LITERAL CODE_STR(str)", 10,"", 10,"%macro FT 1", 10,"    global main", 10,"main:", 10,"    mov rdi, fileName", 10,"    mov rsi, 577", 10,"    mov rdx, 0666", 10,"    mov rax, 2", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns .write_file", 10,"    mov rdi, 1", 10,"    jmp .error_exit", 10,".write_file:", 10,"    push rax", 10,"    sub rsp, 8", 10,"    mov rdi, rax", 10,"    mov rsi, dataCode", 10,"    mov rdx, dataLen", 10,"    mov rax, 1", 10,"    syscall", 10,"    add rsp, 8", 10,"    pop rdi", 10,"    mov rax, 3", 10,"    syscall", 10,".exit:", 10,"    xor rdi, rdi", 10,".error_exit:", 10,"    mov rax, 60", 10,"    syscall", 10,"    int 3", 10,"%endmacro", 10,"", 10,"section .data", 10,"fileName    db 'Grace_kid.s', 0", 10,"dataCode    db  CODE_STR(CODE_LITERAL)", 10,"dataLen     equ $ - dataCode", 10,"", 10,"section .text", 10,"    FT x", 10
%defstr CODE_LITERAL CODE_STR(str)

%macro FT 1
    global main
main:
    mov rdi, fileName
    mov rsi, 577
    mov rdx, 0666
    mov rax, 2
    syscall
    cmp rax, 0
    jns .write_file
    mov rdi, 1
    jmp .error_exit
.write_file:
    push rax
    sub rsp, 8
    mov rdi, rax
    mov rsi, dataCode
    mov rdx, dataLen
    mov rax, 1
    syscall
    add rsp, 8
    pop rdi
    mov rax, 3
    syscall
.exit:
    xor rdi, rdi
.error_exit:
    mov rax, 60
    syscall
    int 3
%endmacro

section .data
fileName    db 'Grace_kid.s', 0
dataCode    db  CODE_STR(CODE_LITERAL)
dataLen     equ $ - dataCode

section .text
    FT x
