org 100h
jmp start
string db "    1    |    2    |    3     ---------|---------|----------    4    |    5    |    6     ---------|---------|----------    7    |    8    |    9     "
size dw 150
array dw 0x03f0,0x0404,0x0418,0x0530,0x0544,0x0558,0x0670,0x0684,0x0698; adress of 1,2,3,4,5,6,7,8,9 
ply db 01
st_player db "player "
tick db "X"
cross db "0"
loop_check dw 1
count1 dw 0
count2 dw 0
count3 dw 0
d db "Draw"  
moves dw 0
w db " win's"

start:
lea si,string
push si
call display:

infinty:
lea si,st_player
push 0
push si
push 7
call player:
call enter:
pop ax                        
mov ah,0
push ax 
call move
cmp moves,5
jl exit7
call rows
call cols
call diagnols
call draw 

exit7:
cmp loop_check,1  
jz infinty
ret

display:;dislay grid
pop bp
pop si
mov ax,0xb800
mov es,ax
mov ah,0x0f
mov cx,size
mov di,1000
l1:
lodsb
stosw
inc bx
cmp bx,30
jne l2:
sub di,bx
sub di,bx
mov bx,0
add di,160
l2:
loop l1:
mov ax,ds
mov es,ax
push bp
ret

enter:;take value from user
pop bp
mov ax, 0xB800
mov es, ax
mov di,160
mov al,' '
mov es:[di],al
again:
mov dh, 1
mov dl, 0
mov bh, 0
mov ah, 2
int 10h; set cursor position.
mov ah, 0
int 0x16;get keystroke from keyboard 
mov ah,0x0f
cmp al,0x31;check the value from the user that it is between 1 from 9
jl again:
cmp al,0x39;check the value from the user that it is between 1 from 9
jg again
stosw
push ax
push bp
ret

Player:;Display player
pop si
pop cx
pop bp
pop dx
mov al,ply 
add al,30h
mov [bp+6],al
mov ax,1
mov bh,0
mov bl,0x0f
mov ah, 13h
int 10h
push si 
ret

move:;
pop bp
pop ax
sub al,30h
dec ax
mov dx,0xb800
mov es,dx
mov bx,2
mul bx
mov bx,ax
mov di,array[bx]      
cmp ply,1
jz t
jnz c

t:
mov dl,tick
jmp exit2

c:
mov dl,cross

exit2:
mov dh,0x0f
cmp es:[di],"X" 
jz skip:
cmp es:[di],"0"
jz skip:
mov es:[di],dx
inc moves 
call swap
skip:
mov ax,ds
mov es,ax
push bp
ret

increment:
inc ply
jmp exit

decrement:
dec ply
jmp exit

swap:
cmp ply,1
jz increment
jnz decrement
exit:
ret
                   
rows:
pop bp
mov ax,0xb800
mov es,ax
mov cx,3
mov bx,0
loop_row:
mov si,array[bx+0]
mov ax,es:[si]
mov count1,ax

mov si,array[bx+2]
mov ax,es:[si]
mov count2,ax

mov si,array[bx+4]
mov ax,es:[si]
mov count3,ax
;checking win condition
mov ax,count1
cmp ax,count2
jnz exit3
cmp ax,count3
jnz exit3

mov ax,ds
mov es,ax
call swap
lea si,st_player
push 0x000f
push si
push 7
call player:
lea si,w
push 0x0018
push si
push 6
call player:
.exit

exit3:
add bx,6
loop loop_row 
mov ax,ds
mov es,ax
push bp
ret
             

cols:
pop bp
mov ax,0xb800
mov es,ax
mov cx,3
mov bx,0
loop_col:
mov si,array[bx+0]
mov ax,es:[si]
mov count1,ax

mov si,array[bx+6]
mov ax,es:[si]
mov count2,ax

mov si,array[bx+12]
mov ax,es:[si]
mov count3,ax

mov ax,count1
cmp ax,count2
jnz exit4
cmp ax,count3
jnz exit4

mov ax,ds
mov es,ax
call swap
lea si,st_player
push 0x000f
push si
push 7
call player:
lea si,w
push 0x0018
push si
push 6
call player:
.exit


exit4:
add bx,2
loop loop_col 
mov ax,ds
mov es,ax
push bp
ret 

diagnols:
pop bp
mov ax,0xb800
mov es,ax
mov bx,0


mov si,array[0]
mov ax,es:[si]
mov count1,ax

mov si,array[8]
mov ax,es:[si]
mov count2,ax

mov si,array[16]
mov ax,es:[si]
mov count3,ax

mov ax,count1
cmp ax,count2
jnz exit5
cmp ax,count3
jnz exit5

mov ax,ds
mov es,ax
call swap
lea si,st_player
push 0x000f
push si
push 7
call player:
lea si,w
push 0x0018
push si
push 6
call player:
.exit

exit5:
 
mov si,array[4]
mov ax,es:[si]
mov count1,ax

mov si,array[8]
mov ax,es:[si]
mov count2,ax

mov si,array[12]
mov ax,es:[si]
mov count3,ax

mov ax,count1
cmp ax,count2
jnz exit6
cmp ax,count3
jnz exit6

mov ax,ds
mov es,ax
call swap
lea si,st_player
push 0x000f
push si
push 7
call player:
lea si,w
push 0x0018
push si
push 6
call player:
.exit

exit6:


mov ax,ds
mov es,ax
push bp
ret 


draw:
cmp moves,9
jne donotstop:
mov loop_check,0
mov ax,ds
mov es,ax
call swap
lea si,d
push 0x000f
push si
push 4
call player:
donotstop:
ret
                                  