[org 0x0100]

mov ax , 0x0025   ; copy contents of memory location
mov [0x0FFF], ax  ; copy ax into memory location with OFFSET 0FFF
mov ax, [0x0010]
mov [0x002F],ax   ; move

mov ax, 0x4c00
int 0x21

