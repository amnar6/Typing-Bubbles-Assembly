[org 0x0100]

jmp start

string db 'AssemblyLab','$'
length dw 11
reverse db 12 dup(0), '$'


start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov cx, [length]
    mov si, string
    add si, cx
    dec si
    mov di, reverse
    std

rev_loop:
    lodsb
    stosb
    loop rev_loop
    cld

    mov al, '$'
    stosb

    ;clear screen
    mov ah, 0
    mov al, 3
    int 10h

    ;display original at row 3, col 10
    mov dh, 3
    mov dl, 10
    mov si, string
    call print_string_at

    ;display reversed at row 4, col 10
    mov dh, 4
    mov dl, 10
    mov si, reverse
    call print_string_at

    ;wait for the key
    mov ah, 0
    int 16h

    mov ah, 4Ch
    int 21h


print_string_at:
    pusha
    mov ah, 02h
    mov bh, 0
    int 10h

print_loop:
    lodsb
    cmp al, '$'
    je done
    mov ah, 0Eh
    mov bh, 0
    int 10h
    jmp print_loop

done:
    popa
    ret
