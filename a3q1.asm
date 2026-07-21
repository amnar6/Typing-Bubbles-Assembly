;16-bit number into six splitOctal ASCII digits (2–3–3 system)

[org 0x0100]

jmp start

result : db 0,0,0,0,0,0,'$'

start: 
mov ax, 0x453   ;16-bit example
push ax          ;1st parameter = word value

mov bx , result
push bx
call splitOctal

mov dx, result    ;ds:dx is address of the string
mov ah, 9   ;telles DOS we want to print string
int 0x21   ;orint until $

mov ax, 0x4c00
int 0x21


;subruotine is splitOctal

splitOctal:
;parameters = [bp+4] word value, [bp+6] address of destination string

push bp
mov bp, sp 

push ax
push bx
push cx
push dx
push si
push di

mov ax, [bp+4]    ;destination striong, 16 bit word value
mov di, [bp+6]    ;destinayiom address
;mov bx, ax        ;bx will copy , now divided into bl,bh

mov bh, ah
mov bl, al

mov al, bh
mov cl, al   ;1st digit is of 7-6 bits
and cl, 0xc0  ;keep only 6,7, bits
shr cl, 6      ;move them to 0, 1 bit
add cl, '0'    ;conert to ascii
mov [di], cl
inc di

mov cl, al    ;2nd digit, bit 5-3
and cl, 0x38
shr cl, 3
add cl, '0'
mov [di], cl
inc di

mov cl, al     ;3rd digit, bit 2-0
and cl, 0x07
add cl, '0'
mov [di],cl
inc di




mov al,bl

mov cl,al    ;4rth digit, 6-7
and cl, 0xc0
shr cl, 6
add cl , '0'
mov [di], cl
inc di

mov cl, al    ;5th digit, 5-3
and cl, 0x38
shr cl, 3
add cl, '0'
mov [di], cl
inc di

mov cl,al    ;6th digit, 2-0
and cl, 0x07
add cl, '0'
mov [di], cl
inc di


pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp

ret 4       ; pop both parametrs from stack





