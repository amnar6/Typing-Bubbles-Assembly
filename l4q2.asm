[org 0x0100]

jmp start

num1 dw 1,2,3,4,5
num2 dw 3,4,5,6,7
num3 dw 0,0,0,0,0

start:
mov ax, 0    ; holds data to check
mov bx, 0    ; counter for num1
mov si, 0    ; counter for num2
mov bp, 0    ; counter to check size of num2
mov di, 0    ; index for num3

l1: mov ax, [num1+bx]
    cmp ax, [num2+si]   ; compare num1 against num2
    jne l2              ; if its not equal then jump to l2
    jmp l3              ; if its equal then store

l2: add si, 2           ; next element of num2
    add bp, 2
    cmp bp, 10          ; checked all 5 elements of num2?
    je next_num1        ; if yes then go to next element of num1
    jmp l1              ; if not keep checking

l3: mov [num3+di], ax   ; store common element in num3
    add di, 2
    jmp next_num1       ; go check next num1

next_num1:
    add bx, 2           ; move to next element of num1
    mov si, 0           ; reset num2 index
    mov bp, 0           ; reset counter
    cmp bx, 10          ; processed all 5 elements of num1?
    je end
    jmp l1

end:

mov ax, 0x4c00
int 0x21
