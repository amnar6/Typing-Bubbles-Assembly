[org 0x0100]

mov ah, 0x06        ; Function: scroll up / clear
mov al, 0x00        ; Clear entire screen
mov bh, 0x07        ; Attribute: white on black
mov cx, 0x0000      ; Upper-left corner (row 0, col 0)
mov dx, 0x184F      ; Lower-right corner (row 24, col 79)
int 0x10

; Display "FAST NU" on row 2, column 5
mov ax, 0xB800
mov es, ax

mov di, 0x00A8      ; (Row 2 – 1)*160 + (Col 5 – 1)*2 = 0A8h
mov si, msg         ; string
mov bl, 1Eh         ; Text color (yellow on blue)

next_char:
    mov al, [si]    ; Load next character
    cmp al, 0       ; End of string?
    je done
    mov ah, bl      ; Color attribute
    mov [es:di], ax ; Write character + color
    add di, 2       ; Move to next column
    inc si          ; Next character
    jmp next_char

done:
mov ah, 0x00
int 0x16

mov ax, 0x4C00
int 0x21

; Data
msg db 'FAST NU',0