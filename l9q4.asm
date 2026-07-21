[org 0x100]

jmp start

start:
mov dh, 10 ; start row
mov dl, 10 ; start column

next:
mov ah, 0
int 16h    ; wait for key
cmp al, 27 ; is it esc key?
je done

mov ah, 13h
mov al, 1
mov bh, 0
mov bl, 0x0E ; yellow on black
mov cx, 1
mov bp, sp
int 10h

pop ax

inc dl ; move right
jmp next

done:
mov ah, 4Ch
int 21h

