[org 0x0100]

mov al, 24
add al, 01111111
xor al, 00100000
mov bl, 0          ; result 
test al, 01h       ; check bit 0

mov ax, 0x4c00
int 0x21