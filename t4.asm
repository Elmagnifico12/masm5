;----------------------------------------------------------------------------
DATAREA SEGMENT
        MSG1    DB      'INPUT NAME:','$'
        MSG2    DB      'INPUT A TELEPHONE NUMBER:','$'
        MSG3    DB      'DO YOU WANT A TELEPHONE NUMBER?(Y/N)','$'
        MSG4    DB      'NAME?','$'
        MSG5    DB      'NAME                TEL.',0AH,0DH,'$'
        ;
        INWORD  LABEL   BYTE
         INMAX  DB      32
         INLEN  DB      ?
         INWD   DB      32 DUP(?)
        ;
        COUNT   DB      0               ;ITEM NUM OF TEL-TAB
        AITEM   DB       30              ;ONE ITEM LEN
        TEL_TAB DB      1500 DUP('$')
        TEMP    DB      30 DUP(?)
DATAREA ENDS
;----------------------------------------------------------------------------
PROGNAM SEGMENT
;----------------------------------------------------------------------------
MAIN PROC FAR
        ASSUME CS:PROGNAM,DS:DATAREA,ES:DATAREA
START:
        PUSH    DS
        SUB     AX,AX
        PUSH    AX
        MOV     AX,DATAREA
        MOV     DS,AX
        MOV     ES,AX   ;IMPORTANT!!!FOR USING 'MOVSB' 
INPUT1:
        LEA     DX,MSG1
        MOV     AH,09H
        INT     21H     ;OUPUT 'INPUT NAME:'
        CALL    INPUT_NAME
        CMP     INLEN,0
        JZ      SORT
        CALL    STOR_NAME
        LEA     DX,MSG2
        MOV     AH,09H
        INT     21H     ;OUTPUT 'INPUT A TELEPHONE NUMBER:'
        CALL    INPHONE
        JMP     INPUT1
SORT:
        CALL    NAME_SORT
INPUT2:
        LEA     DX,MSG3
        MOV     AH,09H
        INT     21H     ;OUTPUT 'DO YOU WANT A ...'
        MOV     AH,01H
        INT     21H     ;INPUT Y OR N
        CMP     AL,'N'
        JZ      EXIT
        CMP     AL,'Y'
        JNZ     INPUT2
        MOV     DL,0AH
        MOV     AH,02H
        INT     21H
        MOV     DL,0DH
        MOV     AH,02H
        INT     21H
        LEA     DX,MSG4
        MOV     AH,09H
        INT     21H     ;OUTPUT 'NAME?'
        MOV     DL,0AH
        MOV     AH,02H
        INT     21H
        MOV     DL,0DH
        MOV     AH,02H
        INT     21H
        CALL    INPUT_NAME
        CALL    NAME_SEARCH
        CMP     AX,0 
        JZ      INPUT2  ;SEARCH NOT SUCCESS
        CALL    PRINTLINE
        JMP     INPUT2
EXIT:
        RET
MAIN ENDP
;----------------------------------------------------------------------------
INPUT_NAME PROC NEAR
        LEA     DX,INWORD
        MOV     AH,0AH
        INT     21H
        MOV     DL,0AH
        MOV     AH,02H
        INT     21H
        MOV     DL,0DH
        MOV     AH,02H
        INT     21H     ;\N
        RET
INPUT_NAME ENDP
;----------------------------------------------------------------------------
STOR_NAME PROC NEAR
        LEA     SI,INWD
        LEA     DI,TEL_TAB
        SUB     AX,AX
        MOV     AL,COUNT
        MUL     AITEM
        ADD     DI,AX
        SUB     CX,CX
        MOV     CL,INLEN
        CLD
        REP     MOVSB
        RET
STOR_NAME ENDP
;----------------------------------------------------------------------------
NAME_SEARCH PROC NEAR
        SUB     CX,CX
        MOV     CL,COUNT
SEARCHLOOP:
        LEA     SI,INWD
        LEA     DI,TEL_TAB
        SUB     AX,AX
        MOV     AL,CL
        DEC     AL
        MUL     AITEM
        ADD     DI,AX   ;CMP POSITION
        PUSH    CX
        MOV     CX,20
        CLD
        REPZ    CMPSB
        JZ      MATCHED
        INC     CX
        MOV     AX,20
        SUB     AX,CX
        CMP     AL,INLEN
        JZ      MATCHED
