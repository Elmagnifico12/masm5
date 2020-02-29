;*************************************************************************
datasg  segment para    'data'
mess1   db      'Enter Keyword:','$'
mess2   db      0ah,'Enter Sentence:','$'
mess3   db      ' H of the sentence.',10,13,'$'
mess4   db      0ah,'No match.',10,13,'$'
mess5   db      0ah,'Matcn at location:','$'
;
keyword label   byte
  max1  db      10
  act1  db      ?
  stokn1 db     10 dup(?)
;
sentence label  byte
  max2  db      100
  act2  db      ?
  stokn2 db     100 dup(?)
datasg  ends
;****************************************************************************
codesg  segment para    'code'
        assume  cs:codesg,ds:datasg,es:datasg
;----------------------------------------------------------------------------
main    proc    far
        push    ds
        sub     ax,ax
        push    ax
        mov     ax,datasg
        mov     ds,ax
        mov     es,ax
start:
        lea     dx,mess1
        mov     ah,09
        int     21h
        lea     dx,keyword
        mov     ah,0ah
        int     21h
        cmp     act1,0
        je      start
restart:
        lea     dx,mess2
        mov     ah,09
        int     21h
        lea     dx,sentence
        mov     ah,0ah
        int     21h
        cmp     act2,0
        je      restart
        mov     al,act2
        sub     al,act1
        jb      nomatch
        inc     al
        lea     bx,stokn2
lp:
        lea     si,stokn1
        mov     di,bx
        mov     cl,act1
        mov     ch,0
        cld
        repz    cmpsb
        jz      match
        inc     bx
        dec     al
        jne     lp
nomatch:
        lea     dx,mess4
        mov     ah,09
        int     21h
        jmp     restart
match:
        lea     dx,mess5
        mov     ah,09
        int     21h
        lea     dx,stokn2
        sub     di,dx
        mov     dx,di
        sub     dl,act1
        inc     dl
        mov     cl,4
        ror     dx,cl
        cmp     dl,10
        jb      below
        add     dl,37h
        jmp     display
below:
        add     dl,30h
display:
        mov     ah,02
        int     21h
        rol     dx,cl
        and     dx,0fh
        cmp     dl,10
        jb      bel
        add     dl,37h
        jmp     disp
bel:
        add     dl,30h
disp:
        mov     ah,02
        int     21h
        lea     dx,mess3
        mov     ah,09
        int     21h
        jmp     restart
exit:
        ret
main    endp
;--------------------------------------------------------------------------
codesg  ends
;**************************************************************************
        end     main
