datarea segment
 
 userinput label byte
 smax db 80
 slen db ?
 string db 80 dup('$')

 realen dw ?
 array db 80(' ')

 mess1 db 'please input number string: ','$'
 change_line db 13,10,'$'
 space db 20h,'$'
datarea ends


prognam segment
main proc far
        assume cs:prognam,ds:datarea,es:datarea
start:
;initialize
        push ds
        sub ax,ax
        push ax
        mov ax,datarea
        mov ds,ax
        mov es,ax
 ;main part goes here
        lea dx,mess1
        mov ah,09h
        int 21h
        sub si,si
input:
        lea dx,userinput
        mov ah,0ah
        int 21h
        
       call changeline

        ;check
        mov ah,09h
        lea dx,string
        int 21h

        call changeline

        sub si,si
        sub di,di
        sub cx,cx
        mov cl,slen
        push ax
transfer:
        cmp string[si],20h
        je isspace
        mov al,string[si]
        mov array[di],al
        inc di
isspace:
        inc si
        loop transfer

        pop ax
        sub si,si
        mov realen,di
output:
        sub bx,bx
        mov bl,array[si]
        call change
        call printspace
        inc si
        cmp si,di
        jl output

        call changeline
        sub bx,bx
        mov bx,realen
        call change
finish:
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
changeline proc near
        push ax
        push bx
        push cx
        push dx
        
        lea dx,change_line
        mov ah,09h
        int 21h

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

        lea dx,space
        mov ah,09h
        int 21h

        pop dx
        pop cx
        pop bx
        pop ax
        ret
printspace endp
prognam ends
end start





