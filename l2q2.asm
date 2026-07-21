[org 0x0100]

mov si, num1 
mov al, [si]
mov ah, [si+1]
mov [si+1], al
mov [si], ah

mov ax, 0x4c00
int 0x21

num1:  dw 0x1234




 






