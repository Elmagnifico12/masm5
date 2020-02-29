DATA SEGMENT
	mess1 DB'enter keyboard:','$'
	mess2 DB'enter sentense:','$'
	mess3 DB'match at location','$'
	mess4 DB'not match',13,10,'$'
	mess5 DB'H if the sentense',13,10,'$'
	mess6 db'debugggggggg',13,10,'$'
	change DB 13,10,'$';换行符
	stoknin1  label byte
	max1 db 10
	act1 db ?
	stokn1 db 10 dup(?)
	stoknin2 label byte
	max2 db 50
	act2 db ?
	stokn2 db 50 dup(?)
DATA ENDS

STACKS SEGMENT

STACKS ENDS

CODE SEGMENT
main proc far
assume cs:code,ds:data,es:data
START:
	push ds
	sub ax,ax
	sub bx,bx
	sub di,di
	sub si,si
	push ax
	mov ax,DATA
	mov ds,ax
	lea dx,mess1
	mov ah,09
	int 21h ;输出enterkeyword
	lea dx,stoknin1
	mov ah,0ah;获取关键字
	int 21h
	cmp act1,0
	; lea dx,mess6
	; mov ah,09
	; int 21h
	je exit;为空直接退出程序
exit:
	ret
a10:
;输入sentence并判断
	lea dx,change
	mov ah,09
	int 21h;输出换行符
	lea dx,mess2
	mov ah,09
	int 21h
	lea dx,stokn2
	mov ah,0ah
	int 21h
	mov al,act1
	cbw
	mov cx,ax
	push cx
	mov al,act2
	cmp al,0
	je a50
	sub al,act1
	je a50
	inc al
	cbw
	lea bx,stokn2
	mov di,0
	mov si,0

a20:
;比较，内循环
	mov ah,[bx+di]
	cmp ah,stokn1[si]
	jne a30
	inc di
	inc si
	dec cx
	cmp cx,0
	je a40
	jmp a20

a30:
;外循环，bx+1,清空si，di继续内循环比较
	inc bx
	dec al
	cmp al,0
	je a50
	mov di,0
	mov si,0
	pop cx
	push cx
	jmp a20

a40:
;match，bx减去收地址得到关键字位置，调用转换是拘禁致函数输出
	sub bx,offset stokn2
	inc bx
	lea dx,change
	mov ah,09
	int 21h
	lea dx,mess3
	mov ah,09
	int 21h
	call both
	lea dx,mess5
	mov ah,09
	int 21h
	jmp a10

both proc near;转换函数
	mov ch,4
rotate: 
	mov cl,4
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
	ret
both endp
a50:;显示notmatch
	lea dx,change
	mov ah,09
	int 21h
	lea dx,mess4
	mov ah,09
	int 21h
	jmp a10

main endp
CODE ENDS
END START











