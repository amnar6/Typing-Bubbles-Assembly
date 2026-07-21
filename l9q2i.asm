[org 0x0100]

mov ah, 0
int 16h

mov bl, al        ; ASCII code
mov bh, ah        ; Scan code


; Print ASCII message
mov dx, msgAscii
mov ah, 9
int 21h

; Convert ASCII to hex
mov al, bl
call byte_to_hex

mov dx, hexBuf
mov ah, 9
int 21h

; New line
mov dx, newline
mov ah, 9
int 21h


; Print Scan Code message
mov dx, msgScan
mov ah, 9
int 21h

; Convert scan code to hex
mov al, bh
call byte_to_hex

mov dx, hexBuf
mov ah, 9
int 21h

; Exit
mov ax, 4C00h
int 21h


; Convert byte in AL to hex string
byte_to_hex:
    mov ah, al
    shr al, 4
    call nibble
    mov [hexBuf], al

    mov al, ah
    and al, 0Fh
    call nibble
    mov [hexBuf+1], al

    mov byte [hexBuf+2], '$'
    ret

nibble:
    add al, '0'
    cmp al, '9'
    jbe done
    add al, 7
done:
    ret

msgAscii: db 'ASCII Code (BIOS): $'
msgScan:  db 'Scan Code (BIOS): $'
hexBuf:   db '00$'
newline:  db 13,10,'$'