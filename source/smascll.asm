code segment
assume cs:code

start:


mov dx,0010h

next:
mov cx,10h

loop1:
mov ah,02h
int 21h
inc dx
push dx
mov dl,0;打印空格
int 21h
pop dx
loop loop1

push dx
mov dl,0ah
int 21h
mov dl,0dh
int 21h
pop dx
cmp dx,100h
jb next
mov ah,4ch
int 21h
code ends
end start

