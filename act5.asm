[org 0x0100]

mov ax, 0    ; ax = 0, it starts from zero
mov bx, 5    ; bx = 5, adding 5 to ax register 5 times

add ax, bx      ;1st addition, ax = ax + 5
add ax, bx      ; 2nd
add ax, bx      ; 3rd
add ax, bx      ; 4th
add ax, bx      ; 5th   , ax=25

mov ax, 0x4c00
int 0x21
