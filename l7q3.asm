[org 0x0100]

mov ah, 0x06        ; Function: scroll up / clear
mov al, 0x00        ; Clear entire screen
mov bh, 0x07        ; Attribute: white on black
mov cx, 0x0000      ; Upper-left corner
mov dx, 0x184F      ; Lower-right corner
int 0x10


; Set up for diagonal alphabet pattern
mov ax, 0xB800
mov es, ax
xor di, di          ; Start at top-left corner
mov al, 'A'         ; First character
mov ah, 0x01        ; Starting color (blue)
mov cx, 26          ; Total letters A–Z


; Loop to display diagonal characters
next_char:
    mov [es:di], ax ; Write character + color
    add di, 162     ; Move to next row + next column (160+2)
    inc al          ; Next alphabet letter
    inc ah          ; Next color
    cmp ah, 0x0F    ; Limit color range
    jbe skip_reset
    mov ah, 0x01    ; Reset color to blue
skip_reset:
    loop next_char

mov ah, 0x00
int 0x16

mov ax, 0x4C00
int 0x21