[org 0x0100]
jmp start

msg    db 'DISPLAY TEST'
msglen db 12

start:
    ; set data segment
    mov ax, cs
    mov ds, ax
    mov ax, 0xb800
    mov es, ax

    ;fill the screen with @ in light yellow
    mov di, 0         ; start at top-left
    mov al, '@'
    mov ah, 0x0E      
    mov cx, 80*25     ; fill entire screen
    rep stosw

    ; display string diagonally
    mov si, msg
    mov cl, [msglen]   ; use CL as counter
    mov di, 0          ; starting at top left

diag_loop:
    lodsb               ; load character from msg
    mov ah, 0x0E
    stosw               ; char+attribute
    add di, 160 + 2     ; move one row down, one column right
    loop diag_loop

    mov ah, 0
    int 16h

    mov ah, 4Ch
    int 21h
