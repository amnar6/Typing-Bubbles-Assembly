; Task 2: Hook Timer Interrupt and Count Ticks
[org 0x0100]

jmp start

OldOff: dw 0          
OldSeg: dw 0          

TickCount: dw 0          

msg: db 'Tick Count = $'
newline: db 0Dh, 0Ah, '$'

OldInt08: dw 0, 0       


NewISR:
    push ax
    push ds

    mov ax, cs
    mov ds, ax            
    inc word [TickCount]
    
    pop ds
    pop ax

    jmp far [OldInt08]    


start:
    cli 
    mov ax, 0
    mov ds, ax            

    mov bx, 8
    shl bx, 2             

    mov ax, [bx]          
    mov [OldOff], ax
    mov [OldInt08], ax

    mov ax, [bx+2]        
    mov [OldSeg], ax
    mov [OldInt08+2], ax

    mov ax, cs            
    mov ds, ax

    mov ax, 0
    mov ds, ax

    mov bx, 8
    shl bx, 2

    mov word [bx], NewISR      
    mov word [bx+2], cs        

    sti                   

MainLoop:
    mov dx, msg
    mov ah, 0x09
    int 0x21

    
    mov ax, [TickCount]
    call PrintHex

    ; new line
    mov dx, newline
    mov ah, 0x09
    int 0x21

    jmp MainLoop

PrintHex:
    push ax
    push bx 
    push cx
    push  dx

    mov cx, 4        

ph_loop:
    rol ax, 4
    mov bl, al
    and bl, 0x0F
    cmp bl, 10
    jl ph_d
    add bl, 0x37
    jmp ph_p
	
ph_d:
    add bl, 0x30
	
ph_p:
    mov dl, bl
    mov ah, 0x02
    int 0x21
    loop ph_loop

    pop dx 
    pop cx
    pop bx
    pop ax
    ret