NEXTONE:
        POP     CX
        LOOP    SEARCHLOOP
        JNZ     UNMATCH
MATCHED:
        MOV     AX,DI
        SUB     AL,INLEN
        DEC     AL
        POP     CX
        JMP     SEARCHEXIT
UNMATCH:
        MOV     AX,0
SEARCHEXIT:
        RET
NAME_SEARCH ENDP
;----------------------------------------------------------------------------
PRINTLINE PROC NEAR
		MOV     BX,AX
        LEA     DX,MSG5
        MOV     AH,09H
        INT     21H
        MOV     DX,BX
        MOV     AH,09H
        INT     21H     ;OUTPUT NAME
        MOV     CX,21
        SUB     CL,INLEN
SPACELOOP:              ;OUTPUT SPACE
        MOV     DL,' '
        MOV     AH,02H
        INT     21H
        LOOP    SPACELOOP
        ADD     BX,19
        MOV     DX,BX
        MOV     AH,09H
        INT     21H     ;OUTPUT PHONE NUMBER
        MOV     DL,0AH
        MOV     AH,02H
        INT     21H
        MOV     DL,0DH
        MOV     AH,02H
        INT     21H     ;\N
        RET
PRINTLINE ENDP
;----------------------------------------------------------------------------
INPHONE PROC NEAR
        LEA     DX,TEL_TAB
        SUB     AX,AX
        MOV     AL,COUNT
        MUL     AITEM
        ADD     DX,AX
        ADD     DX,18
        MOV     AH,0AH
        INT     21H
        INC     COUNT   ;ITEM NUM OF TEL-TAB INC
        MOV     DL,0AH
        MOV     AH,02H
        INT     21H
        MOV     DL,0DH
        MOV     AH,02H
        INT     21H;    ;\N
        RET
INPHONE ENDP
;----------------------------------------------------------------------------
NAME_SORT PROC NEAR
        SUB     CX,CX
        MOV     CL,COUNT
        DEC     CX
LOOP1:
        PUSH    CX
        SUB     BX,BX
        MOV     BL,COUNT
        SUB     BX,CX
        DEC     BX
LOOP2:
        PUSH    CX
        PUSH    BX
        ADD     BX,CX
        LEA     DI,TEL_TAB
        LEA     SI,TEL_TAB
        MOV     AX,BX
        MUL     AITEM
        ADD     DI,AX
        MOV     AX,BX
        JMP     STEP2
STEP1:
        JMP     LOOP1
STEP2:
        DEC     AX
        MUL     AITEM
        ADD     SI,AX
        MOV     CX,30
        CLD
        REPZ    CMPSB
        DEC     DI
        DEC     SI
        MOV     AH,[DI]
        MOV     AL,[SI]
        CMP     AH,AL
        JNL     NEXT
        JMP     STEP4
STEP3:
        JMP     LOOP2
STEP4:
        LEA     DI,TEMP
        LEA     SI,TEL_TAB
        MOV     AX,BX
        MUL     AITEM
        ADD     SI,AX
        MOV     CX,30
        CLD
        REP     MOVSB

        LEA     DI,TEL_TAB
        LEA     SI,TEL_TAB
        MOV     AX,BX
        MUL     AITEM
        ADD     DI,AX
        MOV     AX,BX
        DEC     AX
        MUL     AITEM
        ADD     SI,AX
        MOV     CX,30
        CLD
        REP     MOVSB

        LEA     SI,TEMP
        LEA     DI,TEL_TAB
        MOV     AX,BX
        DEC     AX
        MUL     AITEM
        ADD     DI,AX
        MOV     CX,30
        CLD
        REP     MOVSB

NEXT:
        POP     BX
        POP     CX
        LOOP    STEP3   ;TOO FAR
        POP     CX
        LOOP    STEP1   ;LOOP1 IS TOO FAR TO JUMP.
        RET
NAME_SORT ENDP
;----------------------------------------------------------------------------
PROGNAM ENDS
        END START