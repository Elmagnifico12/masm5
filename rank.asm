datarea segment
	grade dw 88,75,95,63,98,78,87,73,90,60
	rank dw 10 dup(?)
	mess1 db 10,13,'student rank:'
	mess2 db 'student grade:'
datarea ends
prognam segment
main proc far
	assume cs:prognam,ds:datarea
start:
;set up stack for return
	push ds
	sub ax,ax
	push ax

;set ds regesiter to current data segment
mov ax,datarea
mov ds,ax

;main part of program
mov di,10
mov bx,0
loop2:
mov ax,grade[bx]
mov dx,0
mov cx,10
lea si,grade
next:
	cmp ax,[si]
	jg no_count
	inc dx
no_count:
	add si,2
	loop next
	mov rank[bx],dx
	add bx,2
	dec di
	jne loop2
	mov di,10
loop1:
	lea dx,mess1
	mov ah,09
	int 21h
	push dx
	mov ah,02h
	mov dx,rank[di]
	int 21h
	pop dx
	
	mov ah,09h
	lea dx,mess2
	int 21h
	push dx
	mov ah,02h
	mov dx,grade[di]
	int 21h
	pop dx
	
	dec di
	jne loop1
	ret
main endp
prognam ends
end start

