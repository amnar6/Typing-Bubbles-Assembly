; Task 6: Blinking Text on Timer
[org 0x0100]

jmp start

OldOff: dw 0
OldSeg: dw 0
Color:  db 1

MyTimer:
    push ax
    push es
    push di

    mov ax, 0x0b800
    mov es, ax

    mov di, (5*160)+(20*2)

    cmp byte [cs:Color], 1
    je make2
    mov byte [cs:Color],1
    mov ah, 0x1E
    jmp write

make2:
    mov byte [cs:Color],2
    mov ah, 0x4E

write:
    mov al, 'H'
    mov [es:di], ax

    mov al, 20h
    out 20h, al

    pop di
    pop es
    pop ax
    jmp far [cs:OldOff]

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