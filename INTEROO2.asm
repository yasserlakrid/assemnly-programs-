DATA SEGMENT
     TAB DW 10 DUP(1,2,3,4,5,6,7,8,9,10)
     MAX DW ? ,?
     MIN DW ?
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, CS:CODE
START:
     MOV AX , DATA
     MOV DS , AX
     MOV BP , 0
     WHILEI:;THE OUTER LOOP
       CMP BP , 100
       JE ENDING
       MOV SI, BP 
       CALL FINDMAX
       MOV DX , TAB[BP] 
       MOV AX , MAX
       MOV TAB[BP] , AX   
       MOV SI , MAX+2
       MOV TAB[SI] , DX
       ADD BP , 2  
       JMP WHILEI
       ENDING: 
       
     MOV AH , 4CH
     INT 21H   
     
     PROC FINDMAX
        
        MOV CX , TAB[SI]
        MOV MAX , CX
         
          WHILE:
          CMP SI , 100 
          JE ENDLOOP 
          MOV AX , MAX
          CMP AX , TAB[SI+2] 
          JGE NEXT
          MOV CX , TAB[SI+2] 
          
          MOV MAX , CX 
          MOV AX , SI
          ADD AX , 2
          MOV [MAX+2] , AX
          
          NEXT: 
          ADD SI , 2
          JMP WHILE 
          ENDLOOP:
        RET
        FINDMAX ENDP 
     
     PROC FINDMIN
        MOV SI,0
        MOV CX , TAB[SI]
        MOV MIN , CX
         
          WHILE2:
          CMP SI , 100 
          JE ENDLOOP2 
          MOV AX , MIN
          CMP AX , TAB[SI+2]
          JLE NEXT2
          MOV CX , TAB[SI+2]
          MOV MIN , CX
          NEXT2: 
          ADD SI , 2
          JMP WHILE2 
          ENDLOOP2:
        RET
        FINDMIN ENDP
CODE ENDS
END START