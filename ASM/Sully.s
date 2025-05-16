
global main

; This program will print its own source when run.

%define CODE_STR(str) "", 10,"global main", 10,"", 10,"; This program will print its own source when run.", 10,"", 10,"%define CODE_STR(str) ", str, 10,"%defstr CODE_LITERAL CODE_STR(str)", 10,"", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    %define sysidx_write    0x2000004", 10,"    %define sysidx_open     0x2000005", 10,"    %define sysidx_close    0x2000006", 10,"    %define sysidx_fork     0x2000002", 10,"    %define sysidx_execve   0x200003B", 10,"    %define sysidx_exit     0x2000001", 10,"    %define sysidx_wait4    0x2000007", 10,"    %define sysidx_unlink   0x200000A", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    %define sysidx_write 1", 10,"    %define sysidx_open 2", 10,"    %define sysidx_close 3", 10,"    %define sysidx_fork 57", 10,"    %define sysidx_execve 59", 10,"    %define sysidx_exit 60", 10,"    %define sysidx_wait4 61", 10,"    %define sysidx_unlink 87", 10,"%endif", 10,"", 10,"%define trap int 3", 10,"", 10,"%define O_CREAT	   0o100", 10,"%define O_TRUNC	   0o1000", 10,"%define O_WRONLY   0o1", 10,"", 10,"%defstr OUT_FORMAT __OUTPUT_FORMAT__", 10,"", 10,"%macro sys_call 1", 10,"    mov rax, %1", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    clc", 10,"    syscall", 10,"    jnb %%continue", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    syscall", 10,"    cmp rax, 0", 10,"    jns %%continue", 10,"%endif", 10,"    mov rdi, 2", 10,"    call exit", 10,"    trap", 10,"%%continue:", 10,"%endmacro", 10,"", 10,"section .data", 10,"dataCode    db  CODE_STR(CODE_LITERAL)", 10,"dataLen     equ $ - dataCode", 10,"fileName    db 'Sully_x.s', 0", 10,"objectName  db 'Sully_x.o', 0", 10,"execName    db 'Sully_x', 0", 10,"xIdx        equ 6", 10,"nasmPath    db '/usr/bin/nasm', 0", 10,"ldPath      db '/usr/bin/ld', 0", 10,"formatArg   db '-f ', OUT_FORMAT, 0", 10,"entryArg    db '-emain', 0", 10,"outArg      db '-o', 0", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"staticArg   db '-static', 0", 10,"%endif", 10,"nasmArgv    dq nasmPath", 10,"            dq formatArg", 10,"            dq outArg", 10,"            dq objectName", 10,"            dq fileName", 10,"            dq 0", 10,"ldArgv      dq ldPath", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"            dq staticArg", 10,"%endif", 10,"            dq entryArg", 10,"            dq outArg", 10,"            dq execName", 10,"            dq objectName", 10,"            dq 0", 10,"execArgv    dq execName", 10,"            dq execName", 10,"            dq 0", 10,"i           dd ", 217, 10,"", 10,"section .text", 10,"", 10,"exit:", 10,"    mov rax, sysidx_exit", 10,"    syscall", 10,"    trap", 10,"", 10,"; Executes path in child", 10,"; rdi -> path", 10,"; rsi -> argv", 10,"; rdx -> envp", 10,"child_execute:", 10,"    sub rsp, 0x18", 10,"    mov QWORD[rsp + 0x10], rdi", 10,"    mov QWORD[rsp + 0x8], rsi", 10,"    mov QWORD[rsp], rdx", 10,"    sys_call sysidx_fork", 10,"%ifidn __OUTPUT_FORMAT__, macho64", 10,"    cmp edx, 1", 10,"%elifidn __OUTPUT_FORMAT__, elf64", 10,"    cmp rax, 0", 10,"    jne .wait", 10,"%endif", 10,"    mov rdi, QWORD[rsp + 0x10]", 10,"    mov rsi, QWORD[rsp + 0x8]", 10,"    mov rdx, QWORD[rsp]", 10,"    sys_call sysidx_execve", 10,"    xor rdi, rdi", 10,"    call exit", 10,"    trap", 10,".wait:", 10,"    mov rdi, rax", 10,"    lea rsi, [rsp + 0x8]", 10,"    xor rdx, rdx", 10,"    xor r10, r10", 10,"    sys_call sysidx_wait4", 10,"    cmp DWORD[rsp + 0x8], 0", 10,"    jnz .error", 10,"    add rsp, 0x18", 10,"    ret", 10,".error:", 10,"    add rsp, 0x18", 10,"    xor rdi, rdi", 10,"    call exit", 10,"", 10,"; Writes source to file", 10,"drop_source:", 10,"    sub rsp, 8", 10,"    mov rdi, fileName", 10,"    mov rsi, O_CREAT | O_TRUNC | O_WRONLY;577", 10,"    mov rdx, 0o666", 10,"    sys_call sysidx_open", 10,"    mov DWORD[rsp], eax", 10,"    mov rdi, rax", 10,"    mov rsi, dataCode", 10,"    mov rdx, dataLen", 10,"    sys_call sysidx_write", 10,"    mov edi, DWORD[rsp]", 10,"    sys_call sysidx_close", 10,"    add rsp, 8", 10,"    ret", 10,"", 10,"; Gets char** envp from entry stack", 10,"; rdi -> Entry stack location", 10,"get_envp:", 10,"    mov rax, rdi", 10,".skip_argv:", 10,"    add rax, 8", 10,"    cmp QWORD[rax], 0", 10,"    jnz .skip_argv", 10,"    add rax, 8", 10,"    ret", 10,"", 10,"; Decrements i if not the first executable", 10,"process_i:", 10,"    xor rsi, rsi", 10,"    mov rdx, QWORD[rdi + 8]", 10,"    cmp BYTE[rdx + 5], '_'", 10,"    mov eax, 1", 10,"    cmove esi, eax", 10,"    mov eax, DWORD[rel i]", 10,"    sub eax, esi", 10,"    mov DWORD[rel i], eax", 10,"    add al, '0'", 10,"    mov BYTE[rel fileName + xIdx], al", 10,"    mov BYTE[rel execName + xIdx], al", 10,"    mov BYTE[rel objectName + xIdx], al", 10,"    lea rsi, [rel dataCode]", 10,".loop:", 10,"    cmp BYTE[rsi], 217", 10,"    je .found", 10,"    inc rsi", 10,"    jmp .loop", 10,".found:", 10,"    mov BYTE[rsi], al", 10,"    ret", 10,"", 10,"main:", 10,"    mov rbp, rsp", 10,"    mov rdi, rsp", 10,"    sub rsp, 0x18", 10,"    call get_envp", 10,"    mov QWORD[rsp + 0x10], rax", 10,"    mov rdi, rbp", 10,"    call process_i", 10,"    call drop_source", 10,"    cmp BYTE[rel i], 0", 10,"    jg .noexit", 10,"    xor rdi, rdi", 10,"    call exit", 10,".noexit:", 10,"    mov rdi, nasmPath", 10,"    mov rsi, nasmArgv", 10,"    mov rdx, QWORD[rsp + 0x10]", 10,"    call child_execute", 10,"    mov rdi, ldPath", 10,"    mov rsi, ldArgv", 10,"    mov rdx, QWORD[rsp + 0x10]", 10,"    call child_execute", 10,"    mov rdi, objectName", 10,"    sys_call sysidx_unlink", 10,"    mov rdi, execName", 10,"    mov rsi, execArgv", 10,"    mov rdx, QWORD[rsp + 0x10]", 10,"    sys_call sysidx_execve", 10,"    trap", 10
%defstr CODE_LITERAL CODE_STR(str)

