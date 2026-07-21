; Task 7: Store Make Codes
[org 0x0100]

jmp start

OldOff: dw 0
OldSeg: dw 0
Buffer: db 50 dup(0)
Index:  db 0

MyKB:
    push ax
    in al, 60h

    cmp al, 80h
    jae skip        ; ignore the break codes

    mov bl, [cs:Index]
    mov [cs:Buffer+bx], al
    inc byte [cs:Index]

skip:
    mov al, 0x20
    out 0x20, al

    pop ax
    jmp far [cs:OldOff]

start:
    xor ax, ax
    mov es, ax

    mov ax, [es:9*4]
    mov [OldOff], ax
    mov ax, [es:9*4+2]
    mov [OldSeg], ax

    cli
    mov word [es:9*4], MyKB
    mov [es:9*4+2], cs
    sti

L1: jmp L1