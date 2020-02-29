dataseg segment

	letter db 0
	digit db 0
	other db 0

	input label byte
	smax db 80		
	slen db ?
	string db 80 dup(?)
	
	mess1 db 'Please input the string: ','$'
	mess2 db 'The number of letter is ','$'
	mess3 db 'The number of digit is ','$'
	mess4 db 'The number of other is ','$'

dataseg ends

codeseg segment
	assume cs:codeseg, ds:dataseg, es:dataseg

main proc far
	push ds
	sub ax,ax
	push ax
	mov ax,dataseg
	mov ds,ax
	mov es,ax

start:
	lea dx,mess1 ;输入关键字
	mov ah,09
	int 21h
	lea dx,input 
	mov ah,0ah
	int 21h

	mov ah,02h ;换行
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	mov ch,0
	mov cl,slen
	mov si,0
next:
	mov dx,0
	mov dl,string[si]
	cmp dl,30h ; <'0'
	jb others
	cmp dl,3ah ; <='9'
	jb digits
	cmp dl,41h; <'A' 
	jb others
	cmp dl,5bh ;<='Z'
	jb letters
	cmp dl,61h;<'a'
	jb others
	cmp dl,7bh;<='z'
	jb letters
others:
	inc other
	jmp last
letters:
	inc letter
	jmp last
digits:
	inc digit
last:
	inc si
	loop next

	lea dx,mess2
	mov ah,09
	int 21h

	mov bh,0
	mov bl,letter 
	call change

	mov ah,02h ;换行
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	lea dx,mess3
	mov ah,09
	int 21h

	mov bh,0
	mov bl,digit
	call change

	mov ah,02h ;换行
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	lea dx,mess4
	mov ah,09
	int 21h

	mov bh,0
	mov bl,other
	call change

	mov ah,02h ;换行
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h

	ret
main endp
;
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
;
codeseg ends
end main


	