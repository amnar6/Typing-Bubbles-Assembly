[org 0x0100]

jmp start

dividend : dw 257       ; 16-bit number
divisor  : db 10        ; 8-bit divisor
quotient : dw 0
remainder: db 0

start:
    mov ax, [dividend]   ; AX = dividend
    mov bl, [divisor]    ; BL = divisor
    xor cx, cx           ; CX = quotient = 0

divide_loop:
    cmp ax, bx           ; if dividend < divisor, done
    jb done
    sub ax, bx           ; subtract divisor
    inc cx               ; quotient++
    jmp divide_loop

done:
    mov [quotient], cx   ; store quotient
    mov [remainder], al  ; remainder fits in 8-bit

    mov ax, 0x4c00
    int 0x21
