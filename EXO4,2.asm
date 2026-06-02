DATA SEGMENT 
    A DW 0
    B DW 2
    C DW 4
    D DW 6
    DATA ENDS 
CODE SEGMENT 
    ASSUME DS:DATA ,CS:CODE
    START: 
       MOV AX , DATA
       MOV DS , AX 
       CALL P 
       DW A 
       DW 2
       DW 4
       DW 6
       
       MOV AX, 'H'
       MOV AH , 4CH
       INT 21H
       
        PROC P
        POP SI
        
        
         
        MOV CX , CS:[SI+2]
        MOV AX , CX 
        IMUL CX 
        MOV CX , AX 
        MOV BP , [SI]
        
        ADD [BP] , CX ; X CONTAINES Y*Y
        MOV BX , CS:[SI+2]
        ADD BX , CS:[SI+4]
         
        MOV AX , 3
        IMUL BX 
        MOV BX , AX
        MOV AX , CS:[SI+6] 
        SUB AX , 5
        IMUL BX 
        ADD [BP] , AX
        ADD SI , 8
        PUSH SI
        RET
        P ENDP  
    CODE ENDS  

        
        
    END START  
