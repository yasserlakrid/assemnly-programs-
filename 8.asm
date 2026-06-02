DATA SEGMENT
     ZONE DB 1021 DUP(11110001B,11111000B) 
     MAX1 DB 0
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE
START:
     MOV AX , DATA
     MOV DS , AX 
     MOV SI , 0 
     MOV CX,0
     WHILE:
        CMP SI , 1024
        JE EXITLOOP
        MOV AL , ZONE[SI]
        INC SI 
        CALL SHIFT 
        CMP CH , 0
        JE NEWREC
        JMP WHILE 
        
            NEWREC:
                CMP CL , MAX1 
                JG SETNEWMAX 
                MOV CL , 0 
                JMP WHILE
                    SETNEWMAX:
                    MOV MAX1 , CL
                    MOV CL , 0 
                    JMP WHILE
     EXITLOOP:
     MOV AL , 4CH 
     INT 21H
     
     PROC SHIFT
        BT:
            CMP AL , 0 
            JE ZERO ; THAT MEANS THE LAST BIT IS A ZERO 
            CMP AL , 1
            JE NONZERO ; THAT MEANS THE LAST BIT IS A ONE  
            SHL AL,1 
            JNC BT
            MOV CH , 1  
            INC CL ;COUNTER FOR ONES 
            JMP BT 
          ZERO: 
            MOV CH , 0
            JMP EXITP 
          NONZERO: 
            MOV CH , 1
            INC CL 
          EXITP: 
           
        RET 
        SHIFT ENDP       
CODE ENDS
END START