[org 0x0100]
jmp start

multiplicand: dd 0        
multiplier:   dw 0        
result:       dd 0
        
square:
    mov [multiplicand], ax       ; store number in multiplicand (low word)
    mov word [multiplicand+2], 0 ; clear high word of multiplicand (upper 16 bits)

    mov [multiplier], ax         ; since we are squaring, multiplier = same number
    mov [result], 0              ; clear result (low word)
    mov [result+2], 0            ; clear result (high word)

;using the code already written in q1

    mov cl, 16
    mov dx, [multiplier]

loop:
    shr dx,1
    jnc skip

    mov ax, [multiplicand]
    add [result], ax
    mov ax, [multiplicand+2]
    adc [result+2], ax

skip:
    shl word [multiplicand],1
    rcl word [multiplicand+2],1
    dec cl
    jnz loop

    
    mov ax, [result]        
    mov dx, [result+2]      
    ret
	
start:
    mov ax, 30              
    call square      

	
    mov ax, 0x4c00
    int 0x21