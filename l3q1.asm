[org 0x0100]

mov ax, 12
mov bx, 20
cmp ax,bx

jb L1
sub bx,ax
mov [sum],bx
jmp end
L1:
sub ax,bx
mov [sum],ax

end:
mov ax,0x4c00
int 0x21

sum dw 0









