[org 0x100]

jmp start

start:

; install ISR
cli        ;clear interrupt flag, so the cpu doesntv try to use an interrupt 
mov ax, cs   ;copy .com program segment
mov ds, ax
mov dx, newISR
mov ax, 2560h ;loads two values, ah = 25h (set intterupt vector) , al= 60h 9set interrupt number)
int 21h
sti   ;set interrupt flag 

int 60h   ; call it

; exit
mov ah, 4Ch
int 21h

;interrupt routine
newISR:
push ax
push dx
mov ah, 9
mov dx, msg
int 21h
pop dx
pop ax
iret

msg: db 'Custom Interrupt Triggered!$'