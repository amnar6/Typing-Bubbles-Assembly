[org 0x0100]         

jmp start             

start:
    mov cx, 0          ; CX = running sum = 0
    mov si, 0          ; SI = index offset for array
    mov bx, [count]    ; BX = number of elements (10)

loop:
    add cx, [arr1 + si] ; add current element into sum
    add si, 2           ; move to next word (2 bytes)
    dec bx              
    jnz loop        

    mov [sum], cx       ; store final sum in memory

end: 
    mov ax, 0x4c00     
    int 0x21

arr1:  dw 1,2,3,4,5,6,7,8,9,10 ; array of 10 numbers
sum:   dw 0                     ; store result here
count: dw 10                    ; number of elements
