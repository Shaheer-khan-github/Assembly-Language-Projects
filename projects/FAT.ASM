
                          ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                          ; PROGRAM:- DISPLAY FAT CHAIN.
                          ; RAKESH KUMAR
                          ; ROLL NO. 23
                          ; TE COMP-2
                          ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         
     DATA SEGMENT
             M1       DB 10,13,"ENTER THE FILE NAME : $"
             M3       DB 10,13,"      FILE NOT FOUND !      $"
             M4       DB 10,13,"      READING ERROR !!      $"
             M5       DB 10,13,"SECTOR COVERED BY THIS FILE ARE ..$"
             NLINE    DB 10,13,"$"
             DIRBUFF  DB 14*512 DUP(?)
             FATBUFF  DB 18*512 DUP(?)
             SECBUFF  DB 512    DUP(?)
             FNAME    DB 11     DUP(' ')
             TEMP     DW ?
             BUFF     DB 4      DUP(' ')
      PRINT MACRO MESS
             MOV AH,09H
             LEA DX,MESS
             INT 21H
            ENDM
     CLRSCR MACRO
             MOV AX,0600H
             MOV BH,14
             MOV CX,0000H
             MOV DX,184FH
             INT 10H
             ENDM
     DATA ENDS

     CODE SEGMENT
             ASSUME CS:CODE,DS:DATA
       START:MOV AX,DATA
             MOV DS,AX
             MOV ES,AX

             PRINT M1
             CALL ACCEPT

             MOV AL,0                    ; DRIVE NO 
             MOV CX,14                   ; NO OF SECTOR TO BE READ
             MOV DX,19                   ; STARTING SECTOR
             LEA BX,DIRBUFF              ; 
             INT 25H

             POP AX                      ;;
             JNC CONT
        EROR:PRINT M4
             JMP QUIT
        CONT:    
             LEA SI,FNAME
             LEA DI,DIRBUFF
             MOV TEMP,DI
             MOV BX,224                  ; (14*512)/32=224,NO OF ENTERIES TO BE CHECKED
         L2: MOV CX,11                   ; NO OF BYTE TO BE CHECKED(FILE NAME)
             CLD                         ; CLEAR DIECTION FLAG
             REPE CMPSB
             JZ  FOUND

             ADD TEMP,20H
             MOV DI,TEMP
             LEA SI,FNAME
             DEC BX
             JNZ L2

             PRINT M3
             JMP QUIT
       FOUND:
             CLRSCR
             PRINT M5
             PRINT NLINE
             MOV DI,TEMP
             MOV BX,WORD PTR[DI+1AH]
             MOV TEMP,BX                   ;SAVE FIRST CLUSTER NO.

             MOV AL,0                      ; DRIVE NO 
             MOV CX,18                     ; NO OF SECTOR TO BE READ
             MOV DX,1                      ; STARTING SECTOR
             LEA BX,FATBUFF                ; READ FAT INTO THE BUFFER
             INT 25H                       ;
             POP AX                        ;;
             JC EROR

         L4: MOV BX,TEMP
             CALL DISP_NUM
             PRINT NLINE
             MOV BX,TEMP
             CALL DISP_REC
             PRINT NLINE
             MOV BX,TEMP
             SHR BX,1                       ; [ MULTIPLY CLUSTER NO. 
             ADD BX,TEMP                    ;   BY 1.5 ]
             MOV BX,WORD PTR FATBUFF[BX]
             SHR TEMP,1
             JNC EVE
             MOV CL,4
             SHR BX,CL
       EVE: 
             AND BX,0FFFH
             MOV TEMP,BX
             CMP BX,0FFFH                   ; CHECK 4 EOF
             JNZ L4                         ;

             CALL DISP_NUM                  ; PRINT END OF FILE(0FFF)   
       QUIT: MOV AH,4CH
             INT 21H
;-------------------------------------------

       DISP_NUM PROC
             MOV CL,04H
             MOV CH,04H
        L5:  ROL BX,CL
             MOV DX,BX
             AND DX,000FH
             CMP DX,000AH
             JB L6
             ADD DX,007H
        L6:  ADD DX,0030H
             MOV AH,02H
             INT 21H
             DEC CH
             JNZ L5 
             RET
       DISP_NUM ENDP

      ACCEPT PROC
             MOV SI,0
             MOV CX,8                    ; COUNTER FOR FILE NAME
         L1: MOV AH,01H
             INT 21H
             CMP AL,0DH
             JE  DONE
             CMP AL,'.' 
             JNE N1

             MOV SI,8                    ; WRITE EXTENTION AFTERE 8
             MOV CX,3                    ; INITIALIZE COUNTER 3
             JMP L1                      ; FOR EXTENSION
         N1:
             CMP AL,'A'
             JC N2
             AND AL,0DFH                 ; MAKING SMALL TO CAPITAL
         N2: MOV FNAME[SI],AL
             INC SI
             LOOP L1
        DONE:RET
      ACCEPT ENDP

      DISP_REC PROC
             MOV AL,0                    ; DRIVE NO 
             MOV CX,01                   ; NO OF SECTOR TO BE READ
             MOV DX,BX                   ; STARTING SECTOR
             ADD DX,31
             LEA BX,SECBUFF              ; READ FAT INTO THE BUFFER
             INT 25H                     ;
             POP AX                      ;;

             MOV SI,0
             MOV CX,512                  ;  DISP 512 CHARACTER
        L7:  MOV DL,BYTE PTR SECBUFF[SI]
             MOV AH,02H
             INT 21H
             INC SI           
             LOOP L7
             RET
      DISP_REC ENDP

        CODE ENDS
             END START
