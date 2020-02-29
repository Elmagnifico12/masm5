data segment
	mess1 db 10,13,'please input a score: ','$'

score label byte
	smax db 100
	slen db ?
	string db 100 dup('$')

change_line db 13,10,'$'
wrong_message db 'x',20h,'$'
space db 20h,'$'
a db 20h,'A',20h,'$'
b db 20h,'B',20h,'$'
c db 20h,'C',20h,'$'
f db 20h,'D',20h,'$'
data ends

code segment

main proc far
	assume cs:code,ds:data,es:data
start:
		push ds
		sub ax,ax
		push ax
		mov ax,data
		mov ds,ax
		mov es,ax
		sub si,si
		sub di,di

;main part goes here
begin:
		mov ah,09h
		lea dx,mess1
		int 21h

		mov ah,0ah
		lea dx,score
		int 21h

		mov ah,09h
		lea dx,change_line
		int 21h

		cmp slen,0
		je finish
		cmp slen,2
		jl wrong
		cmp slen,2
		ja wrong
		mov bx,10
		mov al,string[0]
		sub al,30h
		mul bx
		add al,string[1]
		sub al,30h
		cmp al,90
		ja sca
		cmp al,80
		ja scb
		cmp al,70
		ja scc
		cmp al,60
		ja scd
wrong:
		mov ah,09h
		lea dx,wrong_message
		int 21h
		jmp begin
sca:
		mov ah,09h
		lea dx,a
		int 21h
		jmp begin
scb:
		mov ah,09h
		lea dx,b
		int 21h
		jmp begin
scc:
		mov ah,09h
		lea dx,c
		int 21h
		jmp begin
scd:
		mov ah,09h
		lea dx,f
		int 21h
		jmp begin
finish:
		ret
		




main endp
change proc near

        push ax
        push bx
        push cx
        push dx
        push si
        push di

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

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
change endp
code ends
end start

