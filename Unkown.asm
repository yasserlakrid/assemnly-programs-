DATA SEGMENT           
    
     ZONE DB 255,255,255,255,255
     BITS DB 0
     MAX DW 0 
          
    DATA ENDS 
CODE SEGMENT
    ASSUME DS:DATA , CS:CODE 
    START:
        MOV AX , DATA
        MOV DS , AX  
        MOV AL , ZONE
        
        
         
        CALL P 
        
        MOV AL , 4CH
        INT 21H
        
    PROC P 
        PUSH BP 
        MOV BP , SP
        
        MOV SI , 0 
        
        WHILE:
            CMP SI , 5
            JE END 
            MOV CL , ZONE[SI]
            INC SI 
            MOV BITS , 0
            
             
            BITSWHL: 
                CMP BITS , 8  ;CHECK IF WE EXCEED THE REGISTER 
                JE WHILE
                
                INC BITS
                
                ROL CL , 1
             
  
                JNC ZERO
                
                INC BX ;CALCULATE THE ONES 
                 
                 
                            
                JMP BITSWHL
                
                ZERO: 
                
                CMP BX , MAX  ;COMPARE WITH THE OLD VALUE OF BX
                 
                JGE CHANGEMAX
                MOV BX , 0
                 
                JMP BITSWHL
                
                CHANGEMAX:
                MOV MAX , BX 
                MOV BX , 0 
                JMP BITSWHL  
                
        END:
        POP BX 
        MOV MAX , BX         
        POP BP 
        RET 
    P ENDP 
       
    CODE ENDS 
END START