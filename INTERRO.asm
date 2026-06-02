DATA SEGMENT
     A DW 2
     B DW 4
     C DW 3 
     RES DW ? 
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE
START:
     MOV AX , DATA
     MOV DS , AX
     LEA BX  , A 
     PUSH C
     PUSH B
     PUSH BX 
     CALL MULTI 
     MOV AH , 4CH
     INT 21H
     
     PROC MULTI
        PUSH BP
        MOV BP , SP
        MOV BX , [BP+4]
        MOV CX , [BX]
        MOV AX , CX 
        MUL CX 
        ADD RES , AX 
        MOV AX , CX 
        MUL [BP+6]
        MOV CX , 2
        MUL CX
        ADD RES , AX
        MOV AX , [BP+6]
        MUL AX 
        ADD RES , AX 
        MOV AX , RES 
        DIV [BP+8]
        MOV RES , AX 
        
        RET
        MULTI ENDP 
CODE ENDS
END START