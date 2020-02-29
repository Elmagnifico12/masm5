DATAREA SEGMENT
MIN     DW      0
MAX     DW      0
DATAREA ENDS
PROGNAM SEGMENT
ASSUME  CS:PROGNAM,DS:DATAREA
MAIN    PROC    FAR
START:
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
        MOV     AX,DATAREA
        MOV     DS,AX
        LEA     BX,MIN
INPUT:
        MOV     AH,01H
        INT     21H
        SUB     AL,30H
        MOV     CL,10
        MUL     CL
        MOV     [BX],AX
      
        MOV     AH,01H
        INT     21H
        SUB     AL,30H
        SUB     AH,AH
        ADD     [BX],AX
        MOV     DL,' '
        MOV     AH,02H
        INT     21H
        CMP     BX,OFFSET MAX
        JZ      SEARCH
        LEA     BX,MAX
        JMP INPUT
SEARCH:
        MOV     CX,MAX
        SUB     CX,MIN
        INC     CX
        MOV     BX,MIN
        DEC     BX
LOOP1:
        INC     BX
        PUSH    CX
        MOV     CX,BX
LOOP2:
        MOV     AX,BX
        MOV     DL,CL
        DIV     DL
        CMP     AH,0
        JNZ     NEXT
        CMP     CX,1
        JZ      NEXT
        CMP     CX,BX
        JZ      NEXT
        POP     CX
        LOOP    LOOP1
        JMP     EXIT
NEXT:
        LOOP    LOOP2
OUTPUT:
        MOV     AX,BX
        MOV     DL,10
        DIV     DL
        ADD     AH,30H
        MOV     DH,AH
        ADD     AL,30H
        MOV     DL,AL
        MOV     AH,02H
        INT     21H
        MOV     DL,DH
        MOV     AH,02H
        INT     21H
        MOV     DL,' '
        MOV     AH,02H
        INT     21H

        POP     CX
        LOOP    LOOP1
EXIT:
        RET
MAIN    ENDP
PROGNAM ENDS
END     START