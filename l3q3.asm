[org 0x0100]

mov ax, [temp]
cmp ax,0
jl freezing
cmp ax,24
jle cold
cmp ax, 69
jle moderate

mov ax,4
jmp done
freezing:
mov ax,1
jmp done

cold:
mov ax,2
jmp done

moderate:
mov ax,3

done:
mov ax, 0x4c00
int 0x21

temp: dw 40

