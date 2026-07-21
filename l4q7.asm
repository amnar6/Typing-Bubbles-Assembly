[org 0x0100]

mov ax, 16
mov bp , 0
mov bx, 0

l1: 
SAR ax, bp
JC l2
jmp l3

l2:
add bp, 1
add bx, 1
cmp bp, 16
je end
jmp l1

l3:
add bp, 1
cmp bp, 16
je end
jmp l1

end:
mov ax, 0x4c00
int 0x21