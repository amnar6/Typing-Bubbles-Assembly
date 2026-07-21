; Task 8 TSR Copy and Paste Screen with C and V Keys
[org 0x0100]

jmp install

OldOff: dw 0
OldSeg: dw 0

Screen: times 4000 db 0


MyKB:
    push ax
    push es
    push ds
    push si
    push di
    push cx

    in al, 0x60

    cmp al, 0x2E     ; 'C'
    je save

    cmp al, 0x2F     ; 'V'
    je restore

chain:
    pop cx
    pop di
    pop si
    pop ds
    pop es
    pop ax
    jmp far [cs:OldOff]

save:
    mov ax, 0x0b800
    mov ds, ax

    push cs
    pop es

    mov si, 0
    mov di, Screen
    mov cx, 2000
    rep movsw

    jmp exit

restore:
    mov ax, 0x0b800
    mov es, ax

    push cs
    pop ds

    mov si, Screen
    mov di, 0
    mov cx, 2000
    rep movsw

exit:
    mov al, 0x20
    out 0x20, al

    pop cx
    pop di
    pop si
    pop ds
    pop es
    pop ax
    iret

install:
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

    mov dx, install
    add dx, 15
    shr dx, 4

    mov ax, 0x3100
    int 0x21