[org 0x0100]

jmp start

start:
call makeBorders

mov ax, 0x4c00
int 0x21

makeBorders:
push ax
push bx
push cx
push dx
push si
push di

mov ax, 0B800h    ;set es , video
mov es, ax


mov ax, ' '
mov ah, 0x07    ;black backgrounf
mov cx, 2000    ;4000 bytes /2 = 2000 words
xor di, di
rep stosw   ;fill screen

mov ax, 'A'
mov ah, 0xF4   ; red on white
xor di, di
mov cx, 80  ;first full row
rep stosw  ;fill


;bottom row,  row = 24, offset will be 24 x 160 = 3840 bytes, word = 1920
mov di, 24
mov bx, 80
mul bx       ;24 x 80
shl ax, 1    ;multiply by 2, worf 
mov di, ax
mov cx, 80
rep stosw


;left and right column 1-23
mov si, 1

column:
mov ax, si
mov bx, 80
mul bx
shl ax, 1
mov di, ax

mov ax, 'A'
mov ah, 0xF4
mov [es:di], ax   ;left column

; right column
add di, 158    ;79x2= 158 bytes 
mov [es:di], ax

inc si
cmp si,24
jle column

;now with B, inner
mov ax, 'B'
mov ah, 0xF9  ;blinking bit 1 + blue

;top row
mov di, 1
mov bx, 80  ;characters
mul bx
shl ax, 1
mov di, ax    ;start from row 1
add di, 2     ; skip outer border
mov cx, 78    ; from columns 1-78
rep stosw

;bottom row
mov ax, 23
mov bx, 80
mul bx
shl ax, 1
mov di, ax   ;row 23
add di, 2
mov cx, 78
rep stosw

;left and right column

mov si, 2

innercolumn:
mov ax, si
mov bx, 80
mul bx
shl ax, 1
mov di, ax

;left column
add di, 2     ;add 2 bytes cuz inner, inner left
;mov [es:di], ax  ;write the word

;now reload ax with character and collour
mov ax, 'B'
mov ah, 0xF9
mov [es:di], ax

; right column
add di, 154   ;78x2 
mov [es:di], ax

inc si
cmp si, 23
jle innercolumn


pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

