
DATA SEGMENT 
    LIST DW 20 DUP(?, 0FFFFh, 0FFFFh)   ; ? works in MASM if ? is alone in pattern
    
    DATA ENDS 
CODE SEGMENT
    ASSUME DS:DATA , CS:CODE 
     
START:
MOV AX , DATA
MOV DS , AX 
    CALL BUILD 
   
    
    CALL DBLIST 
      
     PUSH 5
    CALL DELETE 
    CALL TRAVERSE
    
    PUSH CX  
    CALL TRAVERSE_INV 
MOV AH , 4CH 
INT 21H
DELETE PROC
    PUSH BP 
    MOV BP , SP
    
    MOV DX , [BP+4] ; LOAD THE VALUE WE WANT TO DELETE WE PUSHED AS A PARAMETER
    MOV SI ,0 
    
    WHILEDE:   
    CMP LIST[SI] , DX
    JE FOUND
     
    CMP LIST[SI + 2] , 0FFFFH ;CHECK FOR THE END OF THE LIST 
    JE ENDINGDE
     
    MOV SI , LIST[SI+2] ;HEAD = HEAD -> NEXT  
      
    JMP WHILEDE
    FOUND: 
    
    MOV LIST[SI] , 0FFFFH;THE DELETED VALUE WILL BE FFFF
    
    MOV BP , LIST[SI+2];THE NEXT ELEMENT  
    MOV BX , LIST[SI+4];THE PREVIOUS ELEMENT
    
    MOV LIST[BP+4] , BX 
    MOV LIST[BX+2] , BP 
    
    MOV LIST[SI+2] , 0FFFFH;ELEMENT NEXT NOW IS NULL
    MOV LIST[SI+4] , 0FFFFH;ELMENT PREV IS NOW NULL  
    
    ENDINGDE:
       
    POP BP             
    RET 2          
    DELETE ENDP 
;ASSIGN A READ DIGIT AND THE VALUE OF THE NEXT NODE 
 
BUILD PROC
   MOV DX , 0 
   MOV SI , 0 
   WHILET:
   
    CMP DX , 19
    JE ENDINGT 
   
    CALL READ
    MOV AH , 0
    
    MOV LIST[SI] , AX ; ASSIGNE THE READ VALUE 
    
    LEA BX , LIST[SI+6]
       
    MOV LIST[SI+2] , BX ; ASSIGN THE ADDRESS OF THE NEXT ELEMENT 
    
    ADD SI , 6
     
    INC DX  
   JMP WHILET  
   ENDINGT:
     CALL READ
    MOV AH , 0
    
    MOV LIST[SI] , AX ; ASSIGNE THE READ VALUE 
    
   
       
    MOV LIST[SI+2] , 0FFFFH ; ASSIGN THE ADDRESS OF THE NEXT ELEMENT OF THE LAST ELEMENT NULL 
   RET  
   BUILD ENDP 

TRAVERSE PROC 
     
    MOV BP , OFFSET LIST
    WHILE:
    CMP BP , 0FFFFH 
    JE ENDING 
     
    MOV AX , [BP]
    MOV CX , BP ;RETURNING THE VALUE OF THE LAST NODE 
    
    MOV BP , [BP+2]
    
    
    JMP WHILE 
      
    ENDING:
     
    RET
     
    TRAVERSE ENDP
TRAVERSE_INV PROC     
    PUSH BP 
    MOV BP , SP
    MOV SI , [BP+4] ; THE ADDRESS OF THE LAST NODE 
    WHILEI: 
    CMP [SI+4] , 0FFFFH 
    JE ENDINGI 
    MOV AX , [SI] 
    MOV SI , [SI+4]
    JMP WHILEI 
    ENDINGI:
    MOV SI , [SI+4]
    MOV AX , [SI] 
    MOV CX , SI ;RETURNING THE VALUE OF THE FIRST NODE 
     
    POP BP 
    RET 2 
    TRAVERSE_INV ENDP 

DBLIST PROC
    MOV SI , 0
    MOV LIST[4]  , 0FFFFH
     
    WHILED:
    CMP LIST[SI+8] , 0FFFFH ;CHECK FOR ELEMENT->NEXT != NULL  
    JE ENDINGD                                               
    
    LEA BX , LIST[SI]
    MOV LIST[SI+10] , BX 
    ADD SI , 6  
    
    JMP WHILED
    
    ENDINGD:      
    MOV BP , OFFSET LIST 
    ADD BP , SI 
    
    MOV LIST[SI+10] , SI 
    
    RET
    DBLIST ENDP         

READ PROC
    MOV AH, 01h         
    INT 21h             
    SUB AL, '0'                     
    RET
READ ENDP

    CODE ENDS 
END START 