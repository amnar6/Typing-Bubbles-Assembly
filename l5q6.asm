[org 0x0100]
jmp start

start:
    mov cx, 0          ; CX = result
    mov si, 0          ; SI = index for array

nextNum:
    cmp si, 10         ; check if we've processed all 10 elements
    je end             

    mov bl, [arr1 + si] ; load current element into BL
    inc si              ; move index to next element (1 byte each)

check_bits:
    shr bl, 1          ; shift right to check lowest bit
    jc got1            ; if bit = 1, check for sequence
    cmp bl, 0          ; if number becomes 0 then no 3 consecutive 1s possible
    je nextNum
    jmp check_bits     ; otherwise, keep shifting

got1:                  ; first 1 found
    shr bl, 1
    jc got2            ; second consecutive 1
    cmp bl, 0
    je nextNum
    jmp check_bits

got2:                  ; second consecutive 1 found
    shr bl, 1
    jc got3            ; third consecutive 1
    cmp bl, 0
    je nextNum
    jmp check_bits

got3:                  ; 3 consecutive 1s found
    inc cx             ; increase count
    jmp nextNum        ; move to next number


end:
    mov [count], cx    ; store final result
    mov ax, 0x4c00
    int 0x21


arr1:  db 1,2,3,4,1,2,3,4,5,6 ; array of 10 bytes
count: dw 0                   ; result stored here (word, since CX is word)
