[org 0x0100]       
jmp start

gcd:
    cmp ax, bx
    je gcd_done         ;we do this algorithm till both numbers are equal
	
loop:
    cmp ax, bx ; check if both numbers are equal
    je done         ; if equal, done
    ja ax_bigger        ; if AX > BX
    sub bx, ax          ; we subtract the smaller number from the bigger number
    jmp loop

ax_bigger:
    sub ax, bx          ; AX = AX - BX
    jmp gcd_loop

done:
    ret
	
start:
    mov ax, 48          ; first number
    mov bx, 18          ; second number
    call gcd            ; call this function with ax and bx

    mov ax, 0x4c00
    int 0x21