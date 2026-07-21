[org 0x0100]

mov  ax, [src]
add word [dest], ax
mov ax, [src+2]
adc word [dest+2], ax

dest: dd 40000
src : dd 30000


mov ax, 0x4c00
int 0x21