DATA SEGMENT
    BIT DW 16 DUP(1010001010100010B)
    VAL DW 16 DUP(12,21,124,4,0,12,1,9)
    SUM0 DD ?
    SUM1 DD ?
     
    DATA ENDS 
CODE SEGMENT
    ASSUME DS:DATA , CS:CODE 
    START:  
    MOV AX , DATA 
    MOV DS , AX 
    
    MOV SI,0
    MOV DI , 0 
    WHILE1:
    CMP SI , 16 
    JE ENDING 
    MOV AX , BIT[SI]
   
    MOV CX , 16 ;TO PROCESS EACH 16 BITS 
    
        WHILE2:   
        
        
        SHL AX ,1
        JC ONE 
        MOV BX , SUM0
        ADD BX , VAL[DI]
        MOV  SUM0 , BX
        JMP NEXT
        
        ONE:
        MOV BX , SUM0
        ADD BX , VAL[DI]
        ADD SUM1 , BX 
        
        NEXT:
        
        ADD DI , 2
        LOOP WHILE2  
        
    ADD SI , 2 
    JMP WHILE1
    
    ENDING:
    
    MOV AH ,  4CH
    INT 21H 
    
    CODE ENDS
    END START 