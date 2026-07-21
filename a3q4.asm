[org 0x0100]

jmp start 

start:
    call swapRows
    mov ax, 0x4c00
    int 0x21

swapRows:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

;loop for 12 rows
	mov cx, 12   ;pairc count (0-23)
	xor bp, bp   ;pair index

pairloop:
    ;row0 offset = BP * 320  (2 rows * 160 bytes)
	
    mov ax, bp
    mov dx, 0
	mov bx, 320          ; 2 rows = 320
    mul bx               ; AX = BP * 320 bytes
    mov si, ax           ; SI = byte offset of row0 in AX
	;now si = address of row0

    ; copy row0 (80 words) from video to tempRow, use DS=video, ES=cs
	
    push ds
	
    mov ax, 0xB800
    mov ds, ax
	
    mov ax, cs
    mov es, ax    ; es has tempRow
	
    mov di, tempRow
    mov cx, 80      ;80 words per row
    rep movsw       ;rep movsw copies words
    pop ds

    ; copy row1 to row0 both in video ; set DS=ES=video
    mov ax, 0xB800
    mov ds, ax
    mov es, ax
	
    ; source = row0 offset + 160
    mov si, si
    mov si, ax
	add si, 160
	sub di, ax
	
    mov cx, 80
    rep movsw

    ; copy tempRow to row1 (program to video)
    mov ax, cs
    mov ds, ax
	
    mov ax, 0xB800
    mov es, ax
    mov si, tempRow
    mov di, si
	add di, 160    ; row1 = row0 + 160
    mov cx, 80
    rep movsw

    ; next pair
    inc bp
    loop pairloop

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;80 words = 160 bytes
tempRow:  times 160 db 0