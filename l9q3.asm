[org 0x0100]

mov ah, 13h  ;write string
mov al, 1    ;update cursor
mov bh, 0   ;page number
mov bl, 0x1E ; yellow/blue
mov cx, length
mov dh, 8
mov dl, 15
mov bp, msg
int 10h

mov ah, 4Ch
int 21h

msg: db 'BIOS text on blue background$'
length: db 0
