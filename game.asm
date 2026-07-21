[org 0x0100]

jmp start

;data section
player_pos: dw 3918           ; center of last row: row 24, col 39
player_char: db 0x2A          ; character *
player_attr: db 0x19          ; blue on black (0001 1001)

goal_pos: dw 160              ; top left corner: row 1, col 0
goal_attr: db 0x44            ; space with red background (0100 0100)

direction: db 1               ; 0=up, 1=right, 2=down, 3=left
timer_count: db 0             ; Counter for timer interrupts
game_over: db 0               ; Game state flag (0=running, 1=win, 2=lose)
old_timer: dd 0               ; Store old timer interrupt vector
old_keyboard: dd 0            ; Store old keyboard interrupt vector

msg_win: db 'Game Win! Press any key to exit...$'
msg_lose: db 'Game Lost! Press any key to exit...$'

;clear screen
clrscr:
push es
push ax
push cx
push di

mov ax, 0xb800
mov es, ax
xor di, di
mov ax, 0x0720   ;space char in normal attribute
mov cx, 2000    ;no of screen location 

cld     ;auto increement
rep stosw    ;clear whole screen

pop di
pop cx
pop ax
pop es
ret

; subroutine to place obstacles on the screen
place_obstacles:
    push ax
    push cx
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax                ; points es to video base
    mov ax, 0x2220            ; green on black, space
    
   ; vertical bar at column 3 (rows 2-21)
    mov cx, 6
    mov di, 326               ; Row 2, col 3 (2*160 + 3*2)
	
vert1_loop:
    mov [es:di], ax
    add di, 160               ; Next row
    loop vert1_loop
    
    ; vertical bar at column 40; rows from 3-17
	
    mov cx, 6
    mov di, 560               ; row 3, col 40 (3*160 + 40*2)
	
vert2_loop:
    mov [es:di], ax
    add di, 160
    loop vert2_loop
    
    ; vertical bar at column 60; rows from 4-21
    mov cx, 6
    mov di, 760               ; row 4, col 60 (4*160 + 60*2)
	
vert3_loop:
    mov [es:di], ax
    add di, 160
    loop vert3_loop
    
    ; horizontal bar at row 10; columns from 10-39
    mov cx, 6
    mov di, 1620              ; row 10, col 10 (10*160 + 10*2)
	
horiz1_loop:
    mov [es:di], ax
    add di, 2
    loop horiz1_loop
    
    ; Horizontal bar at row 13 (columns 45-69)
    mov cx, 10
    mov di, 2170              ; Row 13, col 45 (13*160 + 45*2)
	
horiz2_loop:
    mov [es:di], ax
    add di, 2
    loop horiz2_loop
    
    ; Horizontal bar at row 18 (columns 20-49)
    mov cx, 10
    mov di, 2920              ; Row 18, col 20 (18*160 + 20*2)
	
horiz3_loop:
    mov [es:di], ax
    add di, 2
    loop horiz3_loop
    
    ; Right boundary (column 79, all rows)
    mov cx, 25
    mov di, 158               ; Row 0, col 79 (0*160 + 79*2)
	
boundary_loop:
    mov [es:di], ax
    add di, 160
    loop boundary_loop
    
    pop es
    pop di
    pop cx
    pop ax
    ret

; Subroutine to place goal at top left corner
place_goal:
    push ax
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax                ; points es to video base
    mov di, [goal_pos]        ; load goal position
    mov ax, 0x4420            ; red background, space
    mov [es:di], ax
    
    pop es
    pop di
    pop ax
    ret

; Subroutine to place player
place_player:
    push ax
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax              
    mov di, [player_pos]      ; load player position
    mov al, [player_char]     ; load player character
    mov ah, [player_attr]     ; load player attribute
    mov [es:di], ax
    
    pop es
    pop di
    pop ax
    ret

; Subroutine to clear player from current position
clear_player:
    push ax
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax               
    mov di, [player_pos]      ; load player position
    mov ax, 0x0720            ; black background, space
    mov [es:di], ax
    
    pop es
    pop di
    pop ax
    ret
	
; Subroutine to check if theres 2collision with obstacle or boundary
; check_collision - returns AX=0 (no collision) or AX=1 (collision)
check_collision:
    push di
    push es
    
    mov ax, 0xb800
    mov es, ax
    mov di, [player_pos]
    mov ax, [es:di]
    
    cmp ax, 0x2220
    je collision_detected
    
    xor ax, ax         ; ax = 0 theres no collision
    pop es
    pop di
	
    ret
    
collision_detected:
    mov ax, 1          ; ax = 1 theres collision 
	
    pop es
    pop di
	
    ret

; Subroutine to check if reached goal
; check_goal - returns AX=0 (not at goal) or AX=1 (at goal)
check_goal:
    push bx
    
    mov ax, [player_pos]
    cmp ax, [goal_pos]
    je goal_reached
    
    pop bx
    xor ax, ax         ; ax = 0; not at goal
	
    ret

goal_reached:
    pop bx
    mov ax, 1          ; ax = 1; at goal
	
    ret

; Subroutine to move player
move_player:
    push ax
    push bx
    
    call clear_player         ; clear current position
    
    mov al, [direction]
    cmp al, 0                 ; Up
    je move_up
	
    cmp al, 1                 ; Right
    je move_right
	
    cmp al, 2                 ; Down
    je move_down
	
    cmp al, 3                 ; Left
    je move_left
	
    jmp move_done
    
