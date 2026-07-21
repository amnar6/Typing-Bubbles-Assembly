[org 0x0100]

array dw  5, -3, 12, -7, 9, -15, 0, 20, -1, 8

SL dw 0   ; Signed Largest
SS dw 0   ; Signed Smallest
UL dw 0   ; Unsigned Largest
US dw 0   ; Unsigned Smallest

start:
    ; Initialize all variables with the first element of the array
    mov ax, [array]
    mov [SL], ax
    mov [SS], ax
    mov [UL], ax
    mov [US], ax

    mov cx, 9          ; Remaining 9 elements since there are 10 in total
    mov si, 2          ; Offset to 2nd element
    mov bx, array      ; Base address of array

next:
    mov ax, [bx + si]  ; Load current element

    ; ---- Signed Largest ----
    mov dx, [SL]
    cmp ax, dx
    jle skipSL
    mov [SL], ax
skipSL:

    ; ---- Signed Smallest ----
    mov dx, [SS]
    cmp ax, dx
    jge skipSS
    mov [SS], ax
skipSS:

    ; ---- Unsigned Largest ----
    mov dx, [UL]
    cmp ax, dx
    jbe skipUL
    mov [UL], ax
skipUL:

    ; ---- Unsigned Smallest ----
    mov dx, [US]
    cmp ax, dx
    jae skipUS
    mov [US], ax
skipUS:

    add si, 2           ; Move to next element
    loop next

    mov ax, 0x4C00
    int 0x21
