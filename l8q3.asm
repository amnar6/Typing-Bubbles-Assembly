[org 0x0100]
jmp start

string db 'STRING LAB'
strlen db 10
attr   db 0x0B
buffer db 20 dup(0),      ; space for 10 chars + 10 attributes

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov si, string
    mov di, buffer
    mov cl, [strlen]

make_buffer:
    lodsb                   ; load next character
    mov [di], al            ; store character
    inc di
    mov al, [attr]          ; load color attribute
    mov [di], al            ; store attribute
    inc di
    dec cl
    jnz make_buffer

    mov ax, 0xb800
    mov es, ax

    ;row = 4, col = 25
    ;so each row = 160 bytes (80 chars * 2 bytes)
    mov bx, 4
    mov dl, 25

    mov ax, bx              ; AX = row number
    mov cx, 160             ; bytes per row
    mul cx                  ; AX = row * 160
    movzx bx, dl            ; BX = column
    shl bx, 1               ; *2 (each char cell)
    add ax, bx              ; add column offset
    mov di, ax              ; DI is final video memory offset
	;copy bufer
    mov si, buffer
    mov cl, [strlen]
    mov ch, 0
    shl cx, 1               ; multiply by 2 (char + attribute per cell)
    cld
    rep movsb

    mov ah, 0
    int 16h
	
    mov ah, 4Ch
    int 21h