move_up:
    mov ax, [player_pos]
    sub ax, 160               ; Move up one row
    cmp ax, 0
	
    jl move_done              ; dont go beyond screen
    mov [player_pos], ax
    jmp move_done
    
move_right:
    mov ax, [player_pos]
    add ax, 2                 ; move right one column
	
    mov [player_pos], ax
    jmp move_done
    
move_down:
    mov ax, [player_pos]
    add ax, 160               ; move down one row
    cmp ax, 4000
	
    jge move_done             
    mov [player_pos], ax
    jmp move_done
    
move_left:
    mov ax, [player_pos]
    sub ax, 2                 ; move left one column
    cmp ax, 0
	
    jl move_done             
    mov [player_pos], ax
    
move_done:
    
    call check_collision  ; check for collisions
    cmp ax, 0
    jne game_lost_handler
    
    call check_goal  ; check if reached goal
    cmp ax, 0
    jne game_win_handler
    
    call place_player
	
    pop bx
    pop ax
	
    ret
	
game_lost_handler:
    mov byte [game_over], 2   ; set game state to lost
	
    pop bx
    pop ax
	
    ret

game_win_handler:
    mov byte [game_over], 1   ; set game state to win
	
    pop bx
    pop ax
	
    ret

; Subroutine to display message
display_message:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
    ; clear a line in the middle to displau message
    mov ax, 0xb800
    mov es, ax
	
    mov di, 1920              ; row 12, col 0 (12*160+0*2)
    mov cx, 80
    mov ax, 0x0720
    rep stosw
    
    ; display message centered
    mov di, 1960              ; row 12, col 20   (12*160+20*2)
    mov si, dx                ; dx contains message the offset
    mov ah, 0x0F              ; white on black
    
display_loop:
    lodsb                ;loads data from ds:si into al/ax 
	cmp al, '$'          ; check for string terminator
	
    je display_done
    stosw
    jmp display_loop
    
display_done:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
; Timer interrupt handler
timer_interrupt:
    push ax
    push ds
    
    mov ax, cs
    mov ds, ax                ; initialize ds to code segment
    
    ; increment timer count
    inc byte [timer_count]
    
    ; check if 2 interrupts have passed
    cmp byte [timer_count], 2
    jl timer_done
    
    ; reset counter
    mov byte [timer_count], 0
    
    ; check if game is over
    cmp byte [game_over], 0
    jne timer_done
    
    ; move player
    call move_player
    
timer_done:
    pop ds
    pop ax
    
    ; chain to old timer interrupt
    jmp far [cs:old_timer]

; Keyboard interrupt handler
keyboard_interrupt:
    push ax
    push ds
    
    mov ax, cs
    mov ds, ax                
    
    in al, 0x60               ; read scan code
    
    ; Check arrow keys
    cmp al, 0x48              ; Up arrow
    je key_up
	
    cmp al, 0x4D              ; Right arrow
    je key_right
	
    cmp al, 0x50              ; Down arrow
    je key_down
	
    cmp al, 0x4B              ; Left arrow
    je key_left
	
    jmp key_done
    
key_up:
    mov byte [direction], 0
    jmp key_done
    
key_right:
    mov byte [direction], 1
    jmp key_done
    
key_down:
    mov byte [direction], 2
    jmp key_done
    
key_left:
    mov byte [direction], 3
    
key_done:
    ; send EOI to PIC
    mov al, 0x20
    out 0x20, al
    
    pop ds
    pop ax
    iret

	
start:
mov ax, cs
mov ds, ax

call clrscr
call place_obstacles
call place_goal
call place_player

 ; hook timer interrupt (INT 0x08)
    cli                       ; disables interrupts
 ; save old timer interrupt
    xor ax, ax
    mov es, ax
	
    mov ax, [es:0x08*4]
    mov [old_timer], ax
    mov ax, [es:0x08*4 + 2]
    mov [old_timer + 2], ax
    
    ; set new timer interrupt
    mov word [es:0x08*4], timer_interrupt
    mov [es:0x08*4 + 2], cs
    
    ; save old keyboard interrupt
    mov ax, [es:0x09*4]
    mov [old_keyboard], ax
    mov ax, [es:0x09*4 + 2]
    mov [old_keyboard + 2], ax
    
    ; set new keyboard interrupt
    mov word [es:0x09*4], keyboard_interrupt
    mov [es:0x09*4 + 2], cs
    
    sti     ; enables interrupts
    
 ; Game loop; waits for the game to end
game_loop:
    ; check if game is over
    cmp byte [game_over], 0
    jne end_game
    
    ; small delay
    mov cx, 0xFFFF
	
delay_loop:
    loop delay_loop
    
    jmp game_loop
    
end_game:
    ; restore interrupts
    cli                  
    
    xor ax, ax
    mov es, ax
    
    ; restore timer interrupt
    mov ax, [old_timer]
    mov [es:0x08*4], ax
    mov ax, [old_timer + 2]
    mov [es:0x08*4 + 2], ax
    
    ; restore keyboard interrupt
    mov ax, [old_keyboard]
    mov [es:0x09*4], ax
    mov ax, [old_keyboard + 2]
    mov [es:0x09*4 + 2], ax
    
    sti                      
    
    ; display appropriate message
    cmp byte [game_over], 1
    je show_win
    
    mov dx, msg_lose
    jmp show_message
    
show_win:
    mov dx, msg_win
    
show_message:
    call display_message
    
    ; wait for the keypress
    mov ah, 0x00
    int 0x16
    
    call clrscr   ; clear screen before exiting
    
mov ax, 0x4c00
int 0x21

