DATAREA SEGMENT
        LETTER  DB      0
        DIGIT   DB      0
        OTHER   DB      0
DATAREA ENDS
;----------------------------------------------------------------------------
PROGNAM SEGMENT
MAIN    PROC    FAR
        ASSUME  CS:PROGNAM,DS:DATAREA,ES:DATAREA
START:
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
        MOV     AX,DATAREA
        MOV     DS,AX
        MOV     ES,AX
COUNT:
        MOV     AH,01H
        INT     21H
        CMP     AL,0DH
        JZ      EXIT
        CMP     AL,30H
        JB      OTHERS
        CMP     AL,39H
        JA      NODIGIT
        INC     DIGIT
        JMP     COUNT
NODIGIT:
        CMP     AL,41H
        JB      OTHERS
        CMP     AL,5CH
        JA      NOCAPITAL
        INC     LETTER
        JMP     COUNT
NOCAPITAL:
        CMP     AL,60H
        JB      OTHERS
        CMP     AL,7CH
        JA      OTHERS
        INC     LETTER
        JMP     COUNT
OTHERS:
        INC     OTHER
        JMP     COUNT
EXIT:
        RET
MAIN    ENDP
PROGNAM ENDS
        END     START
