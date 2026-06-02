                                                                                ; multi-segment executable file template.
.MODEL SMALL
data segment
    ; add your data here!


; ===== Buffers DOS =====
msg DB 101, ?, 101 DUP('$')
key DB 11, ?, 11 DUP('$')

buffer DB 100 DUP('$')

fileName DB 'ENCOD.TXT',0
handle DW ?

; ===== Messages =====
menu DB 0DH,0AH,0DH,0AH,'Please Make your choice :',0DH,0AH,'1- Encrypt',0DH,0AH,'2- Decrypt',0DH,0AH,'3- Exit',0DH,0AH,'Choice: $'
msg_in DB 0DH,0AH,'Enter message: $'
key_in DB 0DH,0AH,'Enter 10-char key: $' 
err_key DB 0DH,0AH,'Key must be exactly 10 characters! Try again.$'

enc_out DB 0DH,0AH,'Encrypted message: $'
hex_msg DB 0DH,0AH,'Encrypted message (HEX): $'

file_msg DB 0DH,0AH,'Encrypted file content: $'
dec_out DB 0DH,0AH,'Decrypted message: $'

err DB 0DH,0AH,'File not found!$'
               
.CODE

; -----------------------
PRINT_STR PROC
    MOV AH,09H
    INT 21H
    RET
PRINT_STR ENDP

; -----------------------
READ_MSG PROC
    MOV AH,0AH
    LEA DX,msg
    INT 21H
    RET
READ_MSG ENDP

READ_KEY PROC
     
READ_AGAIN:

   
    LEA DX,key_in
    MOV AH,09H
    INT 21H

    
    MOV AH,0AH
    LEA DX,key
    INT 21H

    
    MOV AL,key+1     
    CMP AL,10
    JE VALID

    
    MOV AH,09H
    LEA DX,err_key
    INT 21H

    JMP READ_AGAIN

VALID:
    RET
READ_KEY ENDP

; -----------------------
COPY_MSG PROC
    LEA SI,msg+2
    LEA DI,buffer
    MOV CL,msg+1
    MOV CH,0

L1:
    CMP CX,0
    JE DONE
    MOV AL,[SI]
    MOV [DI],AL
    INC SI
    INC DI
    DEC CX
    JMP L1

DONE:
    MOV BYTE PTR [DI],'$'
    RET        
               
COPY_MSG ENDP 

 ;THE SHIFT OPERATION OPERATION 
 
SHIFT  PROC     
    
    LEA DI,buffer
    MOV CL,msg+1
    MOV CH,0

MYLOOP:
    CMP CX,0
    JE DONE1
    MOV AL,[DI]
    ADD AL , 5
    MOV [DI],AL ;NOW EACH CHARACTER IN BUFFER IS ADDED BY 5
   
    INC DI
    DEC CX
    JMP MYLOOP

DONE1:
    MOV BYTE PTR [DI],'$'
    RET
      
           
SHIFT ENDP


XOR_PROC PROC ;THE XOR PROC DO THE XOR OPERATION BETWEEN TWO CHARACTERS
             MOV DX , BP
             ADD DX , SI 
              
             MOV CL ,  BUFFER  ; GOT THE CHAR FROM THE BUFFER BP IS ADDED BY 10 TO EACH BLOCK 
             ADD CL , DL 
             MOV CH ,  KEY
             SUB DX , BP       ;GOT THE CHAR FROM THE KEY SI IS BETWEEN 0 AND 10 
             ADD CH , DL 
             
             MOV AX , 0 
             EACHCHAR: 
               CMP AX , 8 ;ITERATE EACH BIT OF THE CHARACTER 
               JG ENDING  
               
               INC AX 
               
               SHL BL ,1  ; SHIFT BX SO OTHER BITS CAN ACCUMULATE 
               
               SHL CH ,1
               
               JNC ONEZERO ;CHECK IF THE TWO BITS ARE ZEROS OR ARE ONE 
               
               SHL CL ,1
                
               JC TWOZERO
               SHL BL ,1 
               
               ONEZERO:
               SHL CL ,1 
               JNC TWOZERO
               
               SHL BL , 1  
               JMP EACHCHAR 
               
               TWOZERO:
               ADD BL , 1
               
               
               
             JMP EACHCHAR  
             ENDING:
             MOV DX , BP
             ADD DX , SI 
             MOV BP , DX 
             
             MOV BUFFER[BP] , BL ;BX CONTAIN THE MODIFIED CHARACTER  
             ret  
XOR_PROC ENDP
CAESAR PROC
    
    MOV CL,msg+1  ; CL CONTAIN THE LENGTH OF THE BUFFER 
    
    MOV CH,0 
    
    MOV SI , 0
    MOV BP , 0
    
