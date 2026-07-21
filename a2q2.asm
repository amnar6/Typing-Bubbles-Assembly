[org 0x0100]

jmp start

Set1 db -3, -1, 2, 5, 6, 8, 9    ;already soerted
Set2 db -2, 2, 6, 7, 9
Len1 equ 7
Len2 equ 5

UnionSet db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Count db 0

start:
    mov cx, Len2        ; number of elements in Set2
    mov si, 0           ; index for Set2

NextNum:
    mov al, [Set2 + si] ; al holfds current element from Set2

    ;al is alreadr present in unionset 
    mov bl, 0           ; assume not found
    mov di, 0           ; index for UnionSet
    mov dl, [Count]     ; number of elements in UnionSet

CheckLoop:
    cmp dl, 0
    je NotFound    ;;union set is zero
    mov bh, [UnionSet + di]   ;load current elemnet in bh
    cmp bh, al          
    je Found
	
    inc di    ;index uniojnset
    dec dl
    jmp CheckLoop

Found:
    mov bl, 1       ;1 acts as af flag, if elemnet already exists in union, wont add
    jmp SkipAdd

NotFound:
    cmp bl, 1
    je SkipAdd           ; skip if found
	
    mov bl, [Count]      ; empty slot
    mov [UnionSet + bx], al
    inc  byte [Count]    ;unique elemnt added

SkipAdd:
    inc si
    loop NextNum
	

;bubble sort

    mov cl, [Count]
	
OuterLoop:          ; sort if multiole cases
    mov si, 0
    mov ch, cl   ;ch innerloop counterr
	
InnerLoop:     ;compares each pair

    mov al, [UnionSet + si]
    mov ah, [UnionSet + si + 1]
    cmp al, ah
    jle NoSwap
	
	;swap
    mov [UnionSet + si], ah
    mov [UnionSet + si + 1], al
	
NoSwap:
    inc si     ;next pair
    dec ch
    jnz InnerLoop    ;jumo if not zeero
    dec cl
    jnz OuterLoop

    mov ax, 0x4c00
    int 0x21
