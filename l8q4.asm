[org 0x0100]
jmp start

msg      db 'WELCOME TO COAL LAB'
msglen   db 18
attr     db 0x0E
buffer   db 36 dup(0)       ; each char + attribute = 2 bytes * 18 = 36 bytes


Delay:
    push cx
    push dx
    mov cx, 0FFFFh
delay_loop:
    mov dx, 0FFFFh
delay_inner:
    dec dx
    jnz delay_inner
    loop delay_loop
    pop dx
    pop cx
    ret

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    ;buffer= char + attribute pairs
    mov si, msg
    mov di, buffer
    mov cl, [msglen]

make_buffer:
    lodsb
    mov [di], al
    inc di
    mov al, [attr]
    mov [di], al
    inc di
    dec cl
    jnz make_buffer

    ; set video memory segment
    mov ax, 0xb800
    mov es, ax

scroll_right:
    mov bx, 10          ; row = 10
    mov cx, 0           ; starting column = 0

next_pos:
    push bx             ; save row
    push cx             ; save column

    ; compute offset = row*160 + col*2
    mov ax, bx
    mov dx, 160
    mul dx
    mov dx, cx
    shl dx, 1
    add ax, dx
    mov di, ax

    ; copy buffer to video memory
    mov si, buffer
    mov cl, [msglen]
    mov ch, 0
    shl cx, 1
    cld
    rep movsb

    call Delay

    ; restore row, col
    pop cx
    pop bx

    ; clear previous text
    mov ax, bx
    mov dx, 160
    mul dx
    mov dx, cx
    shl dx, 1
    add ax, dx
    mov di, ax

    mov cl, [msglen]
    mov ch, 0
    shl cx, 1
    mov al, ' '
    mov ah, 07h
    cld
clear_loop:
    stosw
    loop clear_loop

    inc cx              ; move one column right
    cmp cx, 60
    jle next_pos

    jmp scroll_right

exit:
    mov ah, 4Ch
    int 21h
