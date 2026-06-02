DATA SEGMENT
    A DW 0
    B DW 0
    C DW 2
    D DW 7
     
    DATA ENDS 
CODE SEGMENT 
 ASSUME DS:DATA , CS:CODE
 START:
 MOV AX , DATA 
 MOV DS , AX 
 PUSH D
 PUSH C 
 PUSH B
 PUSH OFFSET A 
 
 CALL P 
 MOV AH , 4CH
 INT 21H
 P PROC
    PUSH BP
    MOV BP , SP 
    MOV SI , [BP+4];DX NOW CONTAIN A BECAUSE ITS IN THE TOP OF THE STACK
    
    MOV BX , [BP+6];BX CONTAIN B
    MOV AX  , BX 
    
    MUL BX 
    MOV BX , AX  
    MOV [SI] , BX ; X=Y*Y
    MOV BX , [BP+6]
    ADD BX , [BP+8]
    MOV AX , 3
    MUL BX ;3(Y+Z)
    MOV BX , AX ; BX = 3(Y+Z) 
    MOV CX , [BP+10]
    SUB CX , 5
    MOV AX , BX 
    DIV CX ;3(Y+Z)/(V-5)
    MOV CX , AX 
    
    ADD [SI] , CX 
     
     
    POP BP 
        
    RET 8  
  P  ENDP 
    CODE ENDS

 END START