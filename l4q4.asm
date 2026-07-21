[org 0x0100]

;Multiply and Divide using SHL/SHR

mov ax, 12       ; AX = 12
shl ax, 1        ; AX = AX * 2 = 24

mov bx, ax       ; save result (24) in BX

mov ax, 12       ; reload 12
shr ax, 1        ; AX = AX / 2 = 6

mov cx, ax       ; save result (6) in CX

mov ax, 4c00h    ; exit to DOS
int 21h
