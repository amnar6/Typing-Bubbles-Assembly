[org 0x0100]

jmp start

A: dw 1,2,3,4,5
B: dw 3,5,6
C: dw 0,0,0,0,0    ; space for result (max 5 elements)
length: dw 0        ; number of elements in C

start:
    mov si, 0        ; index into A (bytes)
    mov di, 0        ; index into C (bytes)
    mov cx, 5        ; number of elements in A
    mov word [length], 0

outer:
    cmp cx, 0
    je end_program
    mov ax, [A+si]   ; take A[i]
    mov bx, 0        ; index into B
    mov dx, 3        ; number of elements in B
    mov bp, 0        ; flag = not found

inner:
    cmp dx, 0
    je check_done
    mov dx, [B+bx]   ; load B[j]
    cmp ax, dx
    jne not_equal
    mov bp, 1        ;found
not_equal:
    add bx, 2
    dec dx
    jmp inner

check_done:
    cmp bp, 1
    je skip          ; if found in B, skip

    ; store in C
    mov [C+di], ax
    add di, 2
    inc word [length]

skip:
    add si, 2        ; next element of A
    dec cx
    jmp outer

end_program:
    mov ax, 4C00h
    int 21h
