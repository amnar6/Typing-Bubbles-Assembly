[org 0x0100]

jmp start

start:
    ; leys take an example, clear the area top=5 left=10 bottom=7 right=20
	
    mov ax, 5
    push ax
    mov ax, 10
    push ax
    mov ax, 7
    push ax
    mov ax, 20
    push ax
    call clearArea

    mov ax, 0x4c00
    int 0x21

clearArea:

    push bp
    mov bp, sp
	
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov dx, 0xB800   ;memory segment, video memory
    mov es, dx

    ; paramaters 
	
    mov ax, [bp+10]   ; top
    mov bx, ax        ; BX = top
    mov ax, [bp+8]    ; left
    mov si, ax        ; SI = left
    mov ax, [bp+6]    ; bottom
    mov cx, ax        ; CX = bottom
    mov ax, [bp+4]    ; right
    mov di, ax        ; DI = right

    ;rows
    mov dx, bx        ; DX = row counter (start)
rowloop:   ;formula = (row x 80 + col) x 2

    mov ax, dx
    mov bx, 80
    mul bx            ; AX = row x 80 
    add ax, si        ; AX = row x 80 + left
    shl ax, 1         ; multiply by 2 for byte offset
    mov di, ax        ; DI is byte offset

    ; count = right - left + 1 characters
    mov ax, [bp+4]
    sub ax, [bp+8]
    inc ax
    mov cx, ax        ; CX = number of chars

    ; prepare word to write
    mov ax, ' '
    mov ah, 0x07   ;white on black

writeloop:
;through cols
    mov [es:di], ax
    add di, 2   ;moves to next cell
    dec cx
    jnz writeloop

    inc dx   ;move to next row
    cmp dx, [bp+6]   ;bottom row
    jle rowloop

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8