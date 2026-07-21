[org 0x0100]
jmp start

char  db '@'
color db 0Eh
row   db 0
col   db 0
dr    db 1   ; row direction
dc    db 1   ; column direction


Delay:
    push cx
    mov cx, 2000
delay_loop:
    nop
    loop delay_loop
    pop cx
    ret


start:
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax

main_loop:

    ; compute video memory offset: row*160 + col*2
    mov al, [row]
    mov ah, 0
    mov bx, 160
    mul bx        ; AX = row*160
    mov bx, ax
    mov al, [col]
    mov ah, 0
    shl ax, 1     ; multiply by 2 (char + attribute)
    add bx, ax
    mov di, bx

    ; write character with color
    mov al, [char]
    mov ah, [color]
    stosw

    call Delay

    ; erase character
    mov al, ' '
    mov ah, 07h
    stosw

    ; update position
    mov al, [row]
    add al, [dr]
    mov [row], al

    mov al, [col]
    add al, [dc]
    mov [col], al

    ; check row borders
    mov al, [row]
    cmp al, 24
    jle chk_top
    mov byte [row], 24
    neg byte [dr]
    jmp change_color
	
chk_top:
    cmp al, 0
    jge chk_right
    mov byte [row], 0
    neg byte [dr]
    jmp change_color

    ; check column borders
chk_right:
    cmp byte [col], 79
    jle chk_left
    mov byte [col], 79
    neg byte [dc]
    jmp change_color
chk_left:
    cmp byte [col], 0
    jge main_loop
    mov byte [col], 0
    neg byte [dc]

change_color:
    mov al, [color]
    inc al
    and al, 0Fh
    cmp al, 0
    jne store_col
    mov al, 1
store_col:
    mov [color], al

    jmp main_loop