MYLOOP2:
    CMP CX,0
    JE DONE2
    
    CALL XOR_PROC 
    INC SI 
    
    CMP SI , 10 ; CHECK IF WE EXECEED THE KEY OR NOT 
    JE NEWBLOC
     
    DEC CX  
    JMP MYLOOP2 
    
    NEWBLOC:
    ADD BP , 10
    MOV SI , 0 
    DEC CX 
    MOV AX , CX 
    SUB AX , BP
     
    CMP AX , 10
    JGE NEXT
    MOV CX , AX ;CX CONTAIN NOW N ELEMENT REST LESS THAN 10
     
    NEXT: 
    JMP MYLOOP2 
     
    

DONE2:
    MOV BYTE PTR [DI],'$'
    RET
      
CAESAR ENDP  

SHIFT_DEC PROC
    LEA DI,buffer
    MOV CL,msg+1
    MOV CH,0

MYLOOP3:
    CMP CX,0
    JE DONE3
    MOV AL,[DI]
    SUB AL , 5
    MOV [DI],AL ;NOW EACH CHARACTER IN BUFFER IS REMOVED BY 5
   
    INC DI
    DEC CX
    JMP MYLOOP3

DONE3:
    MOV BYTE PTR [DI],'$'
    RET
SHIFT_DEC ENDP  

; -----------------------
;WRITE FILE
; -----------------------
WRITE_FILE PROC
    MOV AH,3CH
    MOV CX,0
    LEA DX,fileName
    INT 21H
    MOV handle,AX

    MOV AH,40H
    MOV BX,handle
    LEA DX,buffer
    MOV CX,100
    INT 21H

    MOV AH,3EH
    MOV BX,handle
    INT 21H
    RET
WRITE_FILE ENDP

; -----------------------
;READ FILE
; -----------------------
READ_FILE PROC
    MOV AH,3DH
    MOV AL,0
    LEA DX,fileName
    INT 21H
    JC FILE_ERROR
    MOV handle,AX

    MOV AH,3FH
    MOV BX,handle
    LEA DX,buffer
    MOV CX,100
    INT 21H

    MOV AH,3EH
    MOV BX,handle
    INT 21H
    CLC
    RET

FILE_ERROR:
    STC
    RET
READ_FILE ENDP

; -----------------------
;PRINT BUFFER (STRING)
; -----------------------
PRINT_BUFFER PROC
    LEA DX,buffer
    CALL PRINT_STR
    RET
PRINT_BUFFER ENDP

; =========================
; HEX DISPLAY
; =========================

PRINT_HEX_BYTE PROC
    PUSH AX
    PUSH BX

    MOV BL,AL

    ; HIGH nibble
    MOV AL,BL
    SHR AL,4
    CALL HEX_DIGIT

    ; LOW nibble
    MOV AL,BL
    AND AL,0FH
    CALL HEX_DIGIT

    MOV DL,' '
    MOV AH,02H
    INT 21H

    POP BX
    POP AX
    RET
PRINT_HEX_BYTE ENDP

HEX_DIGIT PROC
    CMP AL,9
    JBE DIGIT
    ADD AL,7
DIGIT:
    ADD AL,'0'
    MOV DL,AL
    MOV AH,02H
    INT 21H
    RET
HEX_DIGIT ENDP

PRINT_BUFFER_HEX PROC
    LEA SI,buffer

H1:
    MOV AL,[SI]
    CMP AL,'$'
    JE END_H

    CALL PRINT_HEX_BYTE
    INC SI
    JMP H1

END_H:
    RET
PRINT_BUFFER_HEX ENDP

; =========================
; MAIN
; =========================
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; MENU 
    
MainPage:
    LEA DX,menu
    CALL PRINT_STR

    MOV AH,01H
    INT 21H

    CMP AL,'1'
    JE ENCRYPT

    CMP AL,'2'
    JE DECRYPT  
    
    CMP AL,'3'
    JE EXIT

    JMP MainPage

; -------------------------
ENCRYPT:
    LEA DX,msg_in
    CALL PRINT_STR
    CALL READ_MSG


    CALL READ_KEY

    CALL COPY_MSG
    CALL SHIFT   ;THIS FUNCTION ADD 5 TO EACH CHARACTER 
    CALL CAESAR ; THIS PROCEDURE XORED EACH CHARACTER
     
    ; affichage normal
    LEA DX,enc_out
    CALL PRINT_STR
    CALL PRINT_BUFFER

    ; affichage HEX
    LEA DX,hex_msg
    CALL PRINT_STR
    CALL PRINT_BUFFER_HEX

    CALL WRITE_FILE                                                                                    
    JMP MainPage

; -------------------------
DECRYPT:

    CALL READ_KEY

    CALL READ_FILE
    JC NO_FILE

    LEA DX,file_msg
    CALL PRINT_STR
    CALL PRINT_BUFFER 
    ;CALL CAESAR ; USE THE XOR AGAIN  
    CALL SHIFT_DEC ; REMOVE 5 FROM EACH CHAR  

    LEA DX,dec_out
    CALL PRINT_STR
    CALL PRINT_BUFFER

    JMP MainPage

NO_FILE:
    LEA DX,err
    CALL PRINT_STR  
    JMP  MainPage

EXIT:
    MOV AH,4CH
    INT 21H

MAIN ENDP
END MAIN