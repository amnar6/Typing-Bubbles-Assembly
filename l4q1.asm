[org 0x0100]

jmp start
arr1: dw 1,2,3,4,5

start:
mov bx, 0
mov ax, 0
mov si, 10

mov dx,0

l1:
mov ax, [arr1 + bx]
mov [arr1+si],ax
add bx,2
sub si, bx
cmp bx,6
jne l1

mov ax, 0x4c00
int 0x21