[org 0x0100]
jmp start

array db -7, 4, -12, 9, 0, 5, -2, 13, -6, 8
UL db 0     ; Unsigned Largest (absolute largest)
US db 0     ; Unsigned Smallest (absolute smallest)
SL db 0     ; Signed Largest
SSmall db 0     ; Signed Smallest

start:
    mov al, [array]
    mov [SL], al
    mov [SSmall], al

    ;abs the first elemnt
	
    mov bl, al
    cmp bl, 0
    jge no_neg
	
no_neg:
    mov [UL], bl
    mov [US], bl

    mov cx, 9         ; 10 elements total, already used first
    mov si, array + 1

loop_elements:
    mov al, [si]

    ;SL
    mov bl, [SL]
    cmp al, bl
    jle skipSL
    mov [SL], al
skipSL:

    ;SS
    mov bl, [SSmall]
    cmp al, bl
    jge skipSSmall
    mov [SSmall], al
skipSSmall:

    ;abs for unsigned comparison
    mov bl, al
    cmp bl, 0
    jge abs_done
    neg bl
abs_done:

    ;UL
    mov dl, [UL]
    cmp bl, dl
    jbe skipUL
    mov [UL], bl
skipUL:

    ;US
    mov dl, [US]
    cmp bl, dl
    jae skipUS
    mov [US], bl
skipUS:

    inc si
    loop loop_elements

end:
    mov ax, 0x4c00
    int 0x21
