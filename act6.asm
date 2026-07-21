[org 0x0100]

mov ax, 0x1234   
mov bx, 0x3456
mov cx, 0x1132

add ax, bx  ; ax + bx
sub ax, cx    ; ax - cx
mov dx, ax   ;store final result in dx 

mov ax, 0x4c00
int 0x21