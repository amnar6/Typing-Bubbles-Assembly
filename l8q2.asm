[org 0x0100]
jmp start

mainStr db 'FASTNUCEFASTNU',0
subStr  db 'NU',0
Index   dw -1
foundMsg db 'FOUND$'
notFoundMsg db 'NOT FOUND$'

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov si, mainStr
    mov bx, 0

search_loop:
    mov di, subStr
    mov cx, 2                ; length of substring "NU"

compare_loop:
    mov al, [si]
    mov ah, [di]
    cmp al, 0
    je not_found             ; reached end of main string
    cmp ah, 0
    je found                 ; reached end of substring (match)
    cmp al, ah
    jne no_match
    inc si
    inc di
    loop compare_loop
    jmp found

no_match:
    inc bx
    mov si, mainStr
    add si, bx
    cmp byte [si], 0
    jne search_loop
    jmp not_found

found:
    mov [Index], bx

    ; move cursor to row 5, column 24
    mov ah, 02h
    mov bh, 0
    mov dh, 5
    mov dl, 24
    int 10h

    ; print FOUND
    mov dx, foundMsg
    mov ah, 09h
    int 21h
    jmp done

not_found:
    ; move cursor to row 5, column 24
    mov ah, 02h
    mov bh, 0
    mov dh, 5
    mov dl, 24
    int 10h

    ; print NOT FOUND
    mov dx, notFoundMsg
    mov ah, 09h
    int 21h

done:
    mov ah, 4Ch
    int 21h
