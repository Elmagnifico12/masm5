data segment

sentence label byte
	sentencemax db 100
	sentencelen db ?
	sentence_string db 100 dup(?)

inword label byte
	inwordmax db 50
	wordlen db ?
	word_string db 100 dup(?)


mess1 db 'please input the string: ','$'
mess2 db 0ah,'please input the word: ','$'
mess3   db      ' H of the sentence.',10,13,'$'
mess4   db      0ah,'No match.',10,13,'$'
mess5   db      0ah,'Match at location:','$'

change_line db 13,10,'$'
space db 20h.'$'

data ends

code segment

main proc far
	assume cs:code,ds:data,es:data
start:
;initial
		push ds
		sub ax,ax
		push ax
		mov ax,data
		mov ds,ax
		mov es,ax

		sub di,di
		sub si,si
;main part goes here
		lea dx,mess1
		mov ah,09
		int 21h
		mov ah,0ah
		lea dx,sentence
		int 21h

begin:
		lea dx,mess2
		mov ah,09
		int 21h
		mov ah,0ah
		lea dx,inword
		int 21h
        cmp wordlen,0
        je finish


		
		mov ax,offset sentence_string
		sub bx,bx
		mov bl,sentencelen
		sub bl,wordlen
		inc bl
loop1:
		mov si,ax
		lea di,word_string
		sub cx,cx
		mov cl,wordlen
		cld
		repz cmpsb
		jz match
		inc ax
		dec bl
		cmp bl,0
		jne loop1
nomatch:
		lea dx,mess4
		mov ah,09
		int 21h
		jmp begin
match:
		lea dx,mess5
		mov ah,09
		int 21h
		
                mov bx,si
		sub bx,offset sentence_string
		sub bl,wordlen
		call change
                lea dx,mess3
                mov ah,09
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

changeline proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        
        lea dx,change_line
        mov ah,09h
        int 21h

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
changeline endp
printspace proc near
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        lea dx,space
        mov ah,09h
        int 21h

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
printspace endp
code ends
end start
