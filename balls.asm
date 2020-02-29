;
;***********************************
data segment
	input db ?
	count dw 1
	row dw 0
	col dw 0
	msg db 'here',0dh,0ah,'$'
data ends
;**********************************
prognam segment
;-----------------------------------
main proc far
     assume ds:data,cs:prognam
start:
	push ds
	sub ax,ax
	push ax
	mov ax,data
	mov ds,ax
	mov ah,01h
	int 21h
	mov input,al

	mov dl,0ah
	mov ah,02h
	int 21h

	mov dl,0dh
	mov ah,02h
	int 21h

	mov dl,bl
	mov ah,02h
	int 21h

	mov ah,6
	mov al,0
	mov bh,7
	mov ch,0
	mov cl,0
	mov dh,24
	mov dl,79
	int 10h

	mov bh,0
	mov dh,5
	mov dl,7
	mov ah,2
	int 10h

	mov bh,0
	mov al,input
	mov cx,1
	mov ah,10
	int 10h

	mov al,1ch
	mov ah,35h
	int 21h
	push es
	push bx
	push ds

	mov dx,offset print
	mov ax,seg print
	mov ds,ax
	mov al,1ch
	mov ah,25h
	int 21h
	
	pop ds
	in al,21h
	and al,11111110b
	out 21h,al
	sti

	mov di,20000
delay:
	mov si,30000
delay1:
	dec si
	jnz delay1
	dec di
	jnz delay

	pop dx
	pop ds
	mov al,1ch
	mov ah,25h
	int 21h	

	mov ax,4c00h
	int 21h
main endp
;---------------------
print proc near
	push ds
	push ax
	push cx
	push dx
	mov ax,data
	mov ds,ax
	sti
	
	dec count
	jnz exit
	
	call screen

	mov count,5

exit:
	cli
	pop dx
	pop cx
	pop ax
	pop ds
	iret
print endp
;-------------------
screen proc near
	;mov dl,input
	;mov ah,02
	;int 21h
	
	mov ah,3; read cursor pos
	mov bh,0
	int 10h

	mov bh,0; display cursor
	mov al,' '
	mov cx,1
	mov ah,10
	int 10h

	mov ah,3; read cursor pos
	mov bh,0
	int 10h
	
	cmp row,0
	jz add1
	jnz dec1
add1:
	inc dh
	jmp next1
dec1:
	dec dh
next1:
	cmp col,0
	jz add2
	jnz dec2
add2:
	inc dl
	jmp next2
dec2:
	dec dl
next2:
	mov bl,0; set cursor
	mov ah,2
	int 10h

	mov bh,0
	mov al,input
	mov cx,1
	mov ah,10
	int 10h

	cmp dh,24
	jz change1
	cmp dh,0
	jz change2
	jnz next3
change1:
	mov row,1
	jmp next3
change2:
	mov row,0
next3:
	cmp dl,79
	jz change3
	cmp dl,0
	jz change4
	jnz next4
change3:
	mov col,1
	jmp next4
change4:
	mov col,0
next4:
	ret
screen endp
prognam ends
;**********************
end start
	