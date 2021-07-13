;-------------------------------------------------------------
;             PROGRAM TO READ BAD SECTOR
;             RAKESH KUMAR
;             TE COMP-2
;-------------------------------------------------------------
     DATA SEGMENT
           RES        DB 5 DUP(0)
           TEMP       DW 00
           ROW        DB 10
           COL        DB 20
           BAD        DW 0
           SECTOR     DW 0 
           PHY_SEC    DB 0 
           REL_SEC    DB 0 
           ABS_SEC    DB 0 
           COUNT      DB 2880
           CYLINDER   DB 0
           SIDE       DB 0
           MES1       DB "CHECKING SECTOR NO.      : $"
           MES2       DB "NO. OF BAD SECTORS FOUND : $"
      SETCUR MACRO
             MOV AH,02H
             MOV BH,00H
             MOV DH,ROW
             MOV DL,COL
             INT 10H
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
       START:ASSUME CS:CODE,DS:DATA
             MOV AX,DATA
             MOV DS,AX
             MOV ES,AX
             CLRSCR                    ;MACRO
             SETCUR                    ;MACRO

             MOV AH,09H
             LEA DX,MES1
             INT 21H                   ;DISPLAY 1ST MESS

             ADD ROW,05H
             SETCUR                    ;MACRO

             MOV AH,09H
             LEA DX,MES2
             INT 21H                   ;DISPLAY 2ND MESS

      LOOP1: MOV AX,SECTOR
             MOV DH,36                 ;;NO OF SEC. IN 1 SYLINDER
             DIV DH
             MOV CYLINDER,AL           ;QUOTIENT AS CYLINDER NO
             MOV ABS_SEC,AH            ;REMAINDER AS ABSOLUTE SECTOR NO
             MOV AL,ABS_SEC
             MOV AH,00H
             MOV DH,18
             DIV DH                    ;ABS SECTOR NO/18
             MOV SIDE,AL               ;QUOTIENT AS SIDE NO.
             MOV REL_SEC,AH            ;REMAINDER AS RELATIVE SECTOR NO
             INC AH                    ;TO GET PHYSICAL SECTOR NO.
             MOV PHY_SEC,AH
           
             MOV AH,04                 ;REQUEST FOR VERIFY SECTOR
             MOV AL,01                 ;NO OF SECTORS ONE AT A TIME
             MOV CH,CYLINDER
             MOV CL,PHY_SEC
             MOV DH,SIDE
             MOV DL,00H                ;DRIVE NOS
             INT 13H
             JNC  NOTBAD
             INC BAD
             MOV ROW,15
             MOV COL,50
             SETCUR
             MOV DX,BAD
             MOV TEMP,DX
             CALL HEX_BCD

     NOTBAD: INC SECTOR
             MOV ROW,10
             MOV COL,50
             SETCUR
             MOV DX,SECTOR
             MOV TEMP,DX
             CALL HEX_BCD
             DEC COUNT
             CMP COUNT,00H
             JE EXIT
             JMP LOOP1

     HEX_BCD PROC
             MOV DI,00H
             MOV BX,0AH            
             MOV AX,TEMP
      BACK1: MOV DX,00H
             DIV BX
             MOV RES[DI],DL
             INC DI
             CMP AX,00H
             JNE BACK1
      BACK2: DEC DI
             MOV DL,RES[DI]
             CALL DISPNUM
             CMP DI,00H
             JNE BACK2
             RET
     HEX_BCD ENDP

     DISPNUM PROC
             ADD DL,30H
             MOV AH,02H     
             INT 21H
             RET
     DISPNUM ENDP

        EXIT:MOV AH,4CH
             INT 21H
     CODE ENDS
          END START
