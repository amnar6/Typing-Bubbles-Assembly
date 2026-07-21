[org 0x0100]

mov ah, 0   ;waiting for key to be pressed
int 16h ; AL has ASCII, AH is for scaning the code

mov bl, al
mov bh, ah

; show ascii text
mov ah, 9
mov dx, msg1
int 21h

; show ASCII character
mov dl, bl
mov ah, 2   ;2 is for display
int 21h

; new line
mov dl, 13
mov ah, 2
int 21h
mov dl, 10
int 21h

; show scan text
mov ah, 9
mov dx, msg2
int 21h

; show scan code as char
mov dl, bh
mov ah, 2
int 21h

mov ax, 0x4c00
int 21h

msg1: db 'ASCII Code: $'
msg2: db 'Scan Code: $'
