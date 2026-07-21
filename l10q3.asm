; Task 3: Timer Hook + Chaining
[org 0x0100]

jmp start

OldOff: dw 0
OldSeg: dw 0
TickCount: dw 0

MyTimer:
    inc word [cs:TickCount]

    mov al, 0x20
    out 0x20, al

    jmp far [cs:OldOff]    ; chain to old ISR

start:
    xor ax, ax
    mov es, ax

    mov ax, [es:8*4]
    mov [OldOff], ax
    mov ax, [es:8*4+2]
    mov [OldSeg], ax

    cli
    mov word [es:8*4], MyTimer
    mov [es:8*4+2], cs
    sti

L1: jmp L1