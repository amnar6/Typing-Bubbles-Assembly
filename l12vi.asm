[org 0x0100]
jmp start

; ---------------------------------------
; PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
; ---------------------------------------

pcb:   times 32*16 dw 0
stack: times 32*256 dw 0

nextpcb:  dw 1
current:  dw 0
lineno:   dw 0
starCount: dw 0          

printnum:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di

    mov di, 80
    mov ax, [bp+8]
    mul di
    mov di, ax
    add di, [bp+6]
    shl di, 1
    add di, 8

    mov ax, 0B800h
    mov es, ax

    mov ax, [bp+4]
    mov bx, 16
    mov cx, 4

PN_Loop:
    mov dx, 0
    div bx
    add dl, 30h
    cmp dl, 39h
    jbe PN_SkipAlpha
    add dl, 7
PN_SkipAlpha:
    mov dh, 07h
    mov [es:di], dx
    sub di, 2
    loop PN_Loop

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 6

printchar:
    push bp
    mov bp, sp
    push es
    push di

    mov ax, 0B800h
    mov es, ax

    mov ax, 80
    mov di, [bp+8]
    mul di
    add ax, [bp+6]
    shl ax, 1
    mov di, ax

    mov ax, [bp+4]
    mov ah, 07h
    mov [es:di], ax

    pop di
    pop es
    pop bp
    ret 6

; --------------------------------------------------
; mytask (same as Activity-1)
; --------------------------------------------------
mytask:
    push bp
    mov bp, sp
    sub sp, 2
    push ax
    push bx

    mov ax, [bp+4]
    mov bx, 70
    mov word [bp-2], 0

MT_Loop:
    push ax
    push bx
    push word [bp-2]
    call printnum
    inc word [bp-2]
    jmp MT_Loop

    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

; --------------------------------------------------
; fallingStar(column)  – ACTIVITY 6
; --------------------------------------------------
fallingStar:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov bx, [bp+4]        ; column

FS_StarLoop:
    mov cx, 0

FS_RowLoop:
    push cx
    push bx
    push word '*'
    call printchar

    mov dx, 200
FS_Delay:
    dec dx
    jnz FS_Delay

    cmp cx, 0
    je FS_NoErase

    mov ax, cx
    dec ax
    push ax
    push bx
    push word ' '
    call printchar
    add sp, 6

FS_NoErase:
    inc cx
    cmp cx, 25
    jb FS_RowLoop

    jmp FS_StarLoop

    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret

; --------------------------------------------------
; initpcb (same as Activity-1)
; --------------------------------------------------
initpcb:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si

    mov bx, [nextpcb]
    cmp bx, 32
    je InitExit

    mov cl, 5
    shl bx, cl

    mov ax, [bp+8]
    mov [pcb+bx+18], ax

    mov ax, [bp+6]
    mov [pcb+bx+16], ax

    mov [pcb+bx+22], ds

    mov si, [nextpcb]
    mov cl, 9
    shl si, cl
    add si, stack + 512
    mov ax, [bp+4]
    sub si, 2
    mov [si], ax
    sub si, 2
    mov [pcb+bx+14], si

    mov word [pcb+bx+26], 0200h

    mov ax, [pcb+28]
    mov [pcb+bx+28], ax

    mov ax, [nextpcb]
    mov [pcb+28], ax

    inc word [nextpcb]

InitExit:
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

; --------------------------------------------------
; timer ISR (same as Activity-1)
; --------------------------------------------------
timer:
    push ds
    push bx

    push cs
    pop ds

    mov bx, [current]
    mov cl, 5
    shl bx, cl

    mov [pcb+bx+0], ax
    mov [pcb+bx+4], cx
    mov [pcb+bx+6], dx
    mov [pcb+bx+8], si
    mov [pcb+bx+10], di
    mov [pcb+bx+12], bp
    mov [pcb+bx+24], es

    pop ax
    mov [pcb+bx+2], ax
    pop ax
    mov [pcb+bx+20], ax
    pop ax
    mov [pcb+bx+16], ax
    pop ax
    mov [pcb+bx+18], ax
    pop ax
    mov [pcb+bx+26], ax
    mov [pcb+bx+22], ss
    mov [pcb+bx+14], sp

    mov bx, [pcb+bx+28]
    mov [current], bx

    mov cl, 5
    shl bx, cl

    mov cx, [pcb+bx+4]
    mov dx, [pcb+bx+6]
    mov si, [pcb+bx+8]
    mov di, [pcb+bx+10]
    mov bp, [pcb+bx+12]
    mov es, [pcb+bx+24]
    mov ss, [pcb+bx+22]
    mov sp, [pcb+bx+14]

    push word [pcb+bx+26]
    push word [pcb+bx+18]
    push word [pcb+bx+16]
    push word [pcb+bx+20]

    mov al, 20h
    out 20h, al

    mov ax, [pcb+bx+0]
    mov bx, [pcb+bx+2]
    pop ds
    iret

; --------------------------------------------------
; MAIN
; --------------------------------------------------
start:
    xor ax, ax
    mov es, ax
    cli
    mov word [es:8*4], timer
    mov [es:8*4+2], cs
    sti

MainLoop:
    xor ah, ah
    int 16h

    cmp al, '8'
    je MakeStar

    ; Normal thread (mytask)
    push cs
    mov ax, mytask
    push ax
    push word [lineno]
    call initpcb
    inc word [lineno]
    jmp MainLoop

; -------------------------------------
; Create fallingStar thread
; -------------------------------------
MakeStar:
    mov ax, [starCount]
    mov bx, ax
    mov ax, 5
    mul bx               ; AX = 5 * starCount
    mov bx, 80
    sub bx, ax           ; starting column

    push cs
    mov ax, fallingStar
    push ax
    push bx
    call initpcb

    inc word [starCount]
    jmp MainLoop