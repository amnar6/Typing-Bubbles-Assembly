[org 0x0100]

mov ah, 0x06         ; Scroll up function
mov al, 0            ; Clear entire screen
mov bh, 0x07         ; Attribute (white on black)
mov cx, 0x0000       ; Upper-left corner (row=0, col=0)
mov dx, 0x184F       ; Lower-right corner (row=24, col=79)
int 0x10             ; Call video interrupt


; Display 'A' at top-left corner
mov ax, 0xB800       ; Video memory segment
mov es, ax
xor di, di           ; Offset 0 -> top-left corner

mov al, 'A'          ; Character to print
mov ah, 0x1E         ; Color: yellow on blue (you can change this)
mov [es:di], ax      ; Write character + color to video memory

mov ah, 0x00
int 0x16             ; BIOS keyboard input (waits for key)


mov ax, 0x4C00
int 0x21