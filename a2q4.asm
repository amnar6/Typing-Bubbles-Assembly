[org 0x0100]

jmp start

num: dw 0A425h     ; example number, given

start:
    mov ax, [num]   ; load number
    mov bx, ax      ; copy for reversing
    mov cx, 16      ; preperaing register, bit count
    xor dx, dx      ; reversed bits = 0, dx will hold the reversed number

ReverseLoop:
    ror bx, 1       ; rotate right through carry, LSB goes to CF
    rcl dx, 1       ; rotate carry into dx from left
    loop ReverseLoop   ;16 iterations

    cmp ax, dx    ;check if palindrome
    jne NotPalin
    mov dx, 1       ; it is palindrome
    jmp EndProg

NotPalin:
    mov dx, 0       ; not palindrome

EndProg:
  mov ax, 0x4c00
  int 0x21


;dx ends uo as the revresed number, if its equals the original ax, the numner is a palindome