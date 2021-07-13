;-------------------------------------------------------------
;             SIMULATION OF 'COPY' COMMAND USING PSP
;             
;-------------------------------------------------------------
     DATA SEGMENT
             HANDLE1        DW 0
             HANDLE2        DW 0
             BUFF           DB 0
             SOURCE         DB 20 DUP(0)
             DESTI          DB 20 DUP(0) 
             MESS1          DB 10,13, "Required parameter missing  $"
             MESS2          DB 10,13, "one file copied $"
      CLRSCR MACRO
             MOV AX,0600H
             MOV BH,14
             MOV CX,0000H
             MOV DX,184FH
             INT 10H
             ENDM
      DISP MACRO MESS
             MOV AH,09H
             LEA DX,MESS
             INT 21H
            ENDM
     DATA ENDS

     CODE SEGMENT
       START:ASSUME CS:CODE,DS:DATA
             MOV AX,DATA
             MOV DS,AX

             MOV AH,51H
             INT 21H                      ;GET ADDRESS OF PSP IN BX
             MOV ES,BX                    ;INITIALIZE EXTRA SEGMENT

             MOV SI,82H
             MOV DI,00H
             MOV BL,ES : BYTE PTR[80H]
             CMP BL,00
             JNE VALID
             DISP MESS1                   ;DISP MESSAGE1
             JMP QUIT
      VALID:
         L1: MOV BL,ES:BYTE PTR[SI]
             MOV SOURCE[DI],BL
             CMP BL,20H
             JE GETDES
             INC SI
             INC DI
             JMP L1
     GETDES:
             MOV SOURCE[DI],00H             ;MAKE STRING ASCIIZ
             INC SI
             MOV DI,0000H
          L2:MOV BL,ES:BYTE PTR[SI]
             MOV DESTI[DI],BL
             CMP BL,0DH
             JE NEXT
             INC SI
             INC DI
             JMP L2
      NEXT:
             MOV DESTI[DI],00H             ;MAKE STRING ASCIIZ

             MOV AH,3DH                     ;
             MOV AL,00H                     ;*ACCESS CODE READ ONLY
             MOV CX,0000H                   ; NORMAL MODE
             LEA DX,SOURCE                  ;
             INT 21H                        ;
             MOV HANDLE1,AX                 ; OPEN SOURCE FILE

             MOV AH,3CH                     ;
             MOV CX,0000H                   ;
             LEA DX,DESTI                   ;
             INT 21H                        ; CREATE DESTINATION FILE
             MOV HANDLE2,AX
             
      COPY:  MOV AH,3FH                     ;
             MOV BX,HANDLE1                 ;
             MOV CX,0001H                   ;
             LEA DX,BUFF                    ;
             INT 21H                        ; READ SOURCE FILE BYTE BY BYTE
             CMP AX,0000H
             JE CLOSE                       ; IF EOF,CLOSE ALL FILE
             
             MOV AH,40H                     ;
             MOV BX,HANDLE2                 ;
             MOV CX,0001H                   ;
             LEA DX,BUFF                    ;
             INT 21H                        ;
             JMP COPY                       ; WRITE BUFF INTO SOURCE FILE
             
     CLOSE:  MOV AH,3EH                     ;
             LEA BX,HANDLE1                 ;
             INT 21H                        ; CLOSE SOURCE FILE
             
             MOV AH,3EH                     ;
             LEA BX,HANDLE2                 ;
             INT 21H                        ; CLOSE DESTINATION FILE

             DISP MESS2                     ; DISPLAY 2ND MESSAGE 

     QUIT:   MOV AH,4CH
             INT 21H
             CODE ENDS
                  END START
