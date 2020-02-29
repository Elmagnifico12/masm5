data segment
display equ 02h
key_in equ 01h
doscall equ 21h
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
;main part goes here
;十进制到十六进制转换
		; call decibin
		; call crlf
		; call binihex
		; call crlf


		call hexibin
		call crlf
		call binidec
		call crlf



finish:
		ret
main endp
; decibin proc near
; 		mov bx,0
; newchar:
; 		mov ah,01h
; 		int 21h
; 		sub al,30h
; 		jl exit
; 		cmp al,9d
; 		jg exit
; 		cbw

; 		xchg ax,bx
; 		mov cx,10d
; 		mul cx
; 		xchg ax,bx

; 		add bx,ax
; 		jmp newchar
; exit:
; 		ret
; decibin endp

; binihex proc near
; 		mov ch,4
; rotate:
; 		mov cl,4
; 		rol bx,cl
; 		mov al,bl
; 		and al,0fh
; 		add al,30h
; 		cmp al,3ah
; 		jl printit
; 		add al,7h
; printit:
; 		mov dl,al
; 		mov ah,2
; 		int 21h
; 		dec ch
; 		jnz rotate
; 		ret
; binihex endp
crlf proc near
		mov dl,0dh
		mov ah,2
		int 21h
		mov dl,0ah
		mov ah,2
		int 21h
		ret
crlf endp

hexibin proc near
		mov bx,0
newchar:
		mov ah,key_in
		int doscall
		sub al,30h
		jl exit
		cmp al,10d
		jl add_to
		sub al,27h
		cmp al,0ah
		jl exit
		cmp al,10h
		jge exit
add_to:
		mov cl,4
		shl bx,cl
		mov ah,0
		add bx,ax
		jmp newchar
exit:
		ret
hexibin endp
binidec proc near
		mov cx,10000d
		call dec_div
		mov cx,1000d
		call dec_div
		mov cx,100d 
		call dec_div
		mov cx,10d 
		call dec_div
		mov cx,1d 
		call dec_div
		ret

dec_div proc near
		mov ax,bx
		mov dx,0
		div cx
		mov bx,dx
		mov dl,al
		add dl,30h
		mov ah,display
		int doscall
		ret

dec_div endp
binidec endp
code ends
end start