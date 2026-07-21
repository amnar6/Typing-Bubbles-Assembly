[org 0x0100]

; read one character
mov ah, 1
int 21h ; AL key is pressed

mov bl, al ; store it in bl

; print message
mov ah, 9
mov dx, msg
int 21h

; print character
mov dl, bl
mov ah, 2
int 21h

; exit
mov ah, 4CH
int 0x21

msg: db 'You pressed: $'