; Task 5: TSR Timer Screen Update
[org 0x0100]

jmp install

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

install:
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

    mov dx, install
    add dx, 15
    shr dx, 4

    mov ax, 0x3100
    int 0x21