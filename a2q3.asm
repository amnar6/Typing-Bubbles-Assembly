[org 0x0100]

jmp start

Array db 0A7h, 0A3h, 094h, 0FFh, 00h    ; Original data (5 bytes)

start:
    mov si, 0        ; Source index (reads all elements)
    mov di, 0        ; Destination index (for even-parity values)
    mov cx, 5        ; Process 5 elements

NextByte:
    mov al, [Array + si]   ; Load current byte
    mov bl, al             ; Copy original byte to BL for bit counting
    xor bh, bh             ; Clear BH (bit counter)  !!
    mov dl, 8              ; Total 8 bits

CountBits:
    shr bl, 1              ; Shift right 1 bit
    jnc SkipInc            ; 0 aya
    inc bh                 ; Count 1s in BH
	
SkipInc:
    dec dl
    jnz CountBits

    mov al, bh
    and al, 1              ; AL = 0 if even, 1 if odd
    cmp al, 0
    jne SkipStore          ; Skip if parity is odd

    ; Store even parity number at current DI
    mov al, [Array + si]
    mov [Array + di], al
    inc di

SkipStore:
    inc si
    loop NextByte

;Clear remaining positions
ClearRest:
    cmp di, 5
    jge Done
    mov byte [Array + di], 0
    inc di
    jmp ClearRest

Done:
  mov ax, 0x4c00
  int 0x21
