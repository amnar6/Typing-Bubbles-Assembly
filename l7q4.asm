[org 0x0100]

; Clear the screen
mov ah, 0x06        ; Scroll up / clear
mov al, 0x00        ; Clear entire screen
mov bh, 0x07        ; Attribute: white on black
mov cx, 0x0000      ; Upper-left corner
mov dx, 0x184F      ; Lower-right corner
int 0x10


; Display your name in the center with alternating colors
mov ax, 0xB800
mov es, ax

; Row = 12 (middle row)
; (80 - name_length) / 2 = starting column for centering
; Offset = (Row - 1)*160 + (Col - 1)*2
; For "ABS" (3 letters) → Col = (80-3)/2 = 38
; Offset = (11*160) + (37*2) = 0x07CC

mov di, 0x07CC          ; starting near screen center

mov si, name            ; point to name string
mov bl, 0x04            ; start color (red)

next_char:
    mov al, [si]        ; get next character
    cmp al, 0           ; end of string?
    je done
    mov ah, bl          ; set color
    mov [es:di], ax     ; write to video memory
    add di, 2           ; next column
    inc si              ; next character
    ; alternate color
    cmp bl, 0x04
    jne make_red
    mov bl, 0x0E        ; yellow
    jmp next_char
make_red:
    mov bl, 0x04        ; red
    jmp next_char

done:
mov ah, 0x00
int 0x16

mov ax, 0x4C00
int 0x21


; Data
name db 'ABS',0