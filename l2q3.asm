[org 0x0100]

mov ax, [num1+4]  
mov [num2], ax    ;num2[0] = ax


mov ax, [num1+2]  
mov [num2+2],ax  ;num2[1] = ax

mov ax, [num1+0]
mov [num2+4],ax  ; num2[2] = ax


mov ax, 0x4c00
int 0x21

num1: db 0x34, 0x12, 0x78, 0x56, 0x9a, 0xbc
num2: dw 0

