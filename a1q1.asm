[org 0x0100]

array dw  5, -3, 12, -7, 9, -15, 0, 20, -1, 8

SL dw 0   ; Signed Largest
SS dw 0   ; Signed Smallest
UL dw 0   ; Unsigned Largest
US dw 0   ; Unsigned Smallest

start:
    ; Initialize with first element of the array
    mov ax, [array]
    mov SL, ax
    mov SS, ax
    mov UL, ax
    mov US, ax

    mov cx, 9          ; Loop through remaining 9 elements
    mov si, 2          ; Start from 2nd element (index 1 * 2 bytes)

next:
    mov ax, [array + si] ; Load current element

    ;Signed Largest
    cmp ax, SL
    jle skipSL
    mov SL, ax
	
skipSL:

    ;Signed Smallest
    cmp ax, SS
    jge skipSS
    mov SS, ax
	
skipSS:

    ;Unsigned Larges
    mov bx, UL
    cmp ax, bx          ; Compare as unsigned
    jbe skipUL         ; Jump if below or equal (unsigned)
    mov UL, ax
	
skipUL:

    ;Unsigned Smallest
    mov bx, US
    cmp ax, bx
    jae skipUS         ; Jump if above or equal (unsigned)
    mov US, ax
	
skipUS:

    add si, 2           ; Move to next word in array
    loop next

   
    mov ax, 0x4c00
    int 0x21
