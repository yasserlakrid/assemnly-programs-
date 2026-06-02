DATA SEGMENT 
    VECT DW -5,-6,6,-4,-10
    COUNT DW 0 
    DATA ENDS 
CODE SEGMENT 
    ASSUME DS:DATA , CS:CODE
    START:
    MOV AX , DATA
    MOV DS , AX
    CALL COUNTING 
    
    MOV AH , 4CH
    INT 21H 
    COUNTING PROC
        LEA SI , VECT 
        MOV BX , 0 
        
        WHILE: 
        MOV BX , SI 
        SUB BX , OFFSET VECT 
        CMP BX , 10 
        
        JE ENDING 
        MOV AX , [SI]
        CMP AX , 0 
        JG POS 
        INC COUNT
        POS:      
        ADD SI , 2  
        JMP WHILE
        ENDING:   
        RET 
    COUNTING ENDP  
    
     
    CODE ENDS
END START