[org 0x0100]

jmp start

start:
    call rightAlign
	
    mov ax, 0x4C00
    int 0x21

rightAlign:

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp


;row loop initialoizer
    mov bx, 0             ; row index 0

rowloop:
    cmp bx, 25
	
    jge near donealign

    ;row byte base offset = bx * 160
    mov ax, bx
    mov cx, 80
    mul cx
    shl ax, 1           ;convert words to bytes by x2
    mov di, ax            ; DI is dest video offset

    ; copy row from video to rowBuf (use DS=video, ES=cs)
	
    push ds
	
    mov ax, 0xB800
    mov ds, ax
    mov ax, cs
    mov es, ax
    mov si, di            ; DS:SI = video row base
    mov di, rowBuf         ;rowbuff contains 80 word row
    mov cx, 80
    rep movsw
    pop ds

    ; scan rowBuf for a first nonspace word (low byte = char)
    mov si, rowBuf
    mov cx, 80
    xor dx, dx            ; DX = index
    mov bp, -1            ; first index = -1
	
scanleft:
    mov al, [si]          ; character byte
    cmp al, ' '
    jne foundleft
    add si, 2
    inc dx
    loop scanleft
    jmp nextrow          ; is row is empty, skip alignment

foundleft:
    mov bp, dx            ; bp = first index

    ; go from right for last nonspace
    mov si, rowBuf
    add si, 158           ; last word char byte
    mov dx, 79  ;right index
	
scanright:
    mov al, [si]
    cmp al, ' '
    jne foundright
    sub si, 2
    dec dx
    loop scanright
    jmp havebounds
	
foundright:
    ; dx holds last index
	
havebounds:
    ;length = last - first + 1  ; use AX to hold length
    mov ax, dx
    sub ax, bp
    inc ax                ; AX = length, in chars
    mov cx, ax            ; CX = length

    ; destCol = 80 - length
    mov dx, 80
    sub dx, cx            ; DX = dest column

    ;byte offsets in rowBuf for src and dest (word addresses *2)
	
    mov si, bp
    shl si, 1             ; SI = src byte offset inside rowBuf
    mov di, dx
    shl di, 1             ; DI = dest byte offset inside rowBuf

    mov dx, cx
    dec dx ;last elemnt index
	
    ; SI last = rowBuf + SI + (CX-1)*2
    mov ax, dx
    shl ax, 1
    add si, ax
    add di, ax

movebackwardsloop:
    mov ax, [si]
    mov [di], ax
    sub si, 2
    sub di, 2
    dec dx
    jns movebackwardsloop

    ;mov ax, ' '
   ; mov ah, 0x07
    ;mov si, bp
    ;shl si, 1
    ;mov cx, ax            ;restore CX to length
    ;mov ax, cx
                          ;CX = length in CX
    ;mov ax, dx            ; dx now = -1 after loop maybe; recompute

    ; copy rowBuf back to video row
    push ds
	
    mov ax, cs
    mov ds, ax
	
    mov ax, 0xB800
    mov es, ax
	
    mov si, rowBuf
	
	;comput video offset again
;    mov di, di            ;video row base again
 ;   mov ax, bx
  ;  mov cx, 80
    ;video row base in DI properly
    mov ax, bx
    mov bx, 80
    mul bx
    shl ax, 1
    mov di, ax
	
	mov cx, 80
    rep movsw
    pop ds

nextrow:
    inc bx
    jmp rowloop

donealign:
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;row copy: 80 words = 160 bytes
rowBuf: times 160 db 0