%ifidn __OUTPUT_FORMAT__, macho64
    %define sysidx_write    0x2000004
    %define sysidx_open     0x2000005
    %define sysidx_close    0x2000006
    %define sysidx_fork     0x2000002
    %define sysidx_execve   0x200003B
    %define sysidx_exit     0x2000001
    %define sysidx_wait4    0x2000007
    %define sysidx_unlink   0x200000A
%elifidn __OUTPUT_FORMAT__, elf64
    %define sysidx_write 1
    %define sysidx_open 2
    %define sysidx_close 3
    %define sysidx_fork 57
    %define sysidx_execve 59
    %define sysidx_exit 60
    %define sysidx_wait4 61
    %define sysidx_unlink 87
%endif

%define trap int 3

%define O_CREAT	   0o100
%define O_TRUNC	   0o1000
%define O_WRONLY   0o1

%defstr OUT_FORMAT __OUTPUT_FORMAT__

%macro sys_call 1
    mov rax, %1
%ifidn __OUTPUT_FORMAT__, macho64
    clc
    syscall
    jnb %%continue
%elifidn __OUTPUT_FORMAT__, elf64
    syscall
    cmp rax, 0
    jns %%continue
%endif
    mov rdi, 2
    call exit
    trap
%%continue:
%endmacro

