; Task 4: Update screen every tick
[org 0x0100]

jmp start

OldOff: dw 0
OldSeg: dw 0
Count:  dw 0

MyTimer:
    push ax
    push es
    push di

    inc word [cs:Count]

    mov ax, 0x0b800
    mov es, ax

    mov di, (0*160)+(70*2)

	mov al, byte [cs:Count]
	add al, '0'

    mov ah, 7
    mov [es:di], ax

    mov al, 0x20
    out 0x20, al

    pop di
    pop es
    pop ax
    iret

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