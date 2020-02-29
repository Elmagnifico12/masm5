DATA SEGMENT
numbers_count db 0
character_count db 0
others_count db 0
mess1 db 'enter a line:','$'
mess2 db 'characters: ','$'
mess3 db 'numbers: ','$'
mess4 db 'others: ','$'
change db 13,10,'$'

line label byte
max1 db 1000
act1 db ?
linee db 20 dup(?)

DATA ENDS
 
;---------------------
STACKS SEGMENT
STACKS ENDS
;----------------------

CODE SEGMENT
main proc far
assume cs:code,ds:data,es:data
START:
PUSH ds
SUB AX,AX
PUSH AX
MOV AX,DATA
MOV DS,AX
MOV ES,AX
sub si,si
;--------MAIN PART STARTS HERE
lea dx,mess1
mov ah,09
int 21h
lea dx,line
mov ah,0ah
int 21h

cmp act1,0
je exit
lea dx,change
mov ah,09
int 21h
mov si,0
comp:
inc si
cmp si,act1
ja exit
cmp linee[si],30h
jb not_digits
cmp linee[si],39h
ja not_number
inc numbers_count
jmp comp
not_number:
cmp linee[si],41h
jb others
cmp linee[si],5bh
jb characters
cmp linee[si],61h
jb others
cmp linee[si],7bh
jb characters
others:
inc others_count
jmp comp
characters:
inc character_count
jmp comp
exit:
lea dx,mess2
	mov ah,09
	int 21h

	mov bh,0
	mov bl,character_count 
	call change

	mov ah,02h 
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	lea dx,mess3
	mov ah,09
	int 21h

	mov bh,0
	mov bl,numbers_count
	call change

	mov ah,02h 
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	lea dx,mess4
	mov ah,09
	int 21h

	mov bh,0
	mov bl,others_count
	call change

	mov ah,02h 
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	ret
main endp

change proc near

	push ax
	push bx
	push cx
	push dx
	
	mov ch,4
	mov cl,4

rotate:
	rol bx,cl
	mov al,bl
	and al,0fh
	add al,30h
	cmp al,3ah
	jl printit
	add al,7h
printit:
	mov dl,al
	mov ah,2
	int 21h
	dec ch
	jnz rotate

	pop dx
	pop cx
	pop bx
	pop ax
	ret
change endp
	CODE ENDS
		end START