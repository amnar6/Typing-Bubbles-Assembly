[org 0x0100]

mov ax, 42
mov bx,18
mov cx,30

cmp ax,bx
jb L1
mov [smallest],bx
jmp 12
L1:
mov [smallest] ,ax

L2:
cmp [smallest] ,cx
jb end
mov [smallest],cx

end:
mov ax,0x4c00
int 0x21

smallest dw 0