section .data
dataCode    db  CODE_STR(CODE_LITERAL)
dataLen     equ $ - dataCode
fileName    db 'Sully_x.s', 0
objectName  db 'Sully_x.o', 0
execName    db 'Sully_x', 0
xIdx        equ 6
nasmPath    db '/usr/bin/nasm', 0
ldPath      db '/usr/bin/ld', 0
formatArg   db '-f ', OUT_FORMAT, 0
entryArg    db '-emain', 0
outArg      db '-o', 0
%ifidn __OUTPUT_FORMAT__, macho64
staticArg   db '-static', 0
%endif
nasmArgv    dq nasmPath
            dq formatArg
            dq outArg
            dq objectName
            dq fileName
            dq 0
ldArgv      dq ldPath
%ifidn __OUTPUT_FORMAT__, macho64
            dq staticArg
%endif
            dq entryArg
            dq outArg
            dq execName
            dq objectName
            dq 0
execArgv    dq execName
            dq execName
            dq 0
i           dd 5

section .text

exit:
    mov rax, sysidx_exit
    syscall
    trap

; Executes path in child
; rdi -> path
; rsi -> argv
; rdx -> envp
child_execute:
    sub rsp, 0x18
    mov QWORD[rsp + 0x10], rdi
    mov QWORD[rsp + 0x8], rsi
    mov QWORD[rsp], rdx
    sys_call sysidx_fork
%ifidn __OUTPUT_FORMAT__, macho64
    cmp edx, 1
%elifidn __OUTPUT_FORMAT__, elf64
    cmp rax, 0
    jne .wait
%endif
    mov rdi, QWORD[rsp + 0x10]
    mov rsi, QWORD[rsp + 0x8]
    mov rdx, QWORD[rsp]
    sys_call sysidx_execve
    xor rdi, rdi
    call exit
    trap
.wait:
    mov rdi, rax
    lea rsi, [rsp + 0x8]
    xor rdx, rdx
    xor r10, r10
    sys_call sysidx_wait4
    cmp DWORD[rsp + 0x8], 0
    jnz .error
    add rsp, 0x18
    ret
.error:
    add rsp, 0x18
    xor rdi, rdi
    call exit

; Writes source to file
drop_source:
    sub rsp, 8
    mov rdi, fileName
    mov rsi, O_CREAT | O_TRUNC | O_WRONLY;577
    mov rdx, 0o666
    sys_call sysidx_open
    mov DWORD[rsp], eax
    mov rdi, rax
    mov rsi, dataCode
    mov rdx, dataLen
    sys_call sysidx_write
    mov edi, DWORD[rsp]
    sys_call sysidx_close
    add rsp, 8
    ret

; Gets char** envp from entry stack
; rdi -> Entry stack location
get_envp:
    mov rax, rdi
.skip_argv:
    add rax, 8
    cmp QWORD[rax], 0
    jnz .skip_argv
    add rax, 8
    ret

; Decrements i if not the first executable
process_i:
    xor rsi, rsi
    mov rdx, QWORD[rdi + 8]
    cmp BYTE[rdx + 5], '_'
    mov eax, 1
    cmove esi, eax
    mov eax, DWORD[rel i]
    sub eax, esi
    mov DWORD[rel i], eax
    add al, '0'
    mov BYTE[rel fileName + xIdx], al
    mov BYTE[rel execName + xIdx], al
    mov BYTE[rel objectName + xIdx], al
    lea rsi, [rel dataCode]
.loop:
    cmp BYTE[rsi], 217
    je .found
    inc rsi
    jmp .loop
.found:
    mov BYTE[rsi], al
    ret

main:
    mov rbp, rsp
    mov rdi, rsp
    sub rsp, 0x18
    call get_envp
    mov QWORD[rsp + 0x10], rax
    mov rdi, rbp
    call process_i
    call drop_source
    cmp BYTE[rel i], 0
    jg .noexit
    xor rdi, rdi
    call exit
.noexit:
    mov rdi, nasmPath
    mov rsi, nasmArgv
    mov rdx, QWORD[rsp + 0x10]
    call child_execute
    mov rdi, ldPath
    mov rsi, ldArgv
    mov rdx, QWORD[rsp + 0x10]
    call child_execute
    mov rdi, objectName
    sys_call sysidx_unlink
    mov rdi, execName
    mov rsi, execArgv
    mov rdx, QWORD[rsp + 0x10]
    sys_call sysidx_execve
    trap
