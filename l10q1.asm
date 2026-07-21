; Task 1: Read INT 08h Vector
[org 0x0100]

jmp start

OldOff: dw 0
OldSeg: dw 0

start:
    xor ax, ax
    mov es, ax            ; points to IVT base

    mov ax, [es:8*4]      ; read offset
    mov [OldOff], ax

    mov ax, [es:8*4+2]    ; read segment
    mov [OldSeg], ax

    mov dx, Msg
    mov ah, 9
    int 0x21

    mov ax, 0x4c00
    int 0x21

Msg: db 'INT 08h vector stored in variables.$